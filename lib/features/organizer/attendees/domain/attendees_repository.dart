import '../../events/domain/event_detail.dart';
import 'attendee.dart';

abstract class AttendeesRepository {
  /// E4 — up to 500 registrations, oldest first. [query] is a
  /// case-insensitive contains on name or email; the app usually fetches
  /// unfiltered and searches locally.
  Future<AttendeeList> list(String orgSlug, String eventSlug, {String query = ''});

  /// #25 — move one waitlisted person into a confirmed place.
  Future<PromoteOutcome> promote(String orgSlug, String eventSlug, String registrationId);

  /// #26 — right to erasure; idempotent.
  Future<void> erase(String orgSlug, String eventSlug, String registrationId);

  /// #27 — the CSV bytes and the filename the server suggests.
  Future<(List<int> bytes, String filename)> exportCsv(String orgSlug, String eventSlug);
}
