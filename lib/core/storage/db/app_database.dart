import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// The on-device database: attendee/event caches for offline use and the
/// queue of check-ins waiting to be replayed. Caches are disposable (dropped
/// on a schema bump); only `pending_checkins` is worth migrating.
@DriftDatabase(tables: [CachedAttendees, CachedEvents, ListMeta, PendingCheckins])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// The app's persistent database under the platform's app-data directory.
  AppDatabase.open() : super(driftDatabase(name: 'thingstead'));

  @override
  int get schemaVersion => 1;

  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);

  // --- attendee cache ---------------------------------------------------------

  Future<void> upsertAttendees(
    String org,
    String event,
    Iterable<CachedAttendeesCompanion> rows,
  ) =>
      transaction(() async {
        await (delete(cachedAttendees)
              ..where((t) => t.orgSlug.equals(org) & t.eventSlug.equals(event)))
            .go();
        await batch((b) => b.insertAllOnConflictUpdate(cachedAttendees, rows.toList()));
      });

  Stream<List<CachedAttendee>> watchAttendees(String org, String event) =>
      (select(cachedAttendees)
            ..where((t) => t.orgSlug.equals(org) & t.eventSlug.equals(event))
            ..orderBy([(t) => OrderingTerm.asc(t.fetchedAt), (t) => OrderingTerm.asc(t.id)]))
          .watch();

  Future<List<CachedAttendee>> readAttendees(String org, String event) =>
      (select(cachedAttendees)
            ..where((t) => t.orgSlug.equals(org) & t.eventSlug.equals(event)))
          .get();

  Future<CachedAttendee?> attendeeById(String org, String id) =>
      (select(cachedAttendees)
            ..where((t) => t.orgSlug.equals(org) & t.id.equals(id)))
          .getSingleOrNull();

  /// Any event in the org — a scan is not pinned until the caller checks.
  Future<CachedAttendee?> attendeeByToken(String org, String token) =>
      (select(cachedAttendees)
            ..where((t) => t.orgSlug.equals(org) & t.checkInToken.equals(token)))
          .getSingleOrNull();

  Future<int> setAttendeeCheckedIn(String org, String id, DateTime? at) =>
      (update(cachedAttendees)
            ..where((t) => t.orgSlug.equals(org) & t.id.equals(id)))
          .write(CachedAttendeesCompanion(checkedInAt: Value(at)));

  Future<int> setAttendeeCheckedInByToken(String org, String token, DateTime? at) =>
      (update(cachedAttendees)
            ..where((t) => t.orgSlug.equals(org) & t.checkInToken.equals(token)))
          .write(CachedAttendeesCompanion(checkedInAt: Value(at)));

  // --- events cache -----------------------------------------------------------

  Future<void> upsertEvents(String org, Iterable<CachedEventsCompanion> rows) =>
      transaction(() async {
        await (delete(cachedEvents)..where((t) => t.orgSlug.equals(org))).go();
        await batch((b) => b.insertAllOnConflictUpdate(cachedEvents, rows.toList()));
      });

  Future<List<CachedEvent>> readEvents(String org) => (select(cachedEvents)
        ..where((t) => t.orgSlug.equals(org))
        ..orderBy([(t) => OrderingTerm.asc(t.startsAt)]))
      .get();

  // --- list meta --------------------------------------------------------------

  Future<void> upsertListMeta(ListMetaCompanion row) =>
      into(listMeta).insertOnConflictUpdate(row);

  Future<ListMetaData?> readListMeta(String org, String event) => (select(listMeta)
        ..where((t) => t.orgSlug.equals(org) & t.eventSlug.equals(event)))
      .getSingleOrNull();

  Stream<ListMetaData?> watchListMeta(String org, String event) => (select(listMeta)
        ..where((t) => t.orgSlug.equals(org) & t.eventSlug.equals(event)))
      .watchSingleOrNull();

  Future<void> markListSynced(String org, String event, DateTime at, {String? error}) =>
      (update(listMeta)
            ..where((t) => t.orgSlug.equals(org) & t.eventSlug.equals(event)))
          .write(ListMetaCompanion(lastSyncedAt: Value(at), lastError: Value(error)));

  // --- queue ------------------------------------------------------------------

  static const statePending = 'pending';
  static const stateSyncing = 'syncing';
  static const stateSynced = 'synced';
  static const stateAttention = 'attention';

  Future<void> enqueue(PendingCheckinsCompanion op) => into(pendingCheckins).insert(op);

  /// The open manual op for a registration, so repeated toggles collapse.
  Future<PendingCheckin?> openManualOp(String org, String registrationId) =>
      (select(pendingCheckins)
            ..where((t) =>
                t.orgSlug.equals(org) &
                t.registrationId.equals(registrationId) &
                t.kind.equals('manual') &
                t.state.isIn([statePending, stateSyncing])))
          .getSingleOrNull();

  Future<bool> hasOpenCheckIn(String org, String registrationId) async {
    final rows = await (select(pendingCheckins)
          ..where((t) =>
              t.orgSlug.equals(org) &
              t.registrationId.equals(registrationId) &
              t.state.isIn([statePending, stateSyncing])))
        .get();
    return rows.any((r) => r.kind == 'scan' || r.desiredCheckedIn == true);
  }

  Future<void> updateOp(String id, PendingCheckinsCompanion patch) =>
      (update(pendingCheckins)..where((t) => t.id.equals(id))).write(patch);

  /// Pending ops whose backoff has elapsed, oldest first.
  Future<List<PendingCheckin>> dueOps(DateTime now) => (select(pendingCheckins)
        ..where((t) =>
            t.state.equals(statePending) & t.nextAttemptAt.isSmallerOrEqualValue(now))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .get();

  Stream<List<PendingCheckin>> watchOpenOps() => (select(pendingCheckins)
        ..where((t) => t.state.isIn([statePending, stateSyncing, stateAttention]))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .watch();

  Stream<List<PendingCheckin>> watchOpenOpsFor(String org, String event) =>
      (select(pendingCheckins)
            ..where((t) =>
                t.orgSlug.equals(org) &
                t.eventSlug.equals(event) &
                t.state.isIn([statePending, stateSyncing])))
          .watch();

  Future<void> deleteOp(String id) =>
      (delete(pendingCheckins)..where((t) => t.id.equals(id))).go();

  /// Anything stuck in `syncing` from a previous run goes back to pending.
  Future<void> recoverInterrupted() => (update(pendingCheckins)
        ..where((t) => t.state.equals(stateSyncing)))
      .write(const PendingCheckinsCompanion(state: Value(statePending)));

  Future<void> purgeSynced(DateTime olderThan) => (delete(pendingCheckins)
        ..where((t) =>
            t.state.equals(stateSynced) & t.resolvedAt.isSmallerThanValue(olderThan)))
      .go();

  /// Sign-out: everything local goes.
  Future<void> wipeAll() => transaction(() async {
        await delete(cachedAttendees).go();
        await delete(cachedEvents).go();
        await delete(listMeta).go();
        await delete(pendingCheckins).go();
      });

  /// Session expired: keep the queue so a re-login can finish syncing, drop
  /// the personal data in the caches.
  Future<void> wipeCaches() => transaction(() async {
        await delete(cachedAttendees).go();
        await delete(cachedEvents).go();
        await delete(listMeta).go();
      });
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
}
