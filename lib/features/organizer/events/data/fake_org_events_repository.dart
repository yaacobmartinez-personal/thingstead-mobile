import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_membership.dart';
import '../../../../core/fake/fake_store.dart';
import '../domain/event_summary.dart';
import '../domain/org_events_repository.dart';

class FakeOrgEventsRepository implements OrgEventsRepository {
  FakeOrgEventsRepository(this._store, this._latency, this._currentUserId);

  final FakeStore _store;
  final FakeLatency _latency;
  final String? Function() _currentUserId;

  @override
  Future<EventsPage> list(String orgSlug) async {
    await _latency.wait();
    final ctx = requireMembership(_store, _currentUserId(), orgSlug);
    final events = _store.eventsOf(ctx.tenant.id).toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return EventsPage(
      org: OrgRef(slug: ctx.tenant.slug, name: ctx.tenant.name),
      events: [
        for (final e in events)
          EventSummary(
            slug: e.slug,
            title: e.title,
            startsAt: e.startsAt,
            endsAt: e.endsAt,
            timezone: e.timezone,
            capacity: e.capacity,
            status: e.status,
            confirmed: _store.confirmedCount(e.id),
            checkedIn: _store.checkedInCount(e.id),
          ),
      ],
    );
  }
}
