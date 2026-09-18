import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/core/router/guards.dart';
import 'package:thingstead/core/router/routes.dart';
import 'package:thingstead/core/storage/prefs.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/auth/application/auth_state.dart';
import 'package:thingstead/features/auth/data/auth_providers.dart';
import 'package:thingstead/features/auth/domain/user.dart';
import 'package:thingstead/features/organizer/onboarding/application/create_org_controller.dart';
import 'package:thingstead/features/organizer/onboarding/application/organize_intent.dart';
import 'package:thingstead/features/organizer/orgs/application/selected_org_controller.dart';
import 'package:thingstead/features/organizer/orgs/domain/org.dart';
import 'package:thingstead/features/organizer/orgs/domain/orgs_repository.dart';
import 'package:thingstead/features/shell/application/app_mode_controller.dart';

import '../../helpers/fakes.dart';

void main() {
  Future<ProviderContainer> signedIn(TestWorld world, {String email = FakeAccounts.attendeeEmail}) async {
    final c = world.container();
    await c.read(authControllerProvider.notifier).signInWithPassword(email, FakeAccounts.password);
    return c;
  }

  group('availability (#34)', () {
    test('reports reserved, invalid, taken, and free addresses', () async {
      final c = await signedIn(TestWorld());
      final repo = c.read(orgsRepositoryProvider);
      expect((await repo.availability('admin')).problem, SlugProblem.reserved);
      expect((await repo.availability('ab')).problem, SlugProblem.invalid);
      expect((await repo.availability('-acme')).problem, SlugProblem.invalid);
      expect((await repo.availability('acme')).problem, SlugProblem.taken);
      final free = await repo.availability(' Green-Club ');
      expect(free.available, isTrue);
      expect(free.slug, 'green-club');
    });

    test('needs a session', () async {
      final c = TestWorld().container();
      await expectLater(
        c.read(orgsRepositoryProvider).availability('acme'),
        throwsA(isA<ApiError>().having((e) => e.status, 'status', 401)),
      );
    });
  });

  group('create (#35)', () {
    test('validates name and address with the web wording', () async {
      final c = await signedIn(TestWorld());
      final repo = c.read(orgsRepositoryProvider);
      await expectLater(
        repo.create(name: 'A', slug: 'acme'),
        throwsA(isA<ApiError>()
            .having((e) => e.status, 'status', 400)
            .having((e) => e.fieldErrors['name'], 'name', 'Organization name is too short.')
            .having((e) => e.fieldErrors['slug'], 'slug', 'That address is already taken.')),
      );
      await expectLater(
        repo.create(name: 'Fine', slug: 'signup'),
        throwsA(isA<ApiError>()
            .having((e) => e.fieldErrors['slug'], 'slug', "That address isn't available.")),
      );
    });

    test('makes the caller ADMIN of a new ACTIVE org on the FREE plan', () async {
      final world = TestWorld();
      final c = await signedIn(world);
      final org = await c.read(orgsRepositoryProvider).create(name: ' Green Club ', slug: 'green-club');
      expect(org.name, 'Green Club');
      expect(org.slug, 'green-club');
      expect(org.role, Role.admin);
      expect(org.plan, PlanTier.free);
      expect(world.store.tenantBySlug('green-club')?.status, TenantStatus.active);
      final orgs = await c.read(orgsRepositoryProvider).list();
      expect(orgs.map((o) => o.slug), ['green-club']);
    });
  });

  group('CreateOrg controller', () {
    test('flips organizer access, selects the org, switches mode, clears the intent', () async {
      final world = TestWorld();
      final c = await signedIn(world);
      c.read(organizeIntentProvider.notifier).set(true);
      expect(c.read(authControllerProvider).hasOrganizerAccess, isFalse);
      expect(c.read(appModeControllerProvider), AppMode.attendee);

      final org = await c.read(createOrgProvider.notifier).submit(name: 'Green Club', slug: 'green-club');

      final auth = c.read(authControllerProvider);
      expect(auth.hasOrganizerAccess, isTrue);
      expect(auth.orgs.single.slug, org.slug);
      expect(c.read(selectedOrgProvider)?.slug, 'green-club');
      expect(c.read(appModeControllerProvider), AppMode.organizer);
      expect(c.read(organizeIntentProvider), isFalse);
      expect(await world.prefs.getString(Prefs.keyOrganizeIntent), isNull);
    });

    test('a rejected create leaves everything as it was', () async {
      final c = await signedIn(TestWorld());
      await expectLater(
        c.read(createOrgProvider.notifier).submit(name: 'X', slug: 'acme'),
        throwsA(isA<ApiError>()),
      );
      expect(c.read(authControllerProvider).hasOrganizerAccess, isFalse);
      expect(c.read(appModeControllerProvider), AppMode.attendee);
    });
  });

  group('OrganizeIntent', () {
    test('persists', () async {
      final world = TestWorld();
      final c = world.container();
      c.read(organizeIntentProvider.notifier).set(true);
      expect(await world.prefs.getString(Prefs.keyOrganizeIntent), 'true');
      c.read(organizeIntentProvider.notifier).set(false);
      expect(await world.prefs.getString(Prefs.keyOrganizeIntent), isNull);
    });
  });

  group('routing', () {
    test('/organize needs a session and is not an organizer path', () {
      expect(requiresSession(Routes.organize), isTrue);
      expect(isOrganizerPath(Routes.organize), isFalse);
      final target = computeRedirect(
        uri: Uri.parse(Routes.organize),
        auth: const AuthState.signedOut(),
        mode: AppMode.attendee,
      );
      expect(target, loginFor(Uri.parse(Routes.organize)));
    });

    test('a signed-in person with the intent leaves the auth stack for /organize', () {
      String? go(String path, {bool intent = false, List<Org> orgs = const []}) => computeRedirect(
            uri: Uri.parse(path),
            auth: AuthState.signedIn(
              user: const User(id: 'u', email: 'x@example.com'),
              token: 't',
              expiresAt: DateTime.utc(2030),
              orgs: orgs,
            ),
            mode: AppMode.attendee,
            organizeIntent: intent,
          );
      expect(go(Routes.checkEmail, intent: true), Routes.organize);
      expect(go(Routes.checkEmail), AppMode.attendee.home);
      // Already an organizer: the intent is moot.
      const org = Org(slug: 'acme', name: 'Acme', role: Role.admin);
      expect(go(Routes.checkEmail, intent: true, orgs: [org]), isNot(Routes.organize));
      // Token screens finish their own work first.
      expect(go(Routes.verify, intent: true), isNull);
    });

    test('after sign-in, an attendee returns to /organize; an organizer goes home', () {
      expect(afterSignInTarget(from: Routes.organize, mode: AppMode.attendee), Routes.organize);
      expect(afterSignInTarget(from: Routes.organize, mode: AppMode.organizer), AppMode.organizer.home);
    });
  });
}
