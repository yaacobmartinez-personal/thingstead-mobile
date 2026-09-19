import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/config/dev_tools.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/features/attendee/account/presentation/account_screen.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/auth/presentation/login_screen.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

/// Stands in for a release build, where [DevTools] starts hidden.
class _Hidden extends DevTools {
  @override
  bool build() => false;
}

void main() {
  final hidden = [devToolsProvider.overrideWith(_Hidden.new)];

  testWidgets('the server address is hidden until the version line is long-pressed', (tester) async {
    await pumpApp(
      tester,
      const AccountScreen(),
      world: TestWorld(),
      extraOverrides: hidden,
      setup: (c) => c
          .read(authControllerProvider.notifier)
          .signInWithPassword(FakeAccounts.attendeeEmail, FakeAccounts.password),
    );
    await tester.pumpAndSettle();
    expect(find.text('Server address'), findsNothing);

    await tester.ensureVisible(find.textContaining('Thingstead 0.1.0', skipOffstage: false));
    await tester.pumpAndSettle();
    await tester.longPress(find.textContaining('Thingstead 0.1.0'));
    await tester.pumpAndSettle();
    expect(find.text('Server settings unlocked.'), findsOneWidget);
    expect(find.text('Server address'), findsOneWidget);
  });

  testWidgets('the login footer follows the same switch', (tester) async {
    await pumpApp(tester, const LoginScreen(), world: TestWorld(), extraOverrides: hidden);
    await tester.pumpAndSettle();
    expect(find.textContaining('Server: '), findsNothing);
  });

  testWidgets('debug builds show it by default', (tester) async {
    await pumpApp(tester, const LoginScreen(), world: TestWorld());
    await tester.pumpAndSettle();
    expect(find.textContaining('Server: '), findsOneWidget);
  });
}
