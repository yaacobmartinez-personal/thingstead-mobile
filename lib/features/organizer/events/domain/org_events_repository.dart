import '../../../../core/model/enums.dart';
import 'event_detail.dart';
import 'event_input.dart';
import 'event_summary.dart';

abstract class OrgEventsRepository {
  /// E3 — every event in the org with confirmed / checked-in counts,
  /// ordered by start time. 403 when not a member.
  Future<EventsPage> list(String orgSlug);

  /// #18
  Future<EventDetail> get(String orgSlug, String eventSlug);

  /// #19 — created as DRAFT; 400 fieldErrors on validation.
  Future<EventDetail> create(String orgSlug, EventInput input);

  /// #20 — may change the slug; 400 fieldErrors incl. the capacity floor.
  Future<EventDetail> update(String orgSlug, String eventSlug, EventInput input);

  /// #21
  Future<EventStatus> setStatus(String orgSlug, String eventSlug, EventStatus status);

  /// #22 — ADMIN only. Returns how many registrations went with it.
  Future<int> delete(String orgSlug, String eventSlug);
}
