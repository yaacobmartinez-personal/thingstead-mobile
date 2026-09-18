import '../../../../core/network/api_client.dart';
import '../domain/attendee.dart';
import '../domain/attendees_repository.dart';

class RealAttendeesRepository implements AttendeesRepository {
  RealAttendeesRepository(this._api);

  final ApiClient _api;

  @override
  Future<AttendeeList> list(String orgSlug, String eventSlug, {String query = ''}) async {
    final q = query.trim();
    final json = await _api.get(
      '/mobile/orgs/${Uri.encodeComponent(orgSlug)}'
      '/events/${Uri.encodeComponent(eventSlug)}/attendees',
      query: q.isEmpty ? null : {'q': q},
    );
    return AttendeeList.fromJson(json);
  }
}
