import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error.dart';
import '../domain/public_events_repository.dart';
import '../domain/public_org.dart';

class RealPublicEventsRepository implements PublicEventsRepository {
  RealPublicEventsRepository(this._api);

  final ApiClient _api;

  String _base(String org) => '/public/orgs/${Uri.encodeComponent(org)}';

  void _require() {
    if (!isAvailable(Feature.attendeeMode, ApiMode.real)) throw ApiError.notAvailable();
  }

  @override
  Future<PublicOrg> getOrg(String orgSlug) async {
    _require();
    final json = await _api.get(_base(orgSlug));
    return PublicOrg.fromJson(json['org'] as Map<String, dynamic>);
  }

  @override
  Future<PublicEventsPage> listEvents(String orgSlug) async {
    _require();
    return PublicEventsPage.fromJson(await _api.get('${_base(orgSlug)}/events'));
  }

  @override
  Future<PublicEventPage> getEvent(String orgSlug, String eventSlug) async {
    _require();
    return PublicEventPage.fromJson(
      await _api.get('${_base(orgSlug)}/events/${Uri.encodeComponent(eventSlug)}'),
    );
  }
}
