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
  }) async {
    final json = await _api.post(
      '/mobile/orgs/${Uri.encodeComponent(orgSlug)}'
      '/events/${Uri.encodeComponent(eventSlug)}'
      '/attendees/${Uri.encodeComponent(registrationId)}/checkin',
      body: {'checkedIn': checkedIn},
    );
    final at = json['checkedInAt'];
    return at is String ? DateTime.parse(at).toUtc() : null;
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
