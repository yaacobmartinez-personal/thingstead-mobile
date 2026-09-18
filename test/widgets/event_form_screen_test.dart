import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/ui/pill_button.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/events/presentation/event_form_screen.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  Future<void> signIn(ProviderContainer c) => c
      .read(authControllerProvider.notifier)
      .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);

  Finder field(String label) => find.ancestor(
        of: find.text(label, skipOffstage: false),
        matching: find.byType(TextField, skipOffstage: false),
      );

  /// Scrolls a built-but-offstage widget into view. Drags would start on a
  /// text field and scroll it instead of the list, so use ensureVisible.
  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('a new event shows the draft note and validates before sending', (tester) async {
    final world = TestWorld();
    await pumpApp(tester, const EventFormScreen(), world: world, setup: signIn);
    await tester.pumpAndSettle();

    expect(find.text('New event'), findsOneWidget);
    expect(find.textContaining('Events start as a draft'), findsOneWidget);

    await reveal(tester, find.byType(SwitchListTile, skipOffstage: false));
    await reveal(tester, find.widgetWithText(PillButton, 'Create event', skipOffstage: false));
    await tester.tap(find.widgetWithText(PillButton, 'Create event'));
    await tester.pumpAndSettle();
    expect(find.text('Pick a start date and time.'), findsOneWidget);
    // The title is back up top; scroll to it.
    await reveal(tester, find.text('Give the event a title.', skipOffstage: false));
    expect(find.text('Give the event a title.'), findsOneWidget);
    expect(world.store.events.where((e) => e.title == ''), isEmpty);
  });

  testWidgets('the link follows the title until edited', (tester) async {
    final world = TestWorld();
    await pumpApp(tester, const EventFormScreen(), world: world, setup: signIn);
    await tester.pumpAndSettle();

    await tester.enterText(field('Title'), 'Autumn Social!');
    await tester.pump();
    expect(find.text('autumn-social'), findsOneWidget);
    expect(find.textContaining('thingstead.pro/acme/autumn-social'), findsOneWidget);

    await tester.enterText(field('Link'), 'Fall Party');
    await tester.pump();
    expect(find.text('fall-party'), findsOneWidget);

    await tester.enterText(field('Title'), 'Something else');
    await tester.pump();
    expect(find.text('fall-party'), findsOneWidget, reason: 'edited slug is kept');
  });

  testWidgets('picking a start date and time fills the field', (tester) async {
    final world = TestWorld();
    await pumpApp(tester, const EventFormScreen(), world: world, setup: signIn);
    await tester.pumpAndSettle();

    await tester.tap(find.ancestor(of: find.text('Starts'), matching: find.byType(InkWell)).first);
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Default suggestion: tomorrow at 18:00.
    expect(find.textContaining('6:00 PM'), findsOneWidget);
  });

  testWidgets('editing seeds every field and saves through the fake', (tester) async {
    final world = TestWorld();
    await pumpApp(
      tester,
      const EventFormScreen(eventSlug: 'founders-dinner'),
      world: world,
      setup: signIn,
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit event'), findsOneWidget);
    expect(find.text('Founders Dinner'), findsOneWidget);
    expect(find.text('founders-dinner'), findsOneWidget);
    await tester.enterText(field('Title'), 'Founders Dinner 2026');
    await reveal(tester, find.text('Asia/Manila', skipOffstage: false));
    expect(find.text('Asia/Manila'), findsOneWidget);
    expect(find.textContaining('7:00 PM'), findsOneWidget); // 11:00Z in Manila
    await reveal(tester, find.byType(SwitchListTile, skipOffstage: false));
    expect(find.text('12'), findsOneWidget);
    expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value, isTrue);

    await tester.enterText(field('Capacity'), '15');
    await reveal(tester, find.widgetWithText(PillButton, 'Save changes', skipOffstage: false));
    await tester.tap(find.widgetWithText(PillButton, 'Save changes'));
    await tester.pumpAndSettle();

    final acme = world.store.tenantBySlug('acme')!;
    final saved = world.store.eventBySlug(acme.id, 'founders-dinner')!;
    expect(saved.title, 'Founders Dinner 2026');
    expect(saved.capacity, 15);
    expect(saved.status, EventStatus.draft, reason: 'saving never publishes');
    expect(find.text('Event saved.'), findsOneWidget);
  });

  testWidgets('server field errors show inline', (tester) async {
    final world = TestWorld();
    await pumpApp(
      tester,
      const EventFormScreen(eventSlug: 'summer-meetup'),
      world: world,
      setup: signIn,
    );
    await tester.pumpAndSettle();

    await reveal(tester, find.byType(SwitchListTile, skipOffstage: false));
    await tester.enterText(field('Capacity'), '10'); // 40 already confirmed
    await reveal(tester, find.widgetWithText(PillButton, 'Save changes', skipOffstage: false));
    await tester.tap(find.widgetWithText(PillButton, 'Save changes'));
    await tester.pumpAndSettle();

    expect(
      find.text("40 people already have a place, so capacity can't be lower than that."),
      findsOneWidget,
    );
    expect(find.text('Edit event'), findsOneWidget, reason: 'stays on the form');
  });
}
