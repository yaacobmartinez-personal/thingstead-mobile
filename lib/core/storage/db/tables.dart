import 'package:drift/drift.dart';

/// Local copy of an event's attendee list (E4), keyed by org + event.
/// `checkInToken` is present once API-CONTRACT #23 ships (always in fake
/// mode) and lets a scan resolve offline.
@TableIndex(name: 'idx_cached_attendees_token', columns: {#orgSlug, #checkInToken})
class CachedAttendees extends Table {
  TextColumn get orgSlug => text()();
  TextColumn get eventSlug => text()();
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get email => text().nullable()();

  /// Wire value: CONFIRMED | WAITLIST | CANCELLED.
  TextColumn get status => text()();
  DateTimeColumn get checkedInAt => dateTime().nullable()();
  BoolColumn get erased => boolean().withDefault(const Constant(false))();
  TextColumn get checkInToken => text().nullable()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {orgSlug, eventSlug, id};
}

/// Local copy of the org's events (E3) so Events and Scan open offline.
class CachedEvents extends Table {
  TextColumn get orgSlug => text()();
  TextColumn get slug => text()();
  TextColumn get title => text()();
  DateTimeColumn get startsAt => dateTime()();
  DateTimeColumn get endsAt => dateTime().nullable()();
  TextColumn get timezone => text()();
  IntColumn get capacity => integer().nullable()();

  /// Wire value: DRAFT | PUBLISHED | CLOSED.
  TextColumn get status => text()();
  IntColumn get confirmed => integer().withDefault(const Constant(0))();
  IntColumn get checkedIn => integer().withDefault(const Constant(0))();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {orgSlug, slug};
}

/// Per-list bookkeeping: the event header the attendees endpoint returns,
/// when the list was last fetched, and when the queue last synced for it.
class ListMeta extends Table {
  TextColumn get orgSlug => text()();
  TextColumn get eventSlug => text()();
  TextColumn get title => text()();
  TextColumn get timezone => text()();
  IntColumn get capacity => integer().nullable()();
  IntColumn get waitlist => integer().nullable()();
  DateTimeColumn get fetchedAt => dateTime()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {orgSlug, eventSlug};
}

/// A check-in made while offline, waiting to be replayed. `id` is a UUID
/// that doubles as the idempotency key. State machine:
/// pending → syncing → synced | attention.
class PendingCheckins extends Table {
  TextColumn get id => text()();
  TextColumn get orgSlug => text()();

  /// Null for a blind scan made without an event pinned.
  TextColumn get eventSlug => text().nullable()();

  /// manual | scan.
  TextColumn get kind => text()();

  /// Known for manual toggles and for scans resolved against the cache.
  TextColumn get registrationId => text().nullable()();

  /// The raw scanned value, for replaying a scan.
  TextColumn get code => text().nullable()();
  BoolColumn get desiredCheckedIn => boolean().nullable()();

  /// Display only, so the attention list can name the person.
  TextColumn get attendeeName => text().nullable()();

  /// When the door action happened (sent as `at` once API-CONTRACT #24 ships).
  DateTimeColumn get clientAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime()();
  TextColumn get lastError => text().nullable()();

  /// pending | syncing | synced | attention.
  TextColumn get state => text().withDefault(const Constant('pending'))();
  TextColumn get serverOutcome => text().nullable()();
  DateTimeColumn get serverCheckedInAt => dateTime().nullable()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
