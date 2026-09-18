import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/scanner/domain/scan_source.dart';
import 'package:thingstead/features/organizer/scanner/presentation/scanner_screen.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  testWidgets('manual entry sheet submits a code', (tester) async {
    final world = TestWorld();
    final source = ManualScanSource();
    addTearDown(source.dispose);
    await pumpApp(
      tester,
      ScannerScreen(eventSlug: 'design-workshop', source: source),
      world: world,
      setup: (c) => c
          .read(authControllerProvider.notifier)
          .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Enter a code'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a ticket code'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'chk_r_20');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Wrong event'), findsOneWidget);
  });
}
