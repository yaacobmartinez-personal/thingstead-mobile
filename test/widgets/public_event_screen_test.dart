import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/ui/pill_button.dart';
import 'package:thingstead/core/ui/slide_to_act.dart';
import 'package:thingstead/features/attendee/orgs/application/recent_orgs_controller.dart';
import 'package:thingstead/features/attendee/orgs/presentation/org_events_screen.dart';
import 'package:thingstead/features/attendee/orgs/presentation/public_event_screen.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  Future<void> signIn(ProviderContainer c, [String email = 'door@acme.test']) =>
      c.read(authControllerProvider.notifier).signInWithPassword(email, FakeAccounts.password);

  testWidgets('the org page lists published events and remembers the org', (tester) async {
    final world = TestWorld();
    final c = await pumpApp(tester, const OrgEventsScreen(orgSlug: 'acme'), world: world);
    await tester.pumpAndSettle();

    expect(find.text('Acme Meetups'), findsOneWidget);
    expect(find.text('Design Workshop'), findsOneWidget);
    expect(find.text('Summer Meetup'), findsOneWidget);
    expect(find.text('Founders Dinner'), findsNothing, reason: 'draft');
    expect(find.text('Spring Kickoff'), findsNothing, reason: 'closed');
    expect(find.text('1 of 20 place left'), findsOneWidget);
    expect(find.text('Full · waitlist open'), findsOneWidget);
    expect(c.read(recentOrgsProvider).value!.map((o) => o.slug), ['acme']);
  });

  testWidgets('an unknown org code shows not-found', (tester) async {
    await pumpApp(tester, const OrgEventsScreen(orgSlug: 'nope'), world: TestWorld());
    await tester.pumpAndSettle();
    expect(find.text('Organization not found'), findsOneWidget);
  });

  testWidgets('signed out, Register goes to login and comes back here', (tester) async {
    await pumpApp(
      tester,
      const PublicEventScreen(orgSlug: 'acme', eventSlug: 'design-workshop'),
      world: TestWorld(),
    );
    await tester.pumpAndSettle();
    expect(find.text('Design Workshop'), findsOneWidget);
    expect(find.textContaining('Laptops recommended'), findsOneWidget);
    expect(find.text('Swipe to register'), findsOneWidget);

    await tester.longPress(find.byType(SlideToAct));
    await tester.pumpAndSettle();
    expect(find.textContaining('route:/auth/login?from=%2F'), findsOneWidget);
  });

  testWidgets('signed in, registering shows the outcome and offers the ticket', (tester) async {
    final world = TestWorld();
    await pumpApp(
      tester,
      const PublicEventScreen(orgSlug: 'acme', eventSlug: 'design-workshop'),
      world: world,
      setup: signIn,
    );
    await tester.pumpAndSettle();

    await tester.longPress(find.byType(SlideToAct));
    await tester.pumpAndSettle();
    expect(find.text('Your name'), findsOneWidget);
    expect(find.text('Door Staff'), findsOneWidget, reason: 'prefilled from the account');
    expect(find.text('door@acme.test'), findsOneWidget);

    await tester.tap(find.widgetWithText(PillButton, 'Register'));
    await tester.pumpAndSettle();
    expect(find.text("You're registered"), findsOneWidget);
    expect(find.text('View my ticket'), findsOneWidget);

    await tester.tap(find.text('View my ticket'));
    await tester.pumpAndSettle();
    final user = world.store.userByEmail('door@acme.test')!;
    final row = world.store.registrations.firstWhere((r) => r.userId == user.id);
    expect(row.status, RegistrationStatus.confirmed);
    expect(find.textContaining('route:/a/tickets/${row.id}'), findsOneWidget);
  });

  testWidgets('a full event with a waitlist offers to join it', (tester) async {
    await pumpApp(
      tester,
      const PublicEventScreen(orgSlug: 'acme', eventSlug: 'summer-meetup'),
      world: TestWorld(),
      setup: signIn,
    );
    await tester.pumpAndSettle();
    expect(find.text('Swipe to join the waitlist'), findsOneWidget);

    await tester.longPress(find.byType(SlideToAct));
    await tester.pumpAndSettle();
    expect(find.textContaining("you'll be emailed if a place opens up"), findsOneWidget);
    await tester.tap(find.widgetWithText(PillButton, 'Join the waitlist'));
    await tester.pumpAndSettle();
    expect(find.text("You're on the waitlist"), findsOneWidget);
  });

  testWidgets('a full event without a waitlist has a disabled button', (tester) async {
    final world = TestWorld();
    final acme = world.store.tenantBySlug('acme')!;
    world.store.eventBySlug(acme.id, 'design-workshop')!.capacity = 19;
    await pumpApp(
      tester,
      const PublicEventScreen(orgSlug: 'acme', eventSlug: 'design-workshop'),
      world: world,
      setup: signIn,
    );
    await tester.pumpAndSettle();
    expect(tester.widget<SlideToAct>(find.byType(SlideToAct)).enabled, isFalse);
    expect(find.text('Full — no places left'), findsOneWidget);
  });

  testWidgets('a draft event is not open', (tester) async {
    await pumpApp(
      tester,
      const PublicEventScreen(orgSlug: 'acme', eventSlug: 'founders-dinner'),
      world: TestWorld(),
    );
    await tester.pumpAndSettle();
    expect(find.text('This event is not open'), findsOneWidget);
  });
}
