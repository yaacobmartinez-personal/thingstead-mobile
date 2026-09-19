import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/core/storage/db/app_database.dart';
import 'package:thingstead/features/organizer/attendees/domain/attendee.dart';
import 'package:thingstead/features/organizer/checkin/data/checkin_queue.dart';
import 'package:thingstead/features/organizer/checkin/data/sync_worker.dart';
import 'package:thingstead/features/organizer/checkin/domain/checkin_repository.dart';
import 'package:thingstead/features/organizer/checkin/domain/scan_result.dart';
import 'package:thingstead/features/organizer/local_cache.dart';

import '../../helpers/fakes.dart';

/// A check-in repository whose answers are scripted per call.
class _ScriptedCheckin implements CheckinRepository {
  final scanAnswers = <Object>[]; // ScanResult or ApiError
  final manualAnswers = <Object>[]; // DateTime? or ApiError
  final calls = <String>[];

  /// The `at` each replay carried (null = "now"), manual and scan.
  final manualAt = <DateTime?>[];
  final scanAt = <DateTime?>[];

  @override
  Future<DateTime?> setCheckedIn(String o, String e, String id, {required bool checkedIn, DateTime? at}) async {
    calls.add('manual:$id:$checkedIn');
    manualAt.add(at);
    final a = manualAnswers.removeAt(0);
    if (a is ApiError) throw a;
    return a as DateTime?;
  }

  @override
  Future<ScanResult> scan(String o, String code, {String? eventSlug, DateTime? at}) async {
    calls.add('scan:$code');
    scanAt.add(at);
    final a = scanAnswers.removeAt(0);
    if (a is ApiError) throw a;
    return a as ScanResult;
  }
}

