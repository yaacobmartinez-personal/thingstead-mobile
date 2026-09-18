import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/fake_checkin.dart';
import 'package:thingstead/core/fake/fake_store.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/features/organizer/checkin/domain/scan_result.dart';

import '../../helpers/fakes.dart';

/// The decision table of regista/lib/checkin.ts, exercised against the seed.
void main() {
  late FakeStore store;
  late FakeTenant acme;
  late FakeEvent summer;
  late FakeEvent workshop;

  setUp(() {
    store = FakeStore();
    seedFakeStore(store, testNow);
    acme = store.tenantBySlug('acme')!;
    summer = store.eventBySlug(acme.id, 'summer-meetup')!;
    workshop = store.eventBySlug(acme.id, 'design-workshop')!;
  });

  FakeRegistration first(FakeEvent e, RegistrationStatus s) =>
      store.registrationsOf(e.id).firstWhere(
            (r) => r.status == s && !r.erased && r.checkedInAt == null,
          );

  ScanResult scan(String code, {String? requireEventId}) => performFakeCheckIn(
        store,
        tenantId: acme.id,
        rawCode: code,
        requireEventId: requireEventId,
        now: testNow,
      );

  test('a confirmed ticket checks in once, then reads already', () {
    final r = first(summer, RegistrationStatus.confirmed);
    final a = scan(r.checkInToken!);
    expect(a.outcome, CheckInOutcome.checkedIn);
    expect(a.name, r.name);
    expect(a.at, testNow);

    final b = scan(r.checkInToken!);
    expect(b.outcome, CheckInOutcome.already);
    expect(b.at, testNow);
  });

  test('accepts the full ticket URL', () {
    final r = first(summer, RegistrationStatus.confirmed);
    final a = scan('https://app.thingstead.pro/checkin?c=${r.checkInToken}');
    expect(a.outcome, CheckInOutcome.checkedIn);
  });

  test("pinned to another event → wrong_event with the ticket's event title", () {
    final r = first(summer, RegistrationStatus.confirmed);
    final a = scan(r.checkInToken!, requireEventId: workshop.id);
    expect(a.outcome, CheckInOutcome.wrongEvent);
    expect(a.eventTitle, 'Summer Meetup');
    expect(r.checkedInAt, isNull, reason: 'must not mark present');
  });

  test('cancelled and waitlisted tickets are refused without side effects', () {
    final c = first(summer, RegistrationStatus.cancelled);
    expect(scan(c.checkInToken!).outcome, CheckInOutcome.cancelled);
    final w = first(summer, RegistrationStatus.waitlist);
    expect(scan(w.checkInToken!).outcome, CheckInOutcome.waitlist);
    expect(c.checkedInAt, isNull);
    expect(w.checkedInAt, isNull);
  });

  test('unknown, blank, and other-tenant tokens are invalid', () {
    expect(scan('nope').outcome, CheckInOutcome.invalid);
    expect(scan('   ').outcome, CheckInOutcome.invalid);
    final beta = store.tenantBySlug('beta')!;
    final hack = store.eventBySlug(beta.id, 'community-hackathon')!;
    final r = store.registrationsOf(hack.id).first;
    expect(scan(r.checkInToken!).outcome, CheckInOutcome.invalid);
  });

  test('erased registrations carry no token', () {
    final erased = store.registrationsOf(workshop.id).firstWhere((r) => r.erased);
    expect(erased.checkInToken, isNull);
  });
}
