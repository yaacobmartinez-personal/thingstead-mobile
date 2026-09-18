import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/router/routes.dart';
import 'package:thingstead/core/ui/pill_button.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/auth/presentation/signup_screen.dart';
import 'package:thingstead/features/organizer/onboarding/application/organize_intent.dart';
import 'package:thingstead/features/organizer/onboarding/presentation/create_org_screen.dart';
import 'package:thingstead/features/shell/application/app_mode_controller.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  Finder field(String label) => find.widgetWithText(TextField, label);

  Future<void> signInAttendee(container) => container
      .read(authControllerProvider.notifier)
      .signInWithPassword(FakeAccounts.attendeeEmail, FakeAccounts.password);

  group('CreateOrgScreen', () {
    testWidgets('the address follows the name and is checked live', (tester) async {
      await pumpApp(tester, const CreateOrgScreen(), world: TestWorld(), setup: signInAttendee);
      await tester.pumpAndSettle();

      await tester.enterText(field('Organization name'), 'Green Club');
      await tester.pump();
      expect(find.text('green-club'), findsOneWidget);
      // The debounce, then the fake round-trip.
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('thingstead.pro/green-club is yours'), findsOneWidget);

      await tester.enterText(field('Address'), 'acme');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('That address is already taken.'), findsOneWidget);

      await tester.enterText(field('Address'), 'admin');
      await tester.pump();
      expect(find.text("That address isn't available."), findsOneWidget);
    });

    testWidgets('creating the org switches to organizer mode and opens the first event', (tester) async {
      final c = await pumpApp(tester, const CreateOrgScreen(), world: TestWorld(), setup: signInAttendee);
      await tester.pumpAndSettle();

      await tester.enterText(field('Organization name'), 'Green Club');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(PillButton, 'Create organization'));
      await tester.pumpAndSettle();

      expect(find.text('route:${Routes.orgFirstEvent}'), findsOneWidget);
      expect(c.read(authControllerProvider).hasOrganizerAccess, isTrue);
      expect(c.read(appModeControllerProvider), AppMode.organizer);
    });

    testWidgets('server field errors land on the fields', (tester) async {
      await pumpApp(tester, const CreateOrgScreen(), world: TestWorld(), setup: signInAttendee);
      await tester.pumpAndSettle();
      await tester.enterText(field('Organization name'), 'A');
      await tester.pump();
      await tester.tap(find.widgetWithText(PillButton, 'Create organization'));
      await tester.pumpAndSettle();
      expect(find.text('Organization name is too short.'), findsOneWidget);
    });
  });

  group('signup intent', () {
    testWidgets('"Organize events" is remembered for after verification', (tester) async {
      final world = TestWorld();
      final c = await pumpApp(tester, const SignupScreen(), world: world);
      await tester.pumpAndSettle();
      expect(c.read(organizeIntentProvider), isFalse);

      await tester.tap(find.text('Organize events'));
      await tester.pumpAndSettle();
      expect(find.text('Your organization comes next'), findsOneWidget);

      await tester.enterText(field('Name'), 'New Organizer');
      await tester.enterText(field('Email'), 'new@example.com');
      await tester.enterText(field('Password'), 'password123');
      await tester.tap(find.widgetWithText(PillButton, 'Create account'));
      await tester.pumpAndSettle();

      expect(c.read(organizeIntentProvider), isTrue);
      expect(find.textContaining('route:${Routes.checkEmail}'), findsOneWidget);
    });

    testWidgets('arriving from the organizer path preselects it', (tester) async {
      await pumpApp(tester, const SignupScreen(organize: true), world: TestWorld());
      await tester.pumpAndSettle();
      expect(find.text('Your organization comes next'), findsOneWidget);
    });
  });
}