void main() {
  late AppDatabase db;
  late LocalCache cache;
  late CheckinQueue queue;
  late _ScriptedCheckin repo;
  late SyncWorker worker;
  var now = testNow;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    cache = LocalCache(db);
    queue = CheckinQueue(db, () => now);
    repo = _ScriptedCheckin();
    worker = SyncWorker(db, repo, () => now);
    now = testNow;
    await cache.storeAttendees(
      'acme',
      'summer-meetup',
      const AttendeeList(
        event: AttendeeEventRef(title: 'Summer Meetup', timezone: 'Asia/Manila', capacity: 40),
        attendees: [
          Attendee(id: 'r_1', name: 'Ava', email: 'a@x', status: RegistrationStatus.confirmed, checkInToken: 'chk_r_1'),
          Attendee(id: 'r_2', name: 'Ben', email: 'b@x', status: RegistrationStatus.confirmed, checkInToken: 'chk_r_2'),
        ],
      ),
      now,
    );
  });

  tearDown(() => db.close());

  Future<PendingCheckin> only() async => (await db.watchOpenOps().first).single;
  Future<List<PendingCheckin>> all() async =>
      (await db.select(db.pendingCheckins).get());

  test('a manual replay sends the door time, not the drain time (#24)', () async {
    // Taken offline at testNow; the network comes back an hour later.
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_1', desired: true);
    now = testNow.add(const Duration(hours: 1));
    repo.manualAnswers.add(testNow);

    await worker.drain();
    expect(repo.manualAt, [testNow]);
  });

  test('a scan replay sends the door time too (E6 `at`)', () async {
    await queue.enqueueScan(org: 'acme', event: 'summer-meetup', code: 'chk_r_1', registrationId: 'r_1');
    now = testNow.add(const Duration(hours: 1));
    repo.scanAnswers.add(const ScanResult(outcome: CheckInOutcome.checkedIn, name: 'Ava'));

    await worker.drain();
    expect(repo.scanAt, [testNow]);
  });

  test('manual op → 200: synced, cache takes the server timestamp', () async {
    final serverAt = testNow.add(const Duration(seconds: 5));
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_1', desired: true);
    repo.manualAnswers.add(serverAt);

    final r = await worker.drain();
    expect(r.synced, 1);
    expect(r.stop, DrainStop.none);
    expect(repo.calls, ['manual:r_1:true']);
    final op = (await all()).single;
    expect(op.state, 'synced');
    expect(op.serverCheckedInAt, serverAt);
    expect((await cache.attendeeById('acme', 'r_1'))!.checkedInAt, serverAt);
    expect((await db.readListMeta('acme', 'summer-meetup'))!.lastSyncedAt, testNow);
  });

  test('repeated manual toggles collapse to the last desired state', () async {
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_1', desired: true);
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_1', desired: false);
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_1', desired: true);
    final ops = await all();
    expect(ops, hasLength(1));
    expect(ops.single.desiredCheckedIn, isTrue);
  });

  test('scan → already: synced with the server time', () async {
    await queue.enqueueScan(org: 'acme', event: 'summer-meetup', code: 'chk_r_1', registrationId: 'r_1');
    final at = testNow.subtract(const Duration(minutes: 3));
    repo.scanAnswers.add(ScanResult(outcome: CheckInOutcome.already, name: 'Ava', at: at));

    final r = await worker.drain();
    expect(r.synced, 1);
    expect((await all()).single.serverOutcome, 'already');
    expect((await cache.attendeeById('acme', 'r_1'))!.checkedInAt, at);
  });

  test('blind scan resolved by the server updates the row by token', () async {
    await queue.enqueueScan(org: 'acme', code: 'https://app.thingstead.pro/checkin?c=chk_r_2');
    repo.scanAnswers.add(ScanResult(outcome: CheckInOutcome.checkedIn, name: 'Ben', at: testNow));

    await worker.drain();
    expect((await cache.attendeeById('acme', 'r_2'))!.checkedInAt, testNow);
  });

  test('scan refused by the server → attention and the local check-in is reverted', () async {
    await cache.setCheckedIn('acme', 'r_1', testNow); // optimistic
    await queue.enqueueScan(org: 'acme', event: 'summer-meetup', code: 'chk_r_1', registrationId: 'r_1');
    repo.scanAnswers.add(const ScanResult(outcome: CheckInOutcome.cancelled, name: 'Ava'));

    final r = await worker.drain();
    expect(r.attention, 1);
    final op = (await all()).single;
    expect(op.state, 'attention');
    expect(op.serverOutcome, 'cancelled');
    expect((await cache.attendeeById('acme', 'r_1'))!.checkedInAt, isNull);
  });

  test('404 on a manual op → attention', () async {
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_9', desired: true);
    repo.manualAnswers.add(ApiError.fromResponse(404, {'error': 'Not found'}));
    final r = await worker.drain();
    expect(r.attention, 1);
    expect((await all()).single.serverOutcome, 'not_found');
  });

  test('transport failure → exponential backoff, then attention after 20 tries', () async {
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_1', desired: true);
    for (var i = 1; i <= 19; i++) {
      repo.manualAnswers.add(ApiError.network());
      final r = await worker.drain();
      expect(r.stop, DrainStop.transport, reason: 'attempt $i');
      final op = await only();
      expect(op.state, 'pending');
      expect(op.attempts, i);
      final expectedWait = Duration(seconds: (1 << i).clamp(0, 300));
      expect(op.nextAttemptAt, now.add(expectedWait), reason: 'attempt $i');
      // Not due yet: a drain right now does nothing.
      expect((await worker.drain()).stop, DrainStop.none);
      now = op.nextAttemptAt;
    }
    repo.manualAnswers.add(ApiError.network());
    final last = await worker.drain();
    expect(last.attention, 1);
    expect((await all()).single.state, 'attention');
  });

  test('401 stops the drain and leaves ops pending', () async {
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_1', desired: true);
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_2', desired: true);
    repo.manualAnswers.add(ApiError.fromResponse(401, null));

    final r = await worker.drain();
    expect(r.stop, DrainStop.unauthorized);
    expect(repo.calls, hasLength(1));
    expect((await all()).every((o) => o.state == 'pending'), isTrue);
  });

  test('403 stops the drain and marks the list blocked', () async {
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_1', desired: true);
    repo.manualAnswers.add(ApiError.fromResponse(403, {'error': 'Forbidden'}));

    final r = await worker.drain();
    expect(r.stop, DrainStop.forbidden);
    expect((await db.readListMeta('acme', 'summer-meetup'))!.lastError, 'membership');
    expect((await only()).state, 'pending');
  });

  test('ops replay oldest first and an interrupted syncing op recovers', () async {
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_1', desired: true);
    now = now.add(const Duration(seconds: 1));
    await queue.enqueueScan(org: 'acme', event: 'summer-meetup', code: 'chk_r_2', registrationId: 'r_2');
    // Simulate a crash mid-sync.
    final first = (await all()).first;
    await db.updateOp(first.id, const PendingCheckinsCompanion(state: Value('syncing')));

    repo.manualAnswers.add(now);
    repo.scanAnswers.add(ScanResult(outcome: CheckInOutcome.checkedIn, name: 'Ben', at: now));
    final r = await worker.drain();
    expect(r.synced, 2);
    expect(repo.calls, ['manual:r_1:true', 'scan:chk_r_2']);
  });

  test('retry and dismiss from the attention list', () async {
    await queue.enqueueManual(org: 'acme', event: 'summer-meetup', registrationId: 'r_9', desired: true);
    repo.manualAnswers.add(ApiError.fromResponse(404, {'error': 'Not found'}));
    await worker.drain();
    final op = (await all()).single;

    await queue.retry(op.id);
    expect((await only()).state, 'pending');
    await queue.dismiss(op.id);
    expect(await all(), isEmpty);
  });
}
