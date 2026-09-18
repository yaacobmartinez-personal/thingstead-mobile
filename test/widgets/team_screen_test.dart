import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/orgs/application/selected_org_controller.dart';
import 'package:thingstead/features/organizer/team/presentation/team_screen.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  Future<void> signIn(ProviderContainer c) => c
      .read(authControllerProvider.notifier)
      .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);

  testWidgets('lists members with roles and pending invitations', (tester) async {
    await pumpApp(tester, const TeamScreen(), world: TestWorld(), setup: signIn);
    await tester.pumpAndSettle();

    expect(find.text('MEMBERS (3)'), findsOneWidget);
    expect(find.text('Demo Organizer'), findsOneWidget);
    expect(find.text('(you)'), findsOneWidget);
    expect(find.text('Admin'), findsNWidgets(3)); // two admins + one expired admin invite
    expect(find.text('Staff'), findsNWidgets(2)); // one staff member + one pending invite
    expect(find.text('PENDING INVITATIONS (2)'), findsOneWidget);
    expect(find.text('newhire@acme.test'), findsOneWidget);
    expect(find.textContaining('Expired'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Revoke'), findsNWidgets(2));
    expect(find.widgetWithText(FloatingActionButton, 'Invite'), findsOneWidget);
  });

  testWidgets('staff see an admins-only note instead of the list', (tester) async {
    final world = TestWorld();
    await pumpApp(
      tester,
      const TeamScreen(),
      world: world,
      setup: (c) async {
        await signIn(c);
        c.read(selectedOrgSlugProvider.notifier).set('beta');
      },
    );
    await tester.pumpAndSettle();
    expect(find.text('Admins only'), findsOneWidget);
    expect(find.widgetWithText(FloatingActionButton, 'Invite'), findsNothing);
  });

  testWidgets('the last-admin rule disables demotion and removal', (tester) async {
    final world = TestWorld();
    // Leave demo as the only admin of Acme.
    final acme = world.store.tenantBySlug('acme')!;
    final maria = world.store.userByEmail('maria@acme.test')!;
    world.store.membership(maria.id, acme.id)!.role = Role.staff;

    await pumpApp(tester, const TeamScreen(), world: world, setup: signIn);
    await tester.pumpAndSettle();

    // Open the menu on the (you) row.
    final selfCard = find.ancestor(of: find.text('(you)'), matching: find.byType(Card));
    await tester.tap(find.descendant(of: selfCard, matching: find.byType(PopupMenuButton<String>)));
    await tester.pumpAndSettle();

    final makeStaff = find.widgetWithText(PopupMenuItem<String>, 'Make staff');
    expect(makeStaff, findsOneWidget);
    expect(tester.widget<PopupMenuItem<String>>(makeStaff).enabled, isFalse);
    final leave = find.widgetWithText(PopupMenuItem<String>, 'Leave organization');
    expect(tester.widget<PopupMenuItem<String>>(leave).enabled, isFalse);
    expect(
      find.text('This is the only admin. Make someone else an admin first.'),
      findsNWidgets(2),
    );
  });

  testWidgets('invite sheet sends and the invitation appears', (tester) async {
    final world = TestWorld();
    await pumpApp(tester, const TeamScreen(), world: world, setup: signIn);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Invite'));
    await tester.pumpAndSettle();
    expect(find.text('Invite a teammate'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'sam@example.com');
    await tester.tap(find.text('Admin').last); // the role radio in the sheet
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Send invitation'));
    await tester.pumpAndSettle();

    expect(find.text('Invitation sent to sam@example.com.'), findsOneWidget);
    expect(find.text('PENDING INVITATIONS (3)'), findsOneWidget);
    expect(find.text('sam@example.com'), findsOneWidget);
    final sent = world.store.invitations.firstWhere((i) => i.email == 'sam@example.com');
    expect(sent.role, Role.admin);
  });

  testWidgets('revoke removes an invitation', (tester) async {
    final world = TestWorld();
    await pumpApp(tester, const TeamScreen(), world: world, setup: signIn);
    await tester.pumpAndSettle();

    final row = find.ancestor(of: find.text('newhire@acme.test'), matching: find.byType(Card));
    await tester.tap(find.descendant(of: row, matching: find.text('Revoke')));
    await tester.pumpAndSettle();

    expect(find.text('newhire@acme.test'), findsNothing);
    expect(find.text('PENDING INVITATIONS (1)'), findsOneWidget);
    expect(world.store.invitations.where((i) => i.email == 'newhire@acme.test'), isEmpty);
  });
}
