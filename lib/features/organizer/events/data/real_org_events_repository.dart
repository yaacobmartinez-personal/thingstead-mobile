import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error.dart';
import '../domain/event_detail.dart';
import '../domain/event_input.dart';
import '../domain/event_summary.dart';
import '../domain/org_events_repository.dart';

class RealOrgEventsRepository implements OrgEventsRepository {
  RealOrgEventsRepository(this._api);

  final ApiClient _api;

  String _base(String org) => '/mobile/orgs/${Uri.encodeComponent(org)}/events';
  String _one(String org, String slug) => '${_base(org)}/${Uri.encodeComponent(slug)}';

  void _requireCrud() {
    if (!isAvailable(Feature.eventCrud, ApiMode.real)) throw ApiError.notAvailable();
  }

  @override
  Future<EventsPage> list(String orgSlug) async =>
      EventsPage.fromJson(await _api.get(_base(orgSlug)));

  @override
  Future<EventDetail> get(String orgSlug, String eventSlug) async {
    _requireCrud();
    final json = await _api.get(_one(orgSlug, eventSlug));
    return EventDetail.fromJson(json['event'] as Map<String, dynamic>);
  }

  @override
  Future<EventDetail> create(String orgSlug, EventInput input) async {
    _requireCrud();
    final json = await _api.post(_base(orgSlug), body: input.toJson());
    return EventDetail.fromJson(json['event'] as Map<String, dynamic>);
  }

  @override
  Future<EventDetail> update(String orgSlug, String eventSlug, EventInput input) async {
    _requireCrud();
    final json = await _api.patch(_one(orgSlug, eventSlug), body: input.toJson());
    return EventDetail.fromJson(json['event'] as Map<String, dynamic>);
  }

  @override
  Future<EventStatus> setStatus(String orgSlug, String eventSlug, EventStatus status) async {
    _requireCrud();
    final json = await _api.post('${_one(orgSlug, eventSlug)}/status', body: {'status': status.wire});
    return EventStatus.fromWire((json['event'] as Map<String, dynamic>)['status'] as String);
  }

  @override
  Future<int> delete(String orgSlug, String eventSlug) async {
    _requireCrud();
    final json = await _api.delete(_one(orgSlug, eventSlug));
    return (json['registrationsDeleted'] as num?)?.toInt() ?? 0;
  }
}
