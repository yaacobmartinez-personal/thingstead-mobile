import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/storage/db/app_database.dart';
import '../../../../core/time/clock.dart';
import '../domain/pending_op.dart';

part 'checkin_queue.g.dart';

/// Adds check-ins to the offline queue and exposes it to the UI.
class CheckinQueue {
  CheckinQueue(this._db, this._clock, [Uuid? uuid]) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  /// A manual toggle. Repeated toggles on one person collapse into the last
  /// desired state instead of queueing a flip-flop.
  Future<void> enqueueManual({
    required String org,
    required String event,
    required String registrationId,
    required bool desired,
    String? name,
  }) async {
    final now = _clock();
    final open = await _db.openManualOp(org, registrationId);
    if (open != null) {
      await _db.updateOp(
        open.id,
        PendingCheckinsCompanion(
          desiredCheckedIn: Value(desired),
          clientAt: Value(now),
          state: const Value(AppDatabase.statePending),
        ),
      );
      return;
    }
    await _db.enqueue(PendingCheckinsCompanion.insert(
      id: _uuid.v4(),
      orgSlug: org,
      eventSlug: Value(event),
      kind: 'manual',
      registrationId: Value(registrationId),
      desiredCheckedIn: Value(desired),
      attendeeName: Value(name),
      clientAt: now,
      createdAt: now,
      nextAttemptAt: now,
    ));
  }

  /// A scan. [registrationId] is known when the cache resolved the token;
  /// a blind scan (unknown token) carries only the code.
  Future<void> enqueueScan({
    required String org,
    String? event,
    required String code,
    String? registrationId,
    String? name,
  }) async {
    final now = _clock();
    await _db.enqueue(PendingCheckinsCompanion.insert(
      id: _uuid.v4(),
      orgSlug: org,
      eventSlug: Value(event),
      kind: 'scan',
      registrationId: Value(registrationId),
      code: Value(code),
      attendeeName: Value(name),
      clientAt: now,
      createdAt: now,
      nextAttemptAt: now,
    ));
  }

  Future<void> dismiss(String id) => _db.deleteOp(id);

  /// Put an attention item back in the queue to try again.
  Future<void> retry(String id) => _db.updateOp(
        id,
        PendingCheckinsCompanion(
          state: const Value(AppDatabase.statePending),
          attempts: const Value(0),
          nextAttemptAt: Value(_clock()),
          lastError: const Value(null),
          serverOutcome: const Value(null),
        ),
      );

  Stream<List<PendingOp>> watchAttention() => _db
      .watchOpenOps()
      .map((rows) => [
            for (final r in rows)
              if (r.state == AppDatabase.stateAttention) PendingOp.fromRow(r),
          ]);
}

@Riverpod(keepAlive: true)
CheckinQueue checkinQueue(Ref ref) =>
    CheckinQueue(ref.watch(appDatabaseProvider), ref.watch(clockProvider));

@riverpod
Stream<List<PendingOp>> attentionOps(Ref ref) =>
    ref.watch(checkinQueueProvider).watchAttention();
