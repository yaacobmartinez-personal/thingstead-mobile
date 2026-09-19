import 'dart:math';

import 'package:drift/drift.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/storage/db/app_database.dart';
import '../../../../core/time/clock.dart';
import '../domain/checkin_repository.dart';
import '../domain/scan_result.dart';

/// Why a drain stopped early.
enum DrainStop { none, unauthorized, forbidden, transport }

class DrainResult {
  const DrainResult({this.synced = 0, this.attention = 0, this.stop = DrainStop.none});

  final int synced;
  final int attention;
  final DrainStop stop;
}

/// Replays queued check-ins, oldest first, with the conflict rules from the
/// plan:
///
/// - manual → 200: synced, cache takes the server timestamp; 404: attention.
/// - scan → checked_in / already: synced, server `at` wins; invalid /
///   wrong_event / cancelled / waitlist: attention, and any optimistic local
///   check-in is reverted.
/// - 401: stop (the auth controller signs out); ops stay pending.
/// - 403: stop, the list is marked blocked by membership.
/// - transport / 5xx: exponential backoff, attention after [maxAttempts].
/// - 400 on `at` (phone clock too far ahead): replayed once without the door
///   time, then synced; attention only if that fails too.
/// - other 4xx: attention with the message.
class SyncWorker {
  SyncWorker(this._db, this._repo, this._clock);

  final AppDatabase _db;
  final CheckinRepository _repo;
  final Clock _clock;

  static const maxAttempts = 20;
  static const maxBackoff = Duration(minutes: 5);

  bool _draining = false;
  bool get draining => _draining;

  /// Single-flight: a second call while one is running returns immediately.
  Future<DrainResult> drain() async {
    if (_draining) return const DrainResult();
    _draining = true;
    var synced = 0;
    var attention = 0;
    var stop = DrainStop.none;
    try {
      await _db.recoverInterrupted();
      final ops = await _db.dueOps(_clock());
      for (final op in ops) {
        await _db.updateOp(op.id, const PendingCheckinsCompanion(state: Value(AppDatabase.stateSyncing)));
        try {
          final outcome = await _replay(op);
          if (outcome) {
            synced++;
          } else {
            attention++;
          }
        } on ApiError catch (e) {
          if (e.isUnauthorized) {
            await _backToPending(op);
            stop = DrainStop.unauthorized;
            break;
          }
          if (e.isForbidden) {
            await _backToPending(op);
            if (op.eventSlug != null) {
              await _db.markListSynced(op.orgSlug, op.eventSlug!, _clock(), error: 'membership');
            }
            stop = DrainStop.forbidden;
            break;
          }
          if (e.isNotFound) {
            await _attention(op, outcome: 'not_found', error: e.message);
            attention++;
            continue;
          }
          if (e.isNetwork || e.status >= 500) {
            final gaveUp = await _backoff(op, e.message);
            if (gaveUp) attention++;
            stop = DrainStop.transport;
            break;
          }
          if (_rejectedDoorTime(e)) {
            // This phone's clock is more than the server tolerates ahead, and
            // clientAt is persisted, so resending would fail the same way for
            // ever. Replay once without it: the server stamps now (the
            // pre-#24 behaviour), which beats parking a real attendance.
            try {
              if (await _replay(op, withDoorTime: false)) {
                synced++;
              } else {
                attention++;
              }
              continue;
            } on ApiError catch (retry) {
              await _attention(op, error: retry.message);
              attention++;
              continue;
            }
          }
          await _attention(op, error: e.message);
          attention++;
        }
      }
    } finally {
      _draining = false;
    }
    return DrainResult(synced: synced, attention: attention, stop: stop);
  }

  /// A 400 whose field error is on `at`: the server refused the door time as
  /// impossibly far ahead (#24 / E6), as opposed to any other bad request.
  static bool _rejectedDoorTime(ApiError e) => e.status == 400 && e.fieldErrors.containsKey('at');

