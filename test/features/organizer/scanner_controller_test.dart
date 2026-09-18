import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/checkin/domain/scan_feedback.dart';
import 'package:thingstead/features/organizer/checkin/domain/scan_result.dart';
import 'package:thingstead/features/organizer/scanner/application/scanner_controller.dart';

import '../../helpers/fakes.dart';

void main() {
  late TestWorld world;

  setUp(() => world = TestWorld());

  String tokenOf(String eventSlug, RegistrationStatus status) {
    final acme = world.store.tenantBySlug('acme')!;
    final event = world.store.eventBySlug(acme.id, eventSlug)!;
    return world.store
        .registrationsOf(event.id)
        .firstWhere((r) => r.status == status && !r.erased && r.checkedInAt == null)
        .checkInToken!;
  }

  test('a scan moves scanning → busy → result, then Scan next resets', () async {
    final c = world.container();
    addTearDown(c.dispose);
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    final provider = scannerControllerProvider('acme', 'summer-meetup');
    final notifier = c.read(provider.notifier);

    final future = notifier.submit(tokenOf('summer-meetup', RegistrationStatus.confirmed));
    expect(c.read(provider).phase, ScannerPhase.busy);
    await future;

    final s = c.read(provider);
    expect(s.phase, ScannerPhase.result);
    expect(s.feedback?.tone, FeedbackTone.success);
    expect(s.feedback?.title, 'Checked in');
    expect(s.scanned, 1);

    notifier.scanNext();
    expect(c.read(provider).accepting, isTrue);
    expect(c.read(provider).feedback, isNull);
  });

  test('codes are ignored while busy or showing a result', () async {
    final c = world.container();
    addTearDown(c.dispose);
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    final provider = scannerControllerProvider('acme', null);
    final notifier = c.read(provider.notifier);

    await notifier.submit(tokenOf('summer-meetup', RegistrationStatus.confirmed));
    final shown = c.read(provider).feedback;
    await notifier.submit('anything-else');
    expect(c.read(provider).feedback, same(shown));
  });

  test('every outcome maps to a card', () {
    const zone = 'Asia/Manila';
    final at = DateTime.utc(2026, 9, 18, 10, 4);
    const ava = 'Ava';

    expect(
      ScanFeedback.fromResult(
        const ScanResult(outcome: CheckInOutcome.wrongEvent, name: ava, eventTitle: 'Other'),
      ).detail,
      'This ticket is for Other',
    );
    expect(
      ScanFeedback.fromResult(
        ScanResult(outcome: CheckInOutcome.already, name: ava, at: at),
        zone: zone,
      ).detail,
      'Checked in at 6:04 PM',
    );
    expect(
      ScanFeedback.fromResult(const ScanResult(outcome: CheckInOutcome.cancelled, name: ava)).tone,
      FeedbackTone.danger,
    );
    expect(
      ScanFeedback.fromResult(const ScanResult(outcome: CheckInOutcome.waitlist, name: ava)).detail,
      "Ava isn't confirmed",
    );
    expect(
      ScanFeedback.fromResult(const ScanResult(outcome: CheckInOutcome.invalid)).title,
      'Not a valid ticket',
    );
    expect(
      ScanFeedback.fromResult(
        const ScanResult(outcome: CheckInOutcome.checkedIn, name: ava, offline: true),
      ).title,
      'Checked in (offline)',
    );
    expect(
      ScanFeedback.fromResult(const ScanResult(outcome: CheckInOutcome.queuedUnverified)).tone,
      FeedbackTone.warn,
    );
  });

  test('a non-member org answers 403 → failure card, state recovers', () async {
    final c = world.container();
    addTearDown(c.dispose);
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.attendeeEmail, FakeAccounts.password);
    final provider = scannerControllerProvider('acme', null);
    await c.read(provider.notifier).submit('whatever');
    final s = c.read(provider);
    expect(s.phase, ScannerPhase.result);
    expect(s.feedback?.title, "Couldn't check in");
    expect(s.feedback?.detail, 'Forbidden');
  });
}
