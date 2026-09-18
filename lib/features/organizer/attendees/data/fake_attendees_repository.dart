import 'dart:convert';

import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_membership.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../../../../core/util/csv.dart';
import '../../events/domain/event_detail.dart';
import '../domain/attendee.dart';
import '../domain/attendees_repository.dart';

/// Ports the attendee actions in regista (list, promote, erase, export):
/// every write matches on (id, tenantId), promotion respects capacity, and
/// erasure keeps the row but clears everything identifying.
class FakeAttendeesRepository implements AttendeesRepository {
  FakeAttendeesRepository(
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

  static const maxRows = 500;

  Future<FakeMembershipContext> _ctx(String org) async {
    if (_offline()) throw ApiError.network();
    await _latency.wait();
    return requireMembership(_store, _currentUserId(), org);
  }

  FakeEvent _event(FakeMembershipContext ctx, String slug) {
    final e = _store.eventBySlug(ctx.tenant.id, slug);
    if (e == null) throw ApiError.fromResponse(404, {'error': 'Not found'});
    return e;
  }

  FakeRegistration _registration(FakeMembershipContext ctx, String id) {
    final r = _store.registrationById(id);
    if (r == null || r.tenantId != ctx.tenant.id) {
      throw ApiError.fromResponse(404, {'error': 'Not found'});
    }
    return r;
  }

  @override
  Future<AttendeeList> list(String orgSlug, String eventSlug, {String query = ''}) async {
    final ctx = await _ctx(orgSlug);
    final event = _event(ctx, eventSlug);

    final q = query.trim().toLowerCase();
    final rows = _store.registrationsOf(event.id).where((r) {
      if (q.isEmpty) return true;
      return (r.name ?? '').toLowerCase().contains(q) ||
          (r.email ?? '').toLowerCase().contains(q);
    }).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return AttendeeList(
      event: AttendeeEventRef(
        title: event.title,
        timezone: event.timezone,
        capacity: event.capacity,
        waitlist: _store.waitlistCount(event.id),
      ),
      attendees: [
        for (final r in rows.take(maxRows))
          Attendee(
            id: r.id,
            name: r.erased ? null : r.name,
            email: r.erased ? null : r.email,
            status: r.status,
            checkedInAt: r.checkedInAt,
            erased: r.erased,
            // API-CONTRACT #23: present in fake mode so offline scans resolve.
            checkInToken: r.erased ? null : r.checkInToken,
          ),
      ],
    );
  }

  @override
  Future<PromoteOutcome> promote(String orgSlug, String eventSlug, String registrationId) async {
    final ctx = await _ctx(orgSlug);
    final r = _store.registrationById(registrationId);
    if (r == null || r.tenantId != ctx.tenant.id || r.status != RegistrationStatus.waitlist) {
      return PromoteOutcome.gone;
    }
    final event = _store.eventById(r.eventId);
    if (event == null) return PromoteOutcome.gone;
    if (event.capacity != null && _store.confirmedCount(event.id) >= event.capacity!) {
      return PromoteOutcome.full;
    }
    r.status = RegistrationStatus.confirmed;
    return PromoteOutcome.promoted;
  }

  @override
  Future<void> erase(String orgSlug, String eventSlug, String registrationId) async {
    final ctx = await _ctx(orgSlug);
    final r = _registration(ctx, registrationId);
    if (r.erased) return; // already erased
    r
      ..name = null
      ..email = 'deleted+${r.id}@anon.invalid'
      ..checkedInAt = null
      ..manageToken = null
      ..checkInToken = null
      ..userId = null
      ..anonymizedAt = _clock();
  }

  @override
  Future<(List<int>, String)> exportCsv(String orgSlug, String eventSlug) async {
    final ctx = await _ctx(orgSlug);
    final event = _event(ctx, eventSlug);
    final rows = _store.registrationsOf(event.id).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // Same columns and escaping as attendees/export/route.ts + lib/csv.ts.
    final csv = toCsv(
      ['Name', 'Email', 'Status', 'Checked in', 'Registered at'],
      [
        for (final r in rows)
          [
            r.erased ? '(erased)' : r.name,
            r.erased ? '(erased)' : r.email,
            r.status.wire,
            r.checkedInAt?.toIso8601String() ?? '',
            r.createdAt.toIso8601String(),
          ],
      ],
    );
    return (utf8.encode(csv), '${filenameSlug(event.title)}-attendees.csv');
  }
}