  /// [withDoorTime] sends the op's `clientAt` as `at` — the door time, not
  /// the drain time; the server clamps it (#24, E6). Off only for the
  /// fast-clock fallback above.
  Future<bool> _replay(PendingCheckin op, {bool withDoorTime = true}) {
    final at = withDoorTime ? op.clientAt : null;
    return op.kind == 'scan' ? _replayScan(op, at: at) : _replayManual(op, at: at);
  }

  Future<bool> _replayManual(PendingCheckin op, {DateTime? at}) async {
    final serverAt = await _repo.setCheckedIn(
      op.orgSlug,
      op.eventSlug ?? '',
      op.registrationId!,
      checkedIn: op.desiredCheckedIn ?? true,
      at: at,
    );
    await _db.setAttendeeCheckedIn(op.orgSlug, op.registrationId!, serverAt);
    await _synced(op, serverAt: serverAt);
    return true;
  }

  Future<bool> _replayScan(PendingCheckin op, {DateTime? at}) async {
    // A server that predates E6 `at` ignores the field and stamps the replay
    // time as before.
    final r = await _repo.scan(op.orgSlug, op.code!, eventSlug: op.eventSlug, at: at);
    switch (r.outcome) {
      case CheckInOutcome.checkedIn || CheckInOutcome.already:
        if (op.registrationId != null) {
          await _db.setAttendeeCheckedIn(op.orgSlug, op.registrationId!, r.at);
        } else if (op.code != null) {
          await _db.setAttendeeCheckedInByToken(op.orgSlug, _token(op.code!), r.at);
        }
        await _synced(op, serverAt: r.at, outcome: r.outcome.name);
        return true;
      default:
        // The optimistic local check-in was wrong; the server knows better.
        if (op.registrationId != null) {
          await _db.setAttendeeCheckedIn(op.orgSlug, op.registrationId!, null);
        }
        await _attention(op, outcome: _wire(r.outcome));
        return false;
    }
  }

  Future<void> _synced(PendingCheckin op, {DateTime? serverAt, String? outcome}) async {
    final now = _clock();
    await _db.updateOp(
      op.id,
      PendingCheckinsCompanion(
        state: const Value(AppDatabase.stateSynced),
        serverCheckedInAt: Value(serverAt),
        serverOutcome: Value(outcome),
        resolvedAt: Value(now),
        lastError: const Value(null),
      ),
    );
    if (op.eventSlug != null) {
      await _db.markListSynced(op.orgSlug, op.eventSlug!, now);
    }
  }

  Future<void> _attention(PendingCheckin op, {String? outcome, String? error}) =>
      _db.updateOp(
        op.id,
        PendingCheckinsCompanion(
          state: const Value(AppDatabase.stateAttention),
          serverOutcome: Value(outcome),
          lastError: Value(error),
          resolvedAt: Value(_clock()),
        ),
      );

  Future<void> _backToPending(PendingCheckin op) => _db.updateOp(
        op.id,
        const PendingCheckinsCompanion(state: Value(AppDatabase.statePending)),
      );

  /// Returns true when the op has been given up on.
  Future<bool> _backoff(PendingCheckin op, String message) async {
    final attempts = op.attempts + 1;
    if (attempts >= maxAttempts) {
      await _attention(op, error: message);
      return true;
    }
    final seconds = min(pow(2, attempts).toInt(), maxBackoff.inSeconds);
    await _db.updateOp(
      op.id,
      PendingCheckinsCompanion(
        state: const Value(AppDatabase.statePending),
        attempts: Value(attempts),
        nextAttemptAt: Value(_clock().add(Duration(seconds: seconds))),
        lastError: Value(message),
      ),
    );
    return false;
  }

  static String _token(String code) {
    final uri = Uri.tryParse(code);
    return uri?.queryParameters['c'] ?? code.trim();
  }

  static String _wire(CheckInOutcome o) => switch (o) {
        CheckInOutcome.checkedIn => 'checked_in',
        CheckInOutcome.already => 'already',
        CheckInOutcome.cancelled => 'cancelled',
        CheckInOutcome.waitlist => 'waitlist',
        CheckInOutcome.wrongEvent => 'wrong_event',
        CheckInOutcome.invalid => 'invalid',
        CheckInOutcome.queuedUnverified => 'queued_unverified',
      };
}
