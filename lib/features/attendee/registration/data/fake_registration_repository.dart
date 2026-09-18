import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../../tickets/data/fake_tickets_repository.dart';
import '../domain/register_result.dart';
import '../domain/registration_repository.dart';

/// Ports the `register` action in regista/app/[domain]/[eventSlug]/actions.tsx:
/// closed unless the org is ACTIVE and the event PUBLISHED, one live
/// registration per (event, email), full-vs-waitlist decided on capacity,
/// and a cancelled row is reused at the back of the queue.
class FakeRegistrationRepository implements RegistrationRepository {
  FakeRegistrationRepository(
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

  static const maxName = 120;

  @override
  Future<RegisterResult> register(String orgSlug, String eventSlug, {required String name}) async {
    if (_offline()) throw ApiError.network();
    await _latency.wait();
    final id = _currentUserId();
    final me = id == null ? null : _store.userById(id);
    if (me == null) throw ApiError.fromResponse(401, {'error': 'Unauthorized'});

    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > maxName) {
      throw ApiError.fromResponse(400, {
        'error': 'Check the highlighted fields.',
        'fieldErrors': {
          'name': trimmed.isEmpty ? 'Tell us your name.' : 'Keep your name under $maxName characters.',
        },
      });
    }

    final tenant = _store.activeTenantBySlug(orgSlug.trim().toLowerCase());
    if (tenant == null) return const RegisterResult(outcome: RegisterOutcome.closed);
    final event = _store.eventBySlug(tenant.id, eventSlug.trim().toLowerCase());
    if (event == null || event.status != EventStatus.published) {
      return const RegisterResult(outcome: RegisterOutcome.closed);
    }

    final email = me.email.toLowerCase();
    final now = _clock();
    final existing = _store
        .registrationsOf(event.id)
        .where((r) => (r.email ?? '').toLowerCase() == email)
        .firstOrNull;
    if (existing != null && existing.status != RegistrationStatus.cancelled) {
      // Claim it for the account if it was made on the web without one.
      existing.userId ??= me.id;
      return RegisterResult(
        outcome: RegisterOutcome.duplicate,
        ticket: ticketFromRegistration(_store, existing, now),
      );
    }

    final confirmed = _store.confirmedCount(event.id);
    final isFull = event.capacity != null && confirmed >= event.capacity!;
    if (isFull && !event.waitlistEnabled) {
      return const RegisterResult(outcome: RegisterOutcome.full);
    }
    final status = isFull ? RegistrationStatus.waitlist : RegistrationStatus.confirmed;

    // A cancelled row is reused (same id) but goes to the back of the queue
    // with fresh tokens, exactly as the web does.
    final rowId = existing?.id ?? _store.nextId('r');
    final row = FakeRegistration(
      id: rowId,
      tenantId: tenant.id,
      eventId: event.id,
      userId: me.id,
      name: trimmed,
      email: email,
      status: status,
      manageToken: 'manage_${rowId}_${_store.nextId('tok')}',
      checkInToken: 'chk_${rowId}_${_store.nextId('tok')}',
      createdAt: now,
    );
    if (existing != null) _store.registrations.remove(existing);
    _store.registrations.add(row);
    _store.outbox.add(FakeEmail(
      to: email,
      kind: FakeEmailKind.registration,
      token: row.manageToken!,
      sentAt: now,
    ));
    return RegisterResult(
      outcome: isFull ? RegisterOutcome.waitlisted : RegisterOutcome.confirmed,
      ticket: ticketFromRegistration(_store, row, now),
    );
  }
}
