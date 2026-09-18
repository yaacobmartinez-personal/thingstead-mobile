import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/util/csv.dart';
import '../../events/domain/event_detail.dart';
import '../domain/attendee.dart';
import '../domain/attendees_repository.dart';

class RealAttendeesRepository implements AttendeesRepository {
  RealAttendeesRepository(this._api);

  final ApiClient _api;

  String _base(String org, String event) =>
      '/mobile/orgs/${Uri.encodeComponent(org)}/events/${Uri.encodeComponent(event)}/attendees';

  void _require(Feature f) {
    if (!isAvailable(f, ApiMode.real)) throw ApiError.notAvailable();
  }

  @override
  Future<AttendeeList> list(String orgSlug, String eventSlug, {String query = ''}) async {
    final q = query.trim();
    final json = await _api.get(_base(orgSlug, eventSlug), query: q.isEmpty ? null : {'q': q});
    return AttendeeList.fromJson(json);
  }

  @override
  Future<PromoteOutcome> promote(String orgSlug, String eventSlug, String registrationId) async {
    _require(Feature.promoteErase);
    final json = await _api.post(
      '${_base(orgSlug, eventSlug)}/${Uri.encodeComponent(registrationId)}/promote',
    );
    return switch (json['outcome']) {
      'promoted' => PromoteOutcome.promoted,
      'full' => PromoteOutcome.full,
      _ => PromoteOutcome.gone,
    };
  }

  @override
  Future<void> erase(String orgSlug, String eventSlug, String registrationId) async {
    _require(Feature.promoteErase);
    await _api.post('${_base(orgSlug, eventSlug)}/${Uri.encodeComponent(registrationId)}/erase');
  }

  @override
  Future<(List<int>, String)> exportCsv(String orgSlug, String eventSlug) async {
    _require(Feature.csvExport);
    final (bytes, headers) = await _api.getBytes('${_base(orgSlug, eventSlug)}/export');
    final disposition = headers.value('content-disposition') ?? '';
    final match = RegExp(r'filename="?([^";]+)"?').firstMatch(disposition);
    return (bytes, match?.group(1) ?? '${filenameSlug(eventSlug)}-attendees.csv');
  }
}
