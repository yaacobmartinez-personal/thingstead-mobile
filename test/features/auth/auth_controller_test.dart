import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/network/api_client.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/core/network/token_codec.dart';
import 'package:thingstead/core/network/unauthorized_events.dart';
import 'package:thingstead/core/storage/boot_data.dart';
import 'package:thingstead/core/storage/prefs.dart';
import 'package:thingstead/core/storage/secure_store.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/auth/application/auth_state.dart';
import 'package:thingstead/features/auth/domain/user.dart';
import 'package:thingstead/features/shell/application/app_mode_controller.dart';

import '../../helpers/fakes.dart';

void main() {
  group('boot', () {
    test('no token → signed out', () {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      expect(c.read(authControllerProvider), const AuthState.signedOut());
      expect(c.read(currentTokenProvider), isNull);
    });

    test('expired token → signed out', () {
      final expired = TokenCodec.mintFake('u_1', testNow.subtract(const Duration(days: 1)));
      final world = TestWorld(
        boot: BootData(
          token: expired,
          user: const User(id: 'u_1', email: FakeAccounts.organizerEmail),
        ),
      );
      final c = world.container();
      addTearDown(c.dispose);
      expect(c.read(authControllerProvider).isSignedIn, isFalse);
      expect(c.read(currentTokenProvider), isNull);
    });

    test('valid token → signed in with cached orgs, then refreshed', () async {
      final token = TokenCodec.mintFake('u_1', testNow.add(const Duration(days: 10)));
      final world = TestWorld(
        boot: BootData(
          token: token,
          user: const User(id: 'u_1', email: FakeAccounts.organizerEmail, name: 'Demo'),
          appMode: 'organizer',
        ),
      );
      final c = world.container();
      addTearDown(c.dispose);

      final initial = c.read(authControllerProvider);
      expect(initial.isSignedIn, isTrue);
      expect(initial.orgs, isEmpty); // nothing cached in this boot
      expect(c.read(currentTokenProvider), token);
      expect(c.read(appModeControllerProvider), AppMode.organizer);

      await Future<void>.delayed(Duration.zero); // let the microtask run
      await Future<void>.delayed(Duration.zero);
      final refreshed = c.read(authControllerProvider) as SignedIn;
      expect(refreshed.orgsFresh, isTrue);
      expect(refreshed.orgs.map((o) => o.slug), ['acme', 'beta']);
      expect(world.secure.values[SecureStore.keyOrgs], contains('acme'));
    });

    test('valid token for a deleted user → signed out as expired', () async {
      final token = TokenCodec.mintFake('u_999', testNow.add(const Duration(days: 10)));
      final world = TestWorld(
        boot: BootData(token: token, user: const User(id: 'u_999', email: 'gone@x.test')),
      );
      final c = world.container();
      addTearDown(c.dispose);
      await c.read(authControllerProvider.notifier).bootRefresh;
      expect(
        c.read(authControllerProvider),
        const AuthState.signedOut(reason: SignOutReason.sessionExpired),
      );
    });
  });

  group('password sign-in', () {
    test('organizer lands in organizer mode with orgs loaded', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);

      await c
          .read(authControllerProvider.notifier)
          .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);

      final s = c.read(authControllerProvider) as SignedIn;
      expect(s.user.email, FakeAccounts.organizerEmail);
      expect(s.orgsFresh, isTrue);
      expect(s.hasOrganizerAccess, isTrue);
      expect(c.read(appModeControllerProvider), AppMode.organizer);
      expect(c.read(currentTokenProvider), s.token);
      expect(world.secure.values[SecureStore.keyToken], s.token);
      expect(world.prefs.values[Prefs.keyAppMode], 'organizer');
    });

    test('attendee lands in attendee mode', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);

      await c
          .read(authControllerProvider.notifier)
          .signInWithPassword(FakeAccounts.attendeeEmail, FakeAccounts.password);

      expect(c.read(authControllerProvider).hasOrganizerAccess, isFalse);
      expect(c.read(appModeControllerProvider), AppMode.attendee);
    });

    test('wrong password throws 401 and leaves the state alone', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);

      await expectLater(
        c.read(authControllerProvider.notifier).signInWithPassword(
              FakeAccounts.organizerEmail,
              'nope',
            ),
        throwsA(isA<ApiError>().having((e) => e.status, 'status', 401)),
      );
      expect(c.read(authControllerProvider).isSignedIn, isFalse);
      expect(world.secure.values, isEmpty);
    });

    test('unverified account cannot sign in', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      final auth = c.read(authControllerProvider.notifier);

      await auth.signUp(email: 'new@x.test', password: 'password123', name: 'New');
      await expectLater(
        auth.signInWithPassword('new@x.test', 'password123'),
        throwsA(isA<ApiError>().having((e) => e.status, 'status', 401)),
      );
    });
  });

  group('sign-out paths', () {
    Future<(TestWorld, ProviderContainer)> signedInWorld() async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      await c
          .read(authControllerProvider.notifier)
          .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
      return (world, c);
    }

    test('signOut wipes the session and returns to attendee mode', () async {
      final (world, c) = await signedInWorld();
      await c.read(authControllerProvider.notifier).signOut();

      expect(
        c.read(authControllerProvider),
        const AuthState.signedOut(reason: SignOutReason.user),
      );
      expect(c.read(currentTokenProvider), isNull);
      expect(world.secure.values.containsKey(SecureStore.keyToken), isFalse);
      expect(c.read(appModeControllerProvider), AppMode.attendee);
    });

    test('a 401 from any request signs out as expired', () async {
      final (world, c) = await signedInWorld();
      c.read(unauthorizedEventsProvider).emit();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      expect(
        c.read(authControllerProvider),
        const AuthState.signedOut(reason: SignOutReason.sessionExpired),
      );
    });

    test('changing server ends the session', () async {
      final (world, c) = await signedInWorld();
      await c.read(authControllerProvider.notifier).changeServer('http://10.0.2.2:3000/');
      expect(
        c.read(authControllerProvider),
        const AuthState.signedOut(reason: SignOutReason.serverChanged),
      );
      expect(world.secure.values[SecureStore.keyServerUrl], 'http://10.0.2.2:3000');
    });
  });

  group('account', () {
    test('sole admin of a populated org cannot delete', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      final auth = c.read(authControllerProvider.notifier);
      await auth.signInWithPassword('owner@beta.test', FakeAccounts.password);

      await expectLater(
        auth.deleteAccount(),
        throwsA(
          isA<ApiError>()
              .having((e) => e.status, 'status', 409)
              .having((e) => e.reason, 'reason', 'sole_admin'),
        ),
      );
      expect(c.read(authControllerProvider).isSignedIn, isTrue);
    });

    test('an attendee can delete and is signed out', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      final auth = c.read(authControllerProvider.notifier);
      await auth.signInWithPassword(FakeAccounts.attendeeEmail, FakeAccounts.password);

      await auth.deleteAccount();
      expect(
        c.read(authControllerProvider),
        const AuthState.signedOut(reason: SignOutReason.accountDeleted),
      );
      expect(world.store.userByEmail(FakeAccounts.attendeeEmail), isNull);
    });

    test('updateName persists', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      final auth = c.read(authControllerProvider.notifier);
      await auth.signInWithPassword(FakeAccounts.attendeeEmail, FakeAccounts.password);

      await auth.updateName('  Alex R.  ');
      expect(c.read(authControllerProvider).user?.name, 'Alex R.');
      expect(world.secure.values[SecureStore.keyUser], contains('Alex R.'));
    });
  });

  group('signup and recovery', () {
    test('signup → verify from the outbox → signed in as attendee', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      final auth = c.read(authControllerProvider.notifier);

      await auth.signUp(email: 'new@x.test', password: 'password123', name: 'New Person');
      final mail = world.store.outbox.last;
      expect(mail.to, 'new@x.test');

      await auth.verifyEmail(mail.token);
      expect(c.read(authControllerProvider).user?.email, 'new@x.test');
      expect(c.read(appModeControllerProvider), AppMode.attendee);

      // Single use.
      await auth.signOut();
      await expectLater(auth.verifyEmail(mail.token), throwsA(isA<ApiError>()));
    });

    test('signup with an existing verified email is silent', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      final before = world.store.outbox.length;
      await c.read(authControllerProvider.notifier).signUp(
            email: FakeAccounts.organizerEmail,
            password: 'password123',
            name: 'Impostor',
          );
      expect(world.store.outbox.length, before);
      expect(world.store.userByEmail(FakeAccounts.organizerEmail)?.name, 'Demo Organizer');
    });

    test('forgot → reset from the outbox → signed in with the new password', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      final auth = c.read(authControllerProvider.notifier);

      await auth.forgotPassword(FakeAccounts.attendeeEmail);
      final mail = world.store.outbox.last;
      await auth.resetPassword(mail.token, 'newpassword1');
      expect(c.read(authControllerProvider).isSignedIn, isTrue);

      await auth.signOut();
      await auth.signInWithPassword(FakeAccounts.attendeeEmail, 'newpassword1');
      expect(c.read(authControllerProvider).isSignedIn, isTrue);
    });

    test('forgot for an unknown email sends nothing but succeeds', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      final before = world.store.outbox.length;
      await c.read(authControllerProvider.notifier).forgotPassword('nobody@x.test');
      expect(world.store.outbox.length, before);
    });
  });

  group('social', () {
    test('Google creates or links an account and signs in', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      final ok = await c.read(authControllerProvider.notifier).signInWithGoogle();
      expect(ok, isTrue);
      expect(c.read(authControllerProvider).user?.email, FakeAccounts.attendeeEmail);
    });

    test('Apple keeps the name from the first authorization', () async {
      final world = TestWorld();
      final c = world.container();
      addTearDown(c.dispose);
      final ok = await c.read(authControllerProvider.notifier).signInWithApple();
      expect(ok, isTrue);
      expect(world.secure.values[SecureStore.keyAppleFullName], contains('Demo'));
      expect(c.read(authControllerProvider).hasOrganizerAccess, isTrue);
    });
  });
}

