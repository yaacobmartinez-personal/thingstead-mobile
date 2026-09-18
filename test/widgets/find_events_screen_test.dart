import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/ui/pill_button.dart';
import 'package:thingstead/features/attendee/orgs/application/recent_orgs_controller.dart';
import 'package:thingstead/features/attendee/orgs/domain/public_org.dart';
import 'package:thingstead/features/attendee/orgs/presentation/find_events_screen.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

void main() {
  testWidgets('a code opens the org page; bad codes are explained', (tester) async {
    await pumpApp(tester, const FindEventsScreen(), world: TestWorld());
    await tester.pumpAndSettle();
    expect(find.text('thingstead.pro/'), findsOneWidget, reason: 'prefix hint');

    await tester.tap(find.widgetWithText(PillButton, 'Show events'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the organization code from your invitation.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Not A Code');
    await tester.tap(find.widgetWithText(PillButton, 'Show events'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Codes are 3–63'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Acme');
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    expect(find.text('route:/a/events/orgs/acme'), findsOneWidget);
  });

  testWidgets('a pasted link is understood too', (tester) async {
    await pumpApp(tester, const FindEventsScreen(), world: TestWorld());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'https://thingstead.pro/acme/summer-meetup');
    await tester.tap(find.widgetWithText(PillButton, 'Show events'));
    await tester.pumpAndSettle();
    expect(find.text('route:/a/events/orgs/acme/events/summer-meetup'), findsOneWidget);
  });

  testWidgets('recent orgs are listed and open on tap', (tester) async {
    final world = TestWorld();
    await pumpApp(
      tester,
      const FindEventsScreen(),
      world: world,
      setup: (c) async {
        await c.read(recentOrgsProvider.future);
        await c
            .read(recentOrgsProvider.notifier)
            .remember(const PublicOrg(slug: 'beta', name: 'Beta Collective'));
      },
    );
    await tester.pumpAndSettle();
    expect(find.text('RECENT'), findsOneWidget);
    expect(find.text('Beta Collective'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Beta Collective'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beta Collective'));
    await tester.pumpAndSettle();
    expect(find.text('route:/a/events/orgs/beta'), findsOneWidget);
  });
}
