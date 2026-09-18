import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/features/attendee/tickets/presentation/ticket_detail_screen.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  Future<void> signIn(ProviderContainer c) => c
      .read(authControllerProvider.notifier)
      .signInWithPassword(FakeAccounts.attendeeEmail, FakeAccounts.password);

  String ticketId(TestWorld world, String eventSlug) {
    final user = world.store.userByEmail(FakeAccounts.attendeeEmail)!;
    final event = world.store.events.firstWhere((e) => e.slug == eventSlug);
    return world.store.registrations
        .firstWhere((r) => r.userId == user.id && r.eventId == event.id)
        .id;
  }

  testWidgets('a confirmed place shows the QR and can be cancelled', (tester) async {
    final world = TestWorld();
    final id = ticketId(world, 'summer-meetup');
    await pumpApp(tester, TicketDetailScreen(ticketId: id), world: world, setup: signIn);
    await tester.pumpAndSettle();

    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text('Show this at the door.'), findsOneWidget);
    expect(find.text('Registered'), findsOneWidget);
    expect(find.text('ACME MEETUPS'), findsOneWidget);
    expect(find.text('Cancel my place'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Cancel my place'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel my place'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel your place?'), findsOneWidget);
    await tester.tap(find.text('Yes, cancel my place'));
    await tester.pumpAndSettle();

    expect(find.text('Your place has been given up.'), findsOneWidget);
    expect(find.byType(QrImageView), findsNothing, reason: 'no ticket once cancelled');
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('Cancel my place'), findsNothing);
    expect(world.store.registrationById(id)!.status, RegistrationStatus.cancelled);
  });

  testWidgets('"Keep my place" leaves everything alone', (tester) async {
    final world = TestWorld();
    final id = ticketId(world, 'summer-meetup');
    await pumpApp(tester, TicketDetailScreen(ticketId: id), world: world, setup: signIn);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Cancel my place'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel my place'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep my place'));
    await tester.pumpAndSettle();
    expect(find.byType(QrImageView), findsOneWidget);
    expect(world.store.registrationById(id)!.status, RegistrationStatus.confirmed);
  });

  testWidgets('a waitlisted place has no QR and explains why', (tester) async {
    final world = TestWorld();
    final id = ticketId(world, 'summer-meetup');
    world.store.registrationById(id)!.status = RegistrationStatus.waitlist;
    await pumpApp(tester, TicketDetailScreen(ticketId: id), world: world, setup: signIn);
    await tester.pumpAndSettle();
    expect(find.byType(QrImageView), findsNothing);
    expect(find.textContaining("You're on the waitlist"), findsOneWidget);
    expect(find.text('On the waitlist'), findsOneWidget);
    expect(find.text('Cancel my place'), findsOneWidget, reason: 'can still leave the queue');
  });

  testWidgets('a started event keeps the QR but cannot be cancelled', (tester) async {
    final world = TestWorld();
    final id = ticketId(world, 'spring-kickoff');
    await pumpApp(tester, TicketDetailScreen(ticketId: id), world: world, setup: signIn);
    await tester.pumpAndSettle();
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text("You're checked in."), findsOneWidget);
    expect(find.text('Cancel my place'), findsNothing);
    expect(find.textContaining('has already started'), findsOneWidget);
  });

  testWidgets("someone else's ticket is not available", (tester) async {
    final world = TestWorld();
    final other = world.store.registrations.firstWhere((r) => r.userId == null).id;
    await pumpApp(tester, TicketDetailScreen(ticketId: other), world: world, setup: signIn);
    await tester.pumpAndSettle();
    expect(find.text("This ticket isn't available"), findsOneWidget);
    expect(find.byType(QrImageView), findsNothing);
  });
}
