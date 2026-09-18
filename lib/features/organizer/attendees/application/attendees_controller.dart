import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../../events/application/events_controller.dart';
import '../../organizer_providers.dart';
import '../domain/attendee.dart';

part 'attendees_controller.g.dart';

/// The attendee list for one event plus which rows have a request in flight.
class AttendeesState {
  const AttendeesState({required this.list, this.busyIds = const {}});

  final AttendeeList list;
  final Set<String> busyIds;

  AttendeesState copyWith({AttendeeList? list, Set<String>? busyIds}) =>
      AttendeesState(list: list ?? this.list, busyIds: busyIds ?? this.busyIds);

  List<Attendee> get attendees => list.attendees;

  /// Local search — same semantics as the server's `q` (case-insensitive
  /// contains on name or email). The list is fetched unfiltered (server cap
  /// 500) so typing never round-trips.
  List<Attendee> filtered(String query) =>
      attendees.where((a) => a.matches(query)).toList(growable: false);

  int get checkedInCount => attendees.where((a) => a.checkedIn).length;
}

/// Loads the list and applies manual check-in toggles optimistically, rolling
/// back on failure — port of `toggle` in the Expo AttendeesScreen.
@riverpod
class AttendeesController extends _$AttendeesController {
  @override
  Future<AttendeesState> build(String org, String event) async {
    final list = await ref.watch(attendeesRepositoryProvider).list(org, event);
    return AttendeesState(list: list);
  }

  Future<void> refresh() async {
    final list = await ref.read(attendeesRepositoryProvider).list(org, event);
    final current = state.value;
    state = AsyncData(AttendeesState(list: list, busyIds: current?.busyIds ?? const {}));
  }

  /// Flip [attendee]'s presence. Returns an error message to show, or null.
  Future<String?> toggle(Attendee attendee) async {
    final current = state.value;
    if (current == null || !attendee.canCheckIn || current.busyIds.contains(attendee.id)) {
      return null;
    }
    final next = !attendee.checkedIn;
    final optimisticAt = next ? ref.read(clockProvider)() : null;

    _patch(attendee.id, checkedInAt: optimisticAt, busy: true);
    try {
      final serverAt = await ref.read(checkinRepositoryProvider).setCheckedIn(
            org,
            event,
            attendee.id,
            checkedIn: next,
          );
      _patch(attendee.id, checkedInAt: serverAt, busy: false);
      ref.invalidate(orgEventsProvider(org));
      return null;
    } on ApiError catch (e) {
      _patch(attendee.id, checkedInAt: attendee.checkedInAt, busy: false);
      return e.message;
    } catch (_) {
      _patch(attendee.id, checkedInAt: attendee.checkedInAt, busy: false);
      return "Couldn't update check-in.";
    }
  }

  /// Apply a change that happened elsewhere (a scan) without a refetch.
  void applyCheckIn(String registrationId, DateTime? at) =>
      _patch(registrationId, checkedInAt: at, busy: null);

  void _patch(String id, {required DateTime? checkedInAt, required bool? busy}) {
    final current = state.value;
    if (current == null) return;
    final attendees = [
      for (final a in current.attendees)
        if (a.id == id) a.copyWith(checkedInAt: checkedInAt) else a,
    ];
    final busyIds = switch (busy) {
      null => current.busyIds,
      true => {...current.busyIds, id},
      false => {...current.busyIds}..remove(id),
    };
    state = AsyncData(
      current.copyWith(list: current.list.copyWith(attendees: attendees), busyIds: busyIds),
    );
  }
}
