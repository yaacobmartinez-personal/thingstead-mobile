import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/connectivity/connectivity_provider.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../../checkin/application/sync_controller.dart';
import '../../checkin/data/checkin_queue.dart';
import '../../events/application/events_controller.dart';
import '../../local_cache.dart';
import '../../organizer_providers.dart';
import '../domain/attendee.dart';

part 'attendees_controller.g.dart';

/// The attendee list for one event, as rendered from the local cache, plus
/// UI-only bits: rows with a request in flight, rows with a queued op, and
/// whether the last fetch failed (so the screen can say the list is saved).
class AttendeesState {
  const AttendeesState({
    required this.list,
    this.busyIds = const {},
    this.pendingIds = const {},
    this.fetchedAt,
    this.lastSyncedAt,
    this.stale = false,
    this.fetchError,
  });

  final AttendeeList list;
  final Set<String> busyIds;
  final Set<String> pendingIds;
  final DateTime? fetchedAt;
  final DateTime? lastSyncedAt;

  /// True when showing the cache because the refresh failed.
  final bool stale;
  final String? fetchError;

  AttendeesState copyWith({
    AttendeeList? list,
    Set<String>? busyIds,
    Set<String>? pendingIds,
    DateTime? fetchedAt,
    DateTime? lastSyncedAt,
    bool? stale,
    String? fetchError,
    bool clearFetchError = false,
  }) =>
      AttendeesState(
        list: list ?? this.list,
        busyIds: busyIds ?? this.busyIds,
        pendingIds: pendingIds ?? this.pendingIds,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        stale: stale ?? this.stale,
        fetchError: clearFetchError ? null : (fetchError ?? this.fetchError),
      );

  AttendeesState withSnapshot(AttendeeSnapshot s) => copyWith(
        list: s.list,
        pendingIds: s.pendingIds,
        fetchedAt: s.fetchedAt,
        lastSyncedAt: s.lastSyncedAt,
      );

  List<Attendee> get attendees => list.attendees;

  /// Local search — same semantics as the server's `q` (case-insensitive
  /// contains on name or email). The list is fetched unfiltered (server cap
  /// 500) so typing never round-trips.
  List<Attendee> filtered(String query) =>
      attendees.where((a) => a.matches(query)).toList(growable: false);

  int get checkedInCount => attendees.where((a) => a.checkedIn).length;
}

/// Fetches into the cache and renders from it, so a manual toggle, a scan,
/// and the sync worker all update the screen through one path. Toggles are
/// optimistic; when the server is unreachable they are queued instead of
/// rolled back.
@riverpod
class AttendeesController extends _$AttendeesController {
  StreamSubscription<AttendeeSnapshot>? _sub;

  @override
  Future<AttendeesState> build(String org, String event) async {
    ref.onDispose(() => _sub?.cancel());
    final cache = ref.watch(localCacheProvider);

    final error = await _fetchIntoCache();
    final snapshot = await cache.readAttendees(org, event);
    if (snapshot == null) {
      // Never fetched and the server is unreachable: nothing to show.
      throw error ?? ApiError.network();
    }

    _sub = cache.watchAttendees(org, event).listen((s) {
      final current = state.value;
      if (current != null) state = AsyncData(current.withSnapshot(s));
    });

    return AttendeesState(
      list: snapshot.list,
      pendingIds: snapshot.pendingIds,
      fetchedAt: snapshot.fetchedAt,
      lastSyncedAt: snapshot.lastSyncedAt,
      stale: error != null,
      fetchError: error?.message,
    );
  }

  /// Fetch from the server into the cache. Returns the error when the
  /// server could not be reached (the cache stays valid); rethrows anything
  /// that means the list is genuinely unavailable (403, 404).
  Future<ApiError?> _fetchIntoCache() async {
    try {
      final list = await ref.read(attendeesRepositoryProvider).list(org, event);
      await ref.read(localCacheProvider).storeAttendees(
            org,
            event,
            list,
            ref.read(clockProvider)(),
          );
      return null;
    } on ApiError catch (e) {
      if (e.isNetwork || e.status >= 500) return e;
      rethrow;
    }
  }

  Future<void> refresh() async {
    final error = await _fetchIntoCache();
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      stale: error != null,
      fetchError: error?.message,
      clearFetchError: error == null,
    ));
  }

  /// Flip [attendee]'s presence. Returns an error message to show, or null
  /// (including when the change was queued for later).
  Future<String?> toggle(Attendee attendee) async {
    final current = state.value;
    if (current == null || !attendee.canCheckIn || current.busyIds.contains(attendee.id)) {
      return null;
    }
    final cache = ref.read(localCacheProvider);
    final next = !attendee.checkedIn;
    final now = ref.read(clockProvider)();

    _busy(attendee.id, true);
    await cache.setCheckedIn(org, attendee.id, next ? now : null);
    try {
      if (!ref.read(isOnlineProvider)) {
        await _queue(attendee, next);
        return null;
      }
      final serverAt = await ref.read(checkinRepositoryProvider).setCheckedIn(
            org,
            event,
            attendee.id,
            checkedIn: next,
          );
      await cache.setCheckedIn(org, attendee.id, serverAt);
      ref.invalidate(orgEventsProvider(org));
      return null;
    } on ApiError catch (e) {
      if (e.isNetwork || e.status >= 500) {
        await _queue(attendee, next);
        return null;
      }
      await cache.setCheckedIn(org, attendee.id, attendee.checkedInAt);
      return e.message;
    } catch (_) {
      await cache.setCheckedIn(org, attendee.id, attendee.checkedInAt);
      return "Couldn't update check-in.";
    } finally {
      _busy(attendee.id, false);
    }
  }

  Future<void> _queue(Attendee attendee, bool desired) async {
    await ref.read(checkinQueueProvider).enqueueManual(
          org: org,
          event: event,
          registrationId: attendee.id,
          desired: desired,
          name: attendee.name,
        );
    unawaited(ref.read(syncControllerProvider.notifier).kick());
  }

  void _busy(String id, bool busy) {
    final current = state.value;
    if (current == null) return;
    final ids = {...current.busyIds};
    if (busy) {
      ids.add(id);
    } else {
      ids.remove(id);
    }
    state = AsyncData(current.copyWith(busyIds: ids));
  }
}
