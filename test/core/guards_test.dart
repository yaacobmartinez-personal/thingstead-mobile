import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/router/guards.dart';
import 'package:thingstead/features/auth/application/auth_state.dart';
import 'package:thingstead/features/auth/domain/user.dart';
import 'package:thingstead/features/organizer/orgs/domain/org.dart';
import 'package:thingstead/features/shell/application/app_mode_controller.dart';

void main() {
  const out = AuthState.signedOut();
  final attendee = SignedIn(
    user: const User(id: 'u', email: 'a@x.test'),
    token: 't',
    expiresAt: DateTime.utc(2030),
  );
  final organizer = attendee.copyWith(
    orgs: const [Org(slug: 'acme', name: 'Acme', role: Role.staff)],
  );

  String? go(String location, AuthState auth, [AppMode mode = AppMode.attendee]) =>
      computeRedirect(uri: Uri.parse(location), auth: auth, mode: mode);

  group('signed out', () {
    test('public attendee routes pass', () {
      expect(go('/a/events', out), isNull);
      expect(go('/a/tickets', out), isNull);
      expect(go('/a/account', out), isNull);
      expect(go('/a/orgs/acme/events/x', out), isNull);
      expect(go('/settings/server', out), isNull);
    });

    test('ticket detail and organizer routes go to login with from', () {
      expect(go('/a/tickets/r_1', out), '/auth/login?from=%2Fa%2Ftickets%2Fr_1');
      expect(go('/o/events', out), '/auth/login?from=%2Fo%2Fevents');
    });

    test('auth screens pass', () {
      expect(go('/auth/login', out), isNull);
      expect(go('/auth/signup', out), isNull);
    });
  });

  group('signed in', () {
    test('auth screens bounce to from or home', () {
      expect(go('/auth/login', attendee), '/a/events');
      expect(go('/auth/login', organizer, AppMode.organizer), '/o/events');
      expect(go('/auth/login?from=%2Fa%2Ftickets%2Fr_1', attendee), '/a/tickets/r_1');
    });

    test('from must be an in-app path', () {
      expect(go('/auth/login?from=https%3A%2F%2Fevil.example', attendee), '/a/events');
      expect(go('/auth/login?from=%2F%2Fevil.example', attendee), '/a/events');
      expect(go('/auth/login?from=%2Fauth%2Fsignup', attendee), '/a/events');
    });

    test('verify and reset stay reachable', () {
      expect(go('/auth/verify?token=x', attendee), isNull);
      expect(go('/auth/reset?token=x', attendee), isNull);
    });

    test('organizer shell needs a membership', () {
      expect(go('/o/events', attendee), '/a/events');
      expect(go('/o/settings', organizer), isNull);
      expect(go('/o/team', organizer), isNull); // role is shown in-screen
    });
  });

  group('session ended on a protected route', () {
    test('deliberately → attendee home', () {
      for (final r in [SignOutReason.user, SignOutReason.accountDeleted, SignOutReason.serverChanged]) {
        expect(go('/o/settings', AuthState.signedOut(reason: r)), '/a/events', reason: '');
      }
    });

    test('expired → login, coming back afterwards', () {
      expect(
        go('/o/events', const AuthState.signedOut(reason: SignOutReason.sessionExpired)),
        '/auth/login?from=%2Fo%2Fevents',
      );
    });
  });

  group('afterSignInTarget', () {
    test('organizers land in their shell unless from was already there', () {
      expect(afterSignInTarget(from: null, mode: AppMode.organizer), '/o/events');
      expect(afterSignInTarget(from: '/a/account', mode: AppMode.organizer), '/o/events');
      expect(afterSignInTarget(from: '/o/team', mode: AppMode.organizer), '/o/team');
    });

    test('attendees return to from or home', () {
      expect(afterSignInTarget(from: '/a/account', mode: AppMode.attendee), '/a/account');
      expect(afterSignInTarget(from: null, mode: AppMode.attendee), '/a/events');
      expect(afterSignInTarget(from: 'https://evil', mode: AppMode.attendee), '/a/events');
    });
  });
}