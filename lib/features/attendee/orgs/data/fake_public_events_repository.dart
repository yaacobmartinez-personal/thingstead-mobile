import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../domain/public_events_repository.dart';
import '../domain/public_org.dart';

/// Ports the public tenant pages (`app/[domain]/page.tsx` and
/// `[eventSlug]/page.tsx`): only ACTIVE orgs resolve, only PUBLISHED events
/// show, and drafts/closed events 404 like they never existed.
class FakePublicEventsRepository implements PublicEventsRepository {
  FakePublicEventsRepository(this._store, this._latency, {bool Function()? offline})
      : _offline = offline ?? (() => false);

  final FakeStore _store;
  final FakeLatency _latency;
  final bool Function() _offline;

  Future<FakeTenant> _tenant(String slug) async {
    if (_offline()) throw ApiError.network();
    await _latency.wait();
    final t = _store.activeTenantBySlug(slug.trim().toLowerCase());
    if (t == null) throw ApiError.fromResponse(404, {'error': 'Not found'});
    return t;
  }

  PublicOrg _org(FakeTenant t) => PublicOrg(slug: t.slug, name: t.name);

  PublicEvent _event(FakeEvent e, {bool withDescription = false}) {
    final confirmed = _store.confirmedCount(e.id);
    final remaining = e.capacity == null ? null : (e.capacity! - confirmed).clamp(0, 1 << 30);
    return PublicEvent(
      slug: e.slug,
      title: e.title,
      description: withDescription ? e.description : null,
      startsAt: e.startsAt,
      endsAt: e.endsAt,
      timezone: e.timezone,
      capacity: e.capacity,
      remaining: remaining,
      isFull: remaining != null && remaining == 0,
      waitlistEnabled: e.waitlistEnabled,
    );
  }

  @override
  Future<PublicOrg> getOrg(String orgSlug) async => _org(await _tenant(orgSlug));

  @override
  Future<PublicEventsPage> listEvents(String orgSlug) async {
    final t = await _tenant(orgSlug);
    final events = _store
        .eventsOf(t.id)
        .where((e) => e.status == EventStatus.published)
        .toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return PublicEventsPage(org: _org(t), events: [for (final e in events) _event(e)]);
  }

  @override
  Future<PublicEventPage> getEvent(String orgSlug, String eventSlug) async {
    final t = await _tenant(orgSlug);
    final e = _store.eventBySlug(t.id, eventSlug.trim().toLowerCase());
    if (e == null || e.status != EventStatus.published) {
      throw ApiError.fromResponse(404, {'error': 'Not found'});
    }
    return PublicEventPage(org: _org(t), event: _event(e, withDescription: true));
  }
}
