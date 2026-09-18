import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/storage/db/app_database.dart';
import 'package:thingstead/features/organizer/checkin/data/offline_resolver.dart';
import 'package:thingstead/features/organizer/checkin/domain/scan_result.dart';

import '../../helpers/fakes.dart';

void main() {
  CachedAttendee row({
    String event = 'summer-meetup',
    String status = 'CONFIRMED',
    DateTime? checkedInAt,
  }) =>
      CachedAttendee(
        orgSlug: 'acme',
        eventSlug: event,
        id: 'r_1',
        name: 'Ava Cruz',
        email: 'ava@example.com',
        status: status,
        checkedInAt: checkedInAt,
        erased: false,
        checkInToken: 'chk_r_1',
        fetchedAt: testNow,
      );

  OfflineDecision decide(CachedAttendee? r, {String? pinned, bool open = false}) =>
      OfflineResolver.resolve(row: r, pinnedEvent: pinned, hasOpenCheckIn: open, now: testNow);

  test('unknown token is queued blind', () {
    final d = decide(null);
    expect(d.result.outcome, CheckInOutcome.queuedUnverified);
    expect(d.result.offline, isTrue);
    expect(d.enqueue, isTrue);
    expect(d.markLocal, isFalse);
  });

  test('confirmed and not yet in → checked in locally and queued', () {
    final d = decide(row(), pinned: 'summer-meetup');
    expect(d.result.outcome, CheckInOutcome.checkedIn);
    expect(d.result.name, 'Ava Cruz');
    expect(d.result.at, testNow);
    expect(d.enqueue, isTrue);
    expect(d.markLocal, isTrue);
  });

  test('pinned to another event → wrong event, nothing queued', () {
    final d = decide(row(), pinned: 'design-workshop');
    expect(d.result.outcome, CheckInOutcome.wrongEvent);
    expect(d.enqueue, isFalse);
    expect(d.markLocal, isFalse);
  });

  test('cancelled and waitlist are refused', () {
    expect(decide(row(status: 'CANCELLED')).result.outcome, CheckInOutcome.cancelled);
    expect(decide(row(status: 'WAITLIST')).result.outcome, CheckInOutcome.waitlist);
    expect(decide(row(status: 'WAITLIST')).enqueue, isFalse);
  });

  test('already in — by timestamp or by a queued check-in', () {
    final byStamp = decide(row(checkedInAt: testNow));
    expect(byStamp.result.outcome, CheckInOutcome.already);
    expect(byStamp.result.at, testNow);
    final byQueue = decide(row(), open: true);
    expect(byQueue.result.outcome, CheckInOutcome.already);
    expect(byQueue.enqueue, isFalse);
  });
}
