import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_membership.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/time/clock.dart';
import '../domain/event_detail.dart';
import '../domain/event_input.dart';
import '../domain/event_summary.dart';
import '../domain/org_events_repository.dart';

/// Ports the server's event rules (regista/lib/events.ts and the event
/// actions): unique slugs per org, DRAFT on create, the capacity floor on
/// update, waitlist promotion when room appears, and ADMIN-only delete.
class FakeOrgEventsRepository implements OrgEventsRepository {
  FakeOrgEventsRepository(
    this._store,
    this._latency,
    this._currentUserId, {
    Clock? clock,
    bool Function()? offline,
  })  : _clock = clock ?? (() => DateTime.now().toUtc()),
        _offline = offline ?? (() => false);

  final FakeStore _store;
  final FakeLatency _latency;
  final String? Function() _currentUserId;
  final Clock _clock;

  /// Fake mode has no network; this lets airplane mode still "unplug" the
  /// server so the offline paths can be demoed.
  final bool Function() _offline;

  Future<FakeMembershipContext> _ctx(String org, {Role? minRole}) async {
    if (_offline()) throw ApiError.network();
    await _latency.wait();
    return requireMembership(_store, _currentUserId(), org, minRole: minRole);
  }

  FakeEvent _event(FakeMembershipContext ctx, String slug) {
    final e = _store.eventBySlug(ctx.tenant.id, slug);
    if (e == null) throw ApiError.fromResponse(404, {'error': 'Not found'});
    return e;
  }

  EventDetail _detail(FakeEvent e) => EventDetail(
        id: e.id,
        slug: e.slug,
        title: e.title,
        description: e.description,
        startsAt: e.startsAt,
        endsAt: e.endsAt,
        timezone: e.timezone,
        startsAtLocal: AppTime.toWallClock(e.startsAt, e.timezone),
        endsAtLocal: e.endsAt == null ? null : AppTime.toWallClock(e.endsAt!, e.timezone),
        capacity: e.capacity,
        waitlistEnabled: e.waitlistEnabled,
        status: e.status,
        confirmed: _store.confirmedCount(e.id),
        waitlist: _store.waitlistCount(e.id),
        checkedIn: _store.checkedInCount(e.id),
        createdAt: e.createdAt,
      );

  /// `uniqueEventSlug`: append -2, -3… until free within the org.
  String _uniqueSlug(String tenantId, String desired, {String? exceptEventId}) {
    final base = desired.isEmpty ? 'event' : desired;
    for (var attempt = 0; attempt < 50; attempt++) {
      final candidate = attempt == 0 ? base : '$base-${attempt + 1}';
      final clash = _store.events.any(
        (e) => e.tenantId == tenantId && e.slug == candidate && e.id != exceptEventId,
      );
      if (!clash) return candidate;
    }
    return '$base-${_clock().millisecondsSinceEpoch}';
  }

  /// `promoteFromWaitlist`: longest-waiting people take any room that opened.
  int _promoteFromWaitlist(FakeEvent e) {
    final room = e.capacity == null ? 1 << 30 : e.capacity! - _store.confirmedCount(e.id);
    if (room <= 0) return 0;
    final waiting = _store
        .registrationsOf(e.id)
        .where((r) => r.status == RegistrationStatus.waitlist)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final promote = waiting.take(room).toList();
    for (final r in promote) {
      r.status = RegistrationStatus.confirmed;
    }
    return promote.length;
  }

  void _validate(EventInput input, {String? extraCapacityError}) {
    final errors = input.validate();
    if (extraCapacityError != null) errors['capacity'] = extraCapacityError;
    if (errors.isNotEmpty) {
      throw ApiError.fromResponse(400, {
        'error': 'Check the highlighted fields.',
        'fieldErrors': errors,
      });
    }
  }

  @override
  Future<EventsPage> list(String orgSlug) async {
    final ctx = await _ctx(orgSlug);
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

  @override
  Future<EventDetail> get(String orgSlug, String eventSlug) async {
    final ctx = await _ctx(orgSlug);
    return _detail(_event(ctx, eventSlug));
  }

  @override
  Future<EventDetail> create(String orgSlug, EventInput input) async {
    final ctx = await _ctx(orgSlug);
    _validate(input);
    final e = FakeEvent(
      id: _store.nextId('ev'),
      tenantId: ctx.tenant.id,
      slug: _uniqueSlug(ctx.tenant.id, input.effectiveSlug),
      title: input.title.trim(),
      description: (input.description ?? '').trim().isEmpty ? null : input.description!.trim(),
      startsAt: input.startsAtUtc,
      endsAt: input.endsAtUtc,
      timezone: input.timezone.trim(),
      capacity: input.capacity,
      waitlistEnabled: input.waitlistEnabled,
      status: EventStatus.draft, // publishing is a separate, explicit step
      createdAt: _clock(),
    );
    _store.events.add(e);
    return _detail(e);
  }

  @override
  Future<EventDetail> update(String orgSlug, String eventSlug, EventInput input) async {
    final ctx = await _ctx(orgSlug);
    final e = _event(ctx, eventSlug);
    String? capacityError;
    if (input.capacity != null) {
      final confirmed = _store.confirmedCount(e.id);
      if (input.capacity! < confirmed) {
        capacityError = "$confirmed people already have a place, so capacity can't be "
            'lower than that.';
      }
    }
    _validate(input, extraCapacityError: capacityError);
    e
      ..slug = _uniqueSlug(ctx.tenant.id, input.effectiveSlug, exceptEventId: e.id)
      ..title = input.title.trim()
      ..description =
          (input.description ?? '').trim().isEmpty ? null : input.description!.trim()
      ..startsAt = input.startsAtUtc
      ..endsAt = input.endsAtUtc
      ..timezone = input.timezone.trim()
      ..capacity = input.capacity
      ..waitlistEnabled = input.waitlistEnabled;
    _promoteFromWaitlist(e);
    return _detail(e);
  }

  @override
  Future<EventStatus> setStatus(String orgSlug, String eventSlug, EventStatus status) async {
    final ctx = await _ctx(orgSlug);
    final e = _event(ctx, eventSlug);
    e.status = status;
    return e.status;
  }

  @override
  Future<int> delete(String orgSlug, String eventSlug) async {
    final ctx = await _ctx(orgSlug, minRole: Role.admin);
    final e = _event(ctx, eventSlug);
    final gone = _store.registrationsOf(e.id).length;
    _store.registrations.removeWhere((r) => r.eventId == e.id);
    _store.events.remove(e);
    return gone;
  }
}
