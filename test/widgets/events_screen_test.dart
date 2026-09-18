import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/events/presentation/events_screen.dart';
import 'package:thingstead/features/organizer/orgs/application/selected_org_controller.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  testWidgets('renders cards with status, date, counts, and a scan button', (tester) async {
    final world = TestWorld();
    final c = await pumpApp(tester, const EventsScreen(), world: world);
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    await tester.pumpAndSettle();

    expect(find.text('Acme Meetups'), findsOneWidget); // app bar = org name
    expect(find.text('Summer Meetup'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget); // past event sorts first
    await tester.scrollUntilVisible(find.text('Draft'), 200);
    expect(find.text('Draft'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('40 / 40'), -200);
    expect(find.text('40 / 40'), findsOneWidget); // full event headcount
    expect(find.widgetWithText(FilledButton, 'Scan check-in'), findsWidgets);
    expect(find.byIcon(Icons.swap_horiz), findsOneWidget); // two orgs → switcher
  });

  testWidgets('switching org swaps the list', (tester) async {
    final world = TestWorld();
    final c = await pumpApp(tester, const EventsScreen(), world: world);
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    await tester.pumpAndSettle();

    c.read(selectedOrgSlugProvider.notifier).set('beta');
    await tester.pumpAndSettle();
    expect(find.text('Beta Collective'), findsOneWidget);
    expect(find.text('Community Hackathon'), findsOneWidget);
    expect(find.text('Summer Meetup'), findsNothing);
    expect(find.text('7'), findsOneWidget); // uncapped headcount is just the count
  });

  testWidgets('shows the empty state for an org with no events', (tester) async {
    final world = TestWorld();
    final beta = world.store.tenantBySlug('beta')!;
    world.store.events.removeWhere((e) => e.tenantId == beta.id);
    final c = await pumpApp(tester, const EventsScreen(), world: world);
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    c.read(selectedOrgSlugProvider.notifier).set('beta');
    await tester.pumpAndSettle();
    expect(find.text('No events yet'), findsOneWidget);
  });
}
