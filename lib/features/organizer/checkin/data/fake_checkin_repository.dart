import '../../../../core/fake/fake_checkin.dart';
import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_membership.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../domain/checkin_repository.dart';
import '../domain/scan_result.dart';

class FakeCheckinRepository implements CheckinRepository {
  FakeCheckinRepository(this._store, this._latency, this._clock, this._currentUserId);

  final FakeStore _store;
  final FakeLatency _latency;
  final Clock _clock;
  final String? Function() _currentUserId;

  @override
  Future<DateTime?> setCheckedIn(
    String orgSlug,
    String eventSlug,
    String registrationId, {
    required bool checkedIn,
  }) async {
    await _latency.wait();
    final ctx = requireMembership(_store, _currentUserId(), orgSlug);
    // Like the server: matches on (id, tenantId) only.
    final r = _store.registrationById(registrationId);
    if (r == null || r.tenantId != ctx.tenant.id) {
      throw ApiError.fromResponse(404, {'error': 'Not found'});
    }
    if (checkedIn) {
      r.checkedInAt ??= _clock();
    } else {
      r.checkedInAt = null;
    }
    return r.checkedInAt;
  }

  @override
  Future<ScanResult> scan(String orgSlug, String code, {String? eventSlug}) async {
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
