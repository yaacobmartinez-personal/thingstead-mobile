import '../../../../core/network/api_client.dart';
import '../domain/event_summary.dart';
import '../domain/org_events_repository.dart';

class RealOrgEventsRepository implements OrgEventsRepository {
  RealOrgEventsRepository(this._api);

  final ApiClient _api;

  @override
  Future<EventsPage> list(String orgSlug) async {
    final json = await _api.get('/mobile/orgs/${Uri.encodeComponent(orgSlug)}/events');
    return EventsPage.fromJson(json);
  }
}
