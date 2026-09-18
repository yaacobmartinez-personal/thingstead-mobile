import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/ui/pill_button.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/auth/data/fake_auth_repository.dart';
import 'package:thingstead/features/auth/presentation/login_screen.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  Finder field(String label) => find.widgetWithText(TextField, label);

  testWidgets('empty submit shows a validation message', (tester) async {
    await pumpApp(tester, const LoginScreen(), world: TestWorld());
    await tester.tap(find.widgetWithText(PillButton, 'Sign in'));
    await tester.pump();
    expect(find.text('Enter your email and password.'), findsOneWidget);
  });

  testWidgets('wrong password shows the server message and stays signed out',
      (tester) async {
    final c = await pumpApp(tester, const LoginScreen(), world: TestWorld());
    await tester.enterText(field('Email'), FakeAccounts.organizerEmail);
    await tester.enterText(field('Password'), 'wrong');
    await tester.tap(find.widgetWithText(PillButton, 'Sign in'));
    await tester.pump(); // busy
    await tester.pump(); // resolved
    expect(find.text(FakeAuthRepository.wrongCredentials), findsOneWidget);
    expect(c.read(authControllerProvider).isSignedIn, isFalse);
  });

  testWidgets('correct credentials sign in', (tester) async {
    final c = await pumpApp(tester, const LoginScreen(), world: TestWorld());
    await tester.enterText(field('Email'), FakeAccounts.organizerEmail);
    await tester.enterText(field('Password'), FakeAccounts.password);
    await tester.tap(find.widgetWithText(PillButton, 'Sign in'));
    await tester.pump();
    await tester.pump();
    expect(c.read(authControllerProvider).isSignedIn, isTrue);
  });

  testWidgets('fake mode shows social buttons, signup and forgot links',
      (tester) async {
    await pumpApp(tester, const LoginScreen(), world: TestWorld());
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('New here? Create an account'), findsOneWidget);
    expect(find.textContaining('Server: '), findsOneWidget);
  });

  testWidgets('Google button signs in', (tester) async {
    final c = await pumpApp(tester, const LoginScreen(), world: TestWorld());
    await tester.ensureVisible(find.text('Continue with Google'));
    await tester.tap(find.text('Continue with Google'));
    await tester.pump();
    await tester.pump();
    expect(c.read(authControllerProvider).user?.email, FakeAccounts.attendeeEmail);
  });
}
