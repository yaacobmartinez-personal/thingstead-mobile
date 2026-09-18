import 'dart:async';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/model/enums.dart';
import '../../core/storage/db/app_database.dart';
import 'attendees/domain/attendee.dart';
import 'events/domain/event_summary.dart';

part 'local_cache.g.dart';

/// What the attendee screen renders from disk: the list plus which rows have
/// a queued op, and when the list was last fetched / synced.
class AttendeeSnapshot {
  const AttendeeSnapshot({
    required this.list,
    required this.pendingIds,
    this.fetchedAt,
    this.lastSyncedAt,
  });

  final AttendeeList list;
  final Set<String> pendingIds;
  final DateTime? fetchedAt;
  final DateTime? lastSyncedAt;
}

/// Domain-typed access to the drift caches. Repositories stay pure network;
/// controllers read and write here.
class LocalCache {
  LocalCache(this._db);

  final AppDatabase _db;

  // --- attendees --------------------------------------------------------------

  Future<void> storeAttendees(
    String org,
    String event,
    AttendeeList list,
    DateTime now,
  ) async {
    await _db.upsertAttendees(org, event, [
      for (final a in list.attendees)
        CachedAttendeesCompanion.insert(
          orgSlug: org,
          eventSlug: event,
          id: a.id,
          name: Value(a.name),
          email: Value(a.email),
          status: a.status.wire,
          checkedInAt: Value(a.checkedInAt),
          erased: Value(a.erased),
          checkInToken: Value(a.checkInToken),
          fetchedAt: now,
        ),
    ]);
    final existing = await _db.readListMeta(org, event);
    await _db.upsertListMeta(ListMetaCompanion.insert(
      orgSlug: org,
      eventSlug: event,
      title: list.event.title,
      timezone: list.event.timezone,
      capacity: Value(list.event.capacity),
      waitlist: Value(list.event.waitlist),
      fetchedAt: now,
      lastSyncedAt: Value(existing?.lastSyncedAt),
      lastError: Value(existing?.lastError),
    ));
  }

  /// Null when nothing has ever been fetched for this event.
  Future<AttendeeSnapshot?> readAttendees(String org, String event) async {
    final meta = await _db.readListMeta(org, event);
    if (meta == null) return null;
    final rows = await _db.readAttendees(org, event);
    final open = await _db.watchOpenOpsFor(org, event).first;
    return _snapshot(meta, rows, open);
  }

  /// Emits whenever the rows, the queue, or the meta change. Emits nothing
  /// until the list has been fetched at least once.
  Stream<AttendeeSnapshot> watchAttendees(String org, String event) {
    ListMetaData? meta;
    List<CachedAttendee>? rows;
    List<PendingCheckin>? open;
    late StreamController<AttendeeSnapshot> out;
    final subs = <StreamSubscription<dynamic>>[];

    void emit() {
      if (meta == null || rows == null || open == null) return;
      out.add(_snapshot(meta!, rows!, open!));
    }

    out = StreamController<AttendeeSnapshot>(
      onListen: () {
        subs.add(_db.watchListMeta(org, event).listen((m) {
          meta = m;
          emit();
        }));
        subs.add(_db.watchAttendees(org, event).listen((r) {
          rows = r;
          emit();
        }));
        subs.add(_db.watchOpenOpsFor(org, event).listen((o) {
          open = o;
          emit();
        }));
      },
      onCancel: () {
        for (final s in subs) {
          s.cancel();
        }
      },
    );
    return out.stream;
  }

  AttendeeSnapshot _snapshot(
    ListMetaData meta,
    List<CachedAttendee> rows,
    List<PendingCheckin> open,
  ) =>
      AttendeeSnapshot(
        list: AttendeeList(
          event: AttendeeEventRef(
            title: meta.title,
            timezone: meta.timezone,
            capacity: meta.capacity,
            waitlist: meta.waitlist,
          ),
          attendees: [for (final r in rows) toAttendee(r)],
        ),
        pendingIds: {for (final o in open) ?o.registrationId},
        fetchedAt: meta.fetchedAt,
        lastSyncedAt: meta.lastSyncedAt,
      );

  static Attendee toAttendee(CachedAttendee r) => Attendee(
        id: r.id,
        name: r.name,
        email: r.email,
        status: RegistrationStatus.fromWire(r.status),
        checkedInAt: r.checkedInAt,
        erased: r.erased,
        checkInToken: r.checkInToken,
      );

  Future<CachedAttendee?> attendeeByToken(String org, String token) =>
      _db.attendeeByToken(org, token);

  Future<CachedAttendee?> attendeeById(String org, String id) =>
      _db.attendeeById(org, id);

  Future<void> setCheckedIn(String org, String id, DateTime? at) =>
      _db.setAttendeeCheckedIn(org, id, at);

  Future<void> setCheckedInByToken(String org, String token, DateTime? at) =>
      _db.setAttendeeCheckedInByToken(org, token, at);

  Future<bool> hasOpenCheckIn(String org, String id) => _db.hasOpenCheckIn(org, id);

  // --- events -----------------------------------------------------------------

  Future<void> storeEvents(String org, EventsPage page, DateTime now) =>
      _db.upsertEvents(org, [
        for (final e in page.events)
          CachedEventsCompanion.insert(
            orgSlug: org,
            slug: e.slug,
            title: e.title,
            startsAt: e.startsAt,
            endsAt: Value(e.endsAt),
            timezone: e.timezone,
            capacity: Value(e.capacity),
            status: e.status.wire,
            confirmed: Value(e.confirmed),
            checkedIn: Value(e.checkedIn),
            fetchedAt: now,
          ),
      ]);

  /// Null when nothing cached for the org.
  Future<List<EventSummary>?> readEvents(String org) async {
    final rows = await _db.readEvents(org);
    if (rows.isEmpty) return null;
    return [
      for (final r in rows)
        EventSummary(
          slug: r.slug,
          title: r.title,
          startsAt: r.startsAt,
          endsAt: r.endsAt,
          timezone: r.timezone,
          capacity: r.capacity,
          status: EventStatus.fromWire(r.status),
          confirmed: r.confirmed,
          checkedIn: r.checkedIn,
        ),
    ];
  }

  // --- session --------------------------------------------------------------

  Future<void> wipeAll() => _db.wipeAll();
  Future<void> wipeCaches() => _db.wipeCaches();
}

@Riverpod(keepAlive: true)
LocalCache localCache(Ref ref) => LocalCache(ref.watch(appDatabaseProvider));
