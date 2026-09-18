import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../domain/ticket.dart';
import '../domain/tickets_repository.dart';

/// The `Ticket` shape from a registration row, shared with the fake
/// registration repository so both sides describe a place the same way.
Ticket ticketFromRegistration(FakeStore store, FakeRegistration r, DateTime now) {
  final event = store.eventById(r.eventId)!;
  final tenant = store.tenantById(r.tenantId)!;
  return Ticket(
    id: r.id,
    status: r.status,
    name: r.name,
    email: r.email ?? '',
    checkedInAt: r.checkedInAt,
    checkInToken: r.checkInToken,
    createdAt: r.createdAt,
    started: !event.startsAt.isAfter(now),
    org: TicketOrg(slug: tenant.slug, name: tenant.name),
    event: TicketEvent(
      slug: event.slug,
      title: event.title,
      startsAt: event.startsAt,
      endsAt: event.endsAt,
      timezone: event.timezone,
    ),
  );
}

/// Ports `inspectRegistration` / `cancelRegistration` in
/// regista/lib/registrations.ts, keyed on the account instead of the mailed
/// token, plus the manage-link import that attaches a row to the account.
class FakeTicketsRepository implements TicketsRepository {
  FakeTicketsRepository(
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
  final bool Function() _offline;

  Future<FakeUser> _me() async {
    if (_offline()) throw ApiError.network();
    await _latency.wait();
    final id = _currentUserId();
    final user = id == null ? null : _store.userById(id);
    if (user == null) throw ApiError.fromResponse(401, {'error': 'Unauthorized'});
    return user;
  }

  Ticket _ticket(FakeRegistration r) => ticketFromRegistration(_store, r, _clock());

  FakeRegistration _mine(FakeUser me, String id) {
    final r = _store.registrationById(id);
    if (r == null || r.userId != me.id || r.erased) {
      throw ApiError.fromResponse(404, {'error': 'Not found'});
    }
    return r;
  }

  @override
  Future<List<Ticket>> list() async {
    final me = await _me();
    final rows = _store.registrations.where((r) => r.userId == me.id && !r.erased).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return [for (final r in rows) _ticket(r)];
  }

  @override
  Future<Ticket> get(String id) async => _ticket(_mine(await _me(), id));

  @override
  Future<Ticket> import(String manageToken) async {
    final me = await _me();
    final r = _store.registrationByManageToken(manageToken.trim());
    if (r == null) throw ApiError.fromResponse(404, {'error': "That link isn't valid anymore."});
    if ((r.email ?? '').toLowerCase() != me.email.toLowerCase()) {
      throw ApiError.fromResponse(403, {
        'error': 'This ticket was registered with a different email address.',
        'reason': 'email_mismatch',
      });
    }
    r.userId = me.id;
    return _ticket(r);
  }

  @override
  Future<CancelOutcome> cancel(String id) async {
    final me = await _me();
    final r = _mine(me, id);
    if (r.status == RegistrationStatus.cancelled) return CancelOutcome.already;
    final event = _store.eventById(r.eventId)!;
    if (!event.startsAt.isAfter(_clock())) return CancelOutcome.started;
    r.status = RegistrationStatus.cancelled;
    return CancelOutcome.cancelled;
  }
}
