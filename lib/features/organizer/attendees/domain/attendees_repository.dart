import 'attendee.dart';

abstract class AttendeesRepository {
  /// E4 — up to 500 registrations, oldest first. [query] is a
  /// case-insensitive contains on name or email; the app usually fetches
  /// unfiltered and searches locally.
  Future<AttendeeList> list(String orgSlug, String eventSlug, {String query = ''});
}
