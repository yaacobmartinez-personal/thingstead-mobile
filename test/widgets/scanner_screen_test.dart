import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/scanner/domain/scan_source.dart';
import 'package:thingstead/features/organizer/scanner/presentation/scanner_screen.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  testWidgets('a code from the source shows the outcome card; Scan next resets',
      (tester) async {
    final world = TestWorld();
    final source = ManualScanSource();
    addTearDown(source.dispose);

    final c = await pumpApp(
      tester,
      ScannerScreen(eventSlug: 'summer-meetup', source: source),
      world: world,
    );
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    await tester.pumpAndSettle();

    expect(find.text('Summer Meetup'), findsOneWidget); // event pill
    expect(find.text("Point at an attendee's QR code"), findsOneWidget);
    expect(source.started, isTrue);

    final acme = world.store.tenantBySlug('acme')!;
    final summer = world.store.eventBySlug(acme.id, 'summer-meetup')!;
    final r = world.store.registrationsOf(summer.id).firstWhere(
          (r) => r.status == RegistrationStatus.confirmed && r.checkedInAt == null,
        );
    source.emit(r.checkInToken!);
    await tester.pumpAndSettle();

    expect(find.text('Checked in'), findsOneWidget);
    expect(find.text(r.name!), findsOneWidget);
    expect(find.text('1 in'), findsOneWidget);

    // Same code again is ignored until Scan next.
    source.emit(r.checkInToken!);
    await tester.pumpAndSettle();
    expect(find.text('Checked in'), findsOneWidget);

    await tester.tap(find.text('Scan next'));
    await tester.pumpAndSettle();
    expect(find.text("Point at an attendee's QR code"), findsOneWidget);

    source.emit(r.checkInToken!);
    await tester.pumpAndSettle();
    expect(find.textContaining('is already in'), findsOneWidget);
  });

  testWidgets('a wrong-event ticket names the other event', (tester) async {
    final world = TestWorld();
    final source = ManualScanSource();
    addTearDown(source.dispose);
    final c = await pumpApp(
      tester,
      ScannerScreen(eventSlug: 'design-workshop', source: source),
      world: world,
    );
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    await tester.pumpAndSettle();

    final acme = world.store.tenantBySlug('acme')!;
    final summer = world.store.eventBySlug(acme.id, 'summer-meetup')!;
    final r = world.store.registrationsOf(summer.id).first;
    source.emit('https://app.thingstead.pro/checkin?c=${r.checkInToken}');
    await tester.pumpAndSettle();

    expect(find.text('Wrong event'), findsOneWidget);
    expect(find.text('This ticket is for Summer Meetup'), findsOneWidget);
  });

  testWidgets('an initial code (deep link) is submitted on open', (tester) async {
    final world = TestWorld();
    final source = ManualScanSource();
    addTearDown(source.dispose);
    await pumpApp(
      tester,
      ScannerScreen(initialCode: 'garbage', source: source),
      world: world,
      setup: (c) => c
          .read(authControllerProvider.notifier)
          .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password),
    );
    await tester.pumpAndSettle();
    expect(find.text('Not a valid ticket'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget); // Scan next
  });
}
