import '../../../../core/network/api_client.dart';
import '../domain/checkin_repository.dart';
import '../domain/scan_result.dart';

class RealCheckinRepository implements CheckinRepository {
  RealCheckinRepository(this._api);

  final ApiClient _api;

  @override
  Future<DateTime?> setCheckedIn(
    String orgSlug,
    String eventSlug,
    String registrationId, {
    required bool checkedIn,
    DateTime? at,
  }) async {
    final json = await _api.post(
      '/mobile/orgs/${Uri.encodeComponent(orgSlug)}'
      '/events/${Uri.encodeComponent(eventSlug)}'
      '/attendees/${Uri.encodeComponent(registrationId)}/checkin',
      body: {
        'checkedIn': checkedIn,
        // Only when the caller knows better than "now" (offline replay).
        'at': ?at?.toUtc().toIso8601String(),
      },
    );
    final stamped = json['checkedInAt'];
    return stamped is String ? DateTime.parse(stamped).toUtc() : null;
  }

  @override
  Future<ScanResult> scan(String orgSlug, String code, {String? eventSlug}) async {
    final json = await _api.post('/mobile/checkin', body: {
      'slug': orgSlug,
      'code': code,
      'eventSlug': ?eventSlug,
    });
    return ScanResult.fromJson(json);
  }
}
