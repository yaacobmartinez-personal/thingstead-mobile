import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/fake_store.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/team/application/team_controller.dart';

import '../../helpers/fakes.dart';

void main() {
  Future<ProviderContainer> signedIn(TestWorld world, {String email = FakeAccounts.organizerEmail}) async {
    final c = world.container();
    await c.read(authControllerProvider.notifier).signInWithPassword(email, FakeAccounts.password);
    return c;
  }

  test('loads members, invitations, and the admin count', () async {
    final c = await signedIn(TestWorld());
    final page = await c.read(teamControllerProvider('acme').future);
    expect(page.members.map((m) => m.email), [
      FakeAccounts.organizerEmail,
      'maria@acme.test',
      'door@acme.test',
    ]);
    expect(page.members.first.isSelf, isTrue);
    expect(page.members.first.isAdmin, isTrue);
    expect(page.adminCount, 2);
    expect(page.invitations.map((i) => i.email), ['expired@acme.test', 'newhire@acme.test']);
    expect(page.invitations.first.expired, isTrue);
    expect(page.invitations.last.expired, isFalse);
  });

  test('is ADMIN-only', () async {
    final c = await signedIn(TestWorld());
    // demo is STAFF at Beta.
    c.listen(teamControllerProvider('beta'), (_, _) {});
    await expectLater(
      c.read(teamControllerProvider('beta').future),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 403)),
    );
  });

  test('invite creates a pending invitation and emails it', () async {
    final world = TestWorld();
    final c = await signedIn(world);
    final provider = teamControllerProvider('acme');
    c.listen(provider, (_, _) {});
    await c.read(provider.future);

    final result = await c
        .read(provider.notifier)
        .invite(email: '  New.Person@Example.com ', role: Role.admin);
    expect(result.alreadyMember, isFalse);
    expect(result.invitation!.email, 'new.person@example.com');
    expect(result.invitation!.role, Role.admin);
    expect(result.invitation!.expiresAt, world.now.add(const Duration(days: 7)));
    expect(result.invitation!.expired, isFalse);

    final page = c.read(provider).requireValue;
    expect(page.invitations.map((i) => i.email), contains('new.person@example.com'));
    expect(world.store.outbox.last.kind, FakeEmailKind.invite);
    expect(world.store.outbox.last.to, 'new.person@example.com');
  });

  test('re-inviting replaces the pending invitation for that address', () async {
    final world = TestWorld();
    final c = await signedIn(world);
    final provider = teamControllerProvider('acme');
    c.listen(provider, (_, _) {});
    await c.read(provider.future);

    await c.read(provider.notifier).invite(email: 'newhire@acme.test', role: Role.admin);
    final page = c.read(provider).requireValue;
    final matching = page.invitations.where((i) => i.email == 'newhire@acme.test').toList();
    expect(matching, hasLength(1));
    expect(matching.single.role, Role.admin);
    expect(matching.single.expired, isFalse);
  });

  test('inviting an existing member reports alreadyMember', () async {
    final c = await signedIn(TestWorld());
    final provider = teamControllerProvider('acme');
    c.listen(provider, (_, _) {});
    await c.read(provider.future);
    final result = await c.read(provider.notifier).invite(email: 'door@acme.test', role: Role.staff);
    expect(result.alreadyMember, isTrue);
    expect(result.invitation, isNull);
  });

  test('invite validates the address as a field error', () async {
    final c = await signedIn(TestWorld());
    final provider = teamControllerProvider('acme');
    c.listen(provider, (_, _) {});
    await c.read(provider.future);
    try {
      await c.read(provider.notifier).invite(email: 'not-an-email', role: Role.staff);
      fail('expected ApiError');
    } on ApiError catch (e) {
      expect(e.status, 400);
      expect(e.fieldErrors['email'], 'Enter a valid email address.');
    }
  });

  test('revoke removes the invitation; a second revoke is 404', () async {
    final c = await signedIn(TestWorld());
    final provider = teamControllerProvider('acme');
    c.listen(provider, (_, _) {});
    final page = await c.read(provider.future);
    final id = page.invitations.first.id;

    await c.read(provider.notifier).revoke(id);
    expect(c.read(provider).requireValue.invitations.map((i) => i.id), isNot(contains(id)));
    await expectLater(
      c.read(provider.notifier).revoke(id),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 404)),
    );
  });

  test('changeRole promotes and demotes; the last admin cannot be demoted', () async {
    final c = await signedIn(TestWorld());
    final provider = teamControllerProvider('acme');
    c.listen(provider, (_, _) {});
    var page = await c.read(provider.future);
    final maria = page.members.firstWhere((m) => m.email == 'maria@acme.test');
    final door = page.members.firstWhere((m) => m.email == 'door@acme.test');
    final me = page.members.firstWhere((m) => m.isSelf);

    await c.read(provider.notifier).changeRole(door.id, Role.admin);
    page = c.read(provider).requireValue;
    expect(page.adminCount, 3);
    expect(page.canReduceAdmin(me), isTrue);

    await c.read(provider.notifier).changeRole(door.id, Role.staff);
    await c.read(provider.notifier).changeRole(maria.id, Role.staff);
    page = c.read(provider).requireValue;
    expect(page.adminCount, 1);
    expect(page.canReduceAdmin(me), isFalse);
    expect(page.canReduceAdmin(page.members.firstWhere((m) => m.id == maria.id)), isTrue,
        reason: 'staff can always be changed');

    await expectLater(
      c.read(provider.notifier).changeRole(me.id, Role.staff),
      throwsA(isA<ApiError>()
          .having((e) => e.status, 'status', 409)
          .having((e) => e.reason, 'reason', 'last_admin')),
    );
  });

  test('remove takes a member out; the last admin cannot be removed', () async {
    final world = TestWorld();
    final c = await signedIn(world);
    final provider = teamControllerProvider('acme');
    c.listen(provider, (_, _) {});
    var page = await c.read(provider.future);
    final maria = page.members.firstWhere((m) => m.email == 'maria@acme.test');
    final me = page.members.firstWhere((m) => m.isSelf);

    await c.read(provider.notifier).remove(maria.id);
    page = c.read(provider).requireValue;
    expect(page.members.map((m) => m.email), isNot(contains('maria@acme.test')));
    expect(page.adminCount, 1);

    await expectLater(
      c.read(provider.notifier).remove(me.id, self: true),
      throwsA(isA<ApiError>().having((e) => e.reason, 'reason', 'last_admin')),
    );
    expect(world.store.membership(world.store.userByEmail(FakeAccounts.organizerEmail)!.id,
        world.store.tenantBySlug('acme')!.id), isNotNull);
  });

  test('leaving refreshes the membership list so the org disappears', () async {
    final c = await signedIn(TestWorld());
    final provider = teamControllerProvider('acme');
    c.listen(provider, (_, _) {});
    final page = await c.read(provider.future);
    final me = page.members.firstWhere((m) => m.isSelf);
    expect(c.read(authControllerProvider).orgs.map((o) => o.slug), ['acme', 'beta']);

    // Two admins, so leaving is allowed.
    await c.read(provider.notifier).remove(me.id, self: true);
    expect(c.read(authControllerProvider).orgs.map((o) => o.slug), ['beta']);
  });
}
