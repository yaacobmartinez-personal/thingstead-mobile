import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/router/app_router.dart';
import 'package:thingstead/core/theme/app_theme.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';

import '../helpers/fakes.dart';

/// Drives the real router: sign-in from the login screen must move the app
/// to the right shell, and sign-out must return to the attendee shell.
void main() {
  Future<ProviderContainer> pumpRouter(WidgetTester tester, TestWorld world) async {
    final container = ProviderContainer(overrides: world.overrides);
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: ref.watch(appRouterProvider),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  /// The top-most matched route (pushed screens included).
  String location(ProviderContainer c) =>
      c.read(appRouterProvider).routerDelegate.currentConfiguration.last.matchedLocation;

  testWidgets('signed out boots to Find events', (tester) async {
    final c = await pumpRouter(tester, TestWorld());
    expect(location(c), '/a/events');
    expect(find.text('Find events'), findsWidgets);
  });

  testWidgets('organizer sign-in from the login screen lands on /o/events',
      (tester) async {
    final c = await pumpRouter(tester, TestWorld());

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(location(c), '/auth/login');

    await tester.enterText(find.widgetWithText(TextField, 'Email'), FakeAccounts.organizerEmail);
    await tester.enterText(find.widgetWithText(TextField, 'Password'), FakeAccounts.password);
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(c.read(authControllerProvider).isSignedIn, isTrue);
    expect(location(c), '/o/events');
    expect(find.text('Settings'), findsOneWidget); // organizer tab bar
  });

  testWidgets('attendee sign-in returns to the attendee shell', (tester) async {
    final c = await pumpRouter(tester, TestWorld());
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Email'), FakeAccounts.attendeeEmail);
    await tester.enterText(find.widgetWithText(TextField, 'Password'), FakeAccounts.password);
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    // Attendees return to where they tapped Sign in.
    expect(location(c), '/a/account');
    expect(find.text('Signed in'), findsOneWidget);
  });

  testWidgets('sign-out from organizer settings returns to attendee home',
      (tester) async {
    final c = await pumpRouter(tester, TestWorld());
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    await tester.pumpAndSettle();
    c.read(appRouterProvider).go('/o/events');
    await tester.pumpAndSettle();
    expect(location(c), '/o/events');

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(c.read(authControllerProvider).isSignedIn, isFalse);
    expect(location(c), '/a/events');
  });
}
