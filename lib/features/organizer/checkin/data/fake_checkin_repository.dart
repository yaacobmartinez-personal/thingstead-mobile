import '../../../../core/fake/fake_checkin.dart';
import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_membership.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../domain/checkin_repository.dart';
import '../domain/scan_result.dart';

class FakeCheckinRepository implements CheckinRepository {
  FakeCheckinRepository(this._store, this._latency, this._clock, this._currentUserId, {bool Function()? offline})
      : _offline = offline ?? (() => false);

  final FakeStore _store;

  /// Fake mode has no network; this lets airplane mode still "unplug" the
  /// server so the offline paths can be demoed.
  final bool Function() _offline;
  final FakeLatency _latency;
  final Clock _clock;
  final String? Function() _currentUserId;

  /// How far ahead of the server clock a client `at` may be (#24).
  static const futureTolerance = Duration(minutes: 5);

  @override
  Future<DateTime?> setCheckedIn(
    String orgSlug,
    String eventSlug,
    String registrationId, {
    required bool checkedIn,
    DateTime? at,
  }) async {
    if (_offline()) throw ApiError.network();
    await _latency.wait();
    final ctx = requireMembership(_store, _currentUserId(), orgSlug);
    // Like the server: matches on (id, tenantId) only.
    final r = _store.registrationById(registrationId);
    if (r == null || r.tenantId != ctx.tenant.id) {
      throw ApiError.fromResponse(404, {'error': 'Not found'});
    }
    final now = _clock();
    // #24: `at` is clamped into [createdAt, now]; a clock more than five
    // minutes fast is refused rather than silently corrected.
    if (at != null && at.isAfter(now.add(futureTolerance))) {
      throw ApiError.fromResponse(400, {'error': 'Check-in time is in the future.'});
    }
    if (checkedIn) {
      final stamp = at == null
          ? now
          : at.isBefore(r.createdAt)
              ? r.createdAt
              : at.isAfter(now)
                  ? now
                  : at.toUtc();
      r.checkedInAt ??= stamp;
    } else {
      r.checkedInAt = null;
    }
    return r.checkedInAt;
  }

  @override
  Future<ScanResult> scan(String orgSlug, String code, {String? eventSlug}) async {
    if (_offline()) throw ApiError.network();
    await _latency.wait();
    final ctx = requireMembership(_store, _currentUserId(), orgSlug);
    String? requireEventId;
    if (eventSlug != null) {
      final event = _store.eventBySlug(ctx.tenant.id, eventSlug);
      if (event == null) return const ScanResult(outcome: CheckInOutcome.invalid);
      requireEventId = event.id;
    }
    return performFakeCheckIn(
      _store,
      tenantId: ctx.tenant.id,
      rawCode: code,
      requireEventId: requireEventId,
      now: _clock(),
    );
  }
}
