import 'event_summary.dart';

abstract class OrgEventsRepository {
  /// E3 — every event in the org with confirmed / checked-in counts,
  /// ordered by start time. 403 when not a member.
  Future<EventsPage> list(String orgSlug);
}
