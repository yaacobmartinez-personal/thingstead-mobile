import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_membership.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/network/api_error.dart';
import '../domain/attendee.dart';
import '../domain/attendees_repository.dart';

class FakeAttendeesRepository implements AttendeesRepository {
  FakeAttendeesRepository(this._store, this._latency, this._currentUserId, {bool Function()? offline})
      : _offline = offline ?? (() => false);

  final FakeStore _store;

  /// Fake mode has no network; this lets airplane mode still "unplug" the
  /// server so the offline paths can be demoed.
  final bool Function() _offline;
  final FakeLatency _latency;
  final String? Function() _currentUserId;

  static const maxRows = 500;

  @override
  Future<AttendeeList> list(String orgSlug, String eventSlug, {String query = ''}) async {
    if (_offline()) throw ApiError.network();
    await _latency.wait();
    final ctx = requireMembership(_store, _currentUserId(), orgSlug);
    final event = _store.eventBySlug(ctx.tenant.id, eventSlug);
    if (event == null) throw ApiError.fromResponse(404, {'error': 'Not found'});

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
}
