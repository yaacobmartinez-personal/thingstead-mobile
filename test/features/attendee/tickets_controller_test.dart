import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/features/attendee/tickets/application/tickets_controller.dart';
import 'package:thingstead/features/attendee/tickets/domain/ticket.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';

import '../../helpers/fakes.dart';

void main() {
  Future<ProviderContainer> signedIn(TestWorld world, [String email = FakeAccounts.attendeeEmail]) async {
    final c = world.container();
    c.listen(ticketsControllerProvider, (_, _) {});
    await c.read(authControllerProvider.notifier).signInWithPassword(email, FakeAccounts.password);
    return c;
  }

  test('lists my tickets newest first and splits upcoming from past', () async {
    final c = await signedIn(TestWorld());
    final state = await c.read(ticketsControllerProvider.future);
    expect(state.all, hasLength(4));
    for (var i = 1; i < state.all.length; i++) {
      expect(state.all[i - 1].createdAt.isAfter(state.all[i].createdAt), isTrue,
          reason: 'newest first');
    }
    expect(state.upcoming.map((t) => t.event.slug),
        ['design-workshop', 'summer-meetup', 'community-hackathon']);
    expect(state.past.map((t) => t.event.slug), ['spring-kickoff']);

    final kickoff = state.past.single;
    expect(kickoff.started, isTrue);
    expect(kickoff.checkedIn, isTrue);
    expect(kickoff.canCancel, isFalse);
    expect(kickoff.statusLabel, 'Registered');

    final summer = state.all.last;
    expect(summer.hasQr, isTrue);
    expect(summer.qrPayload, 'https://app.thingstead.pro/checkin?c=${summer.checkInToken}');
  });

  test('the list is per account', () async {
    final world = TestWorld();
    final c = await signedIn(world, 'door@acme.test');
    expect((await c.read(ticketsControllerProvider.future)).all, isEmpty);
  });

  test('get 404s for tickets that are not mine', () async {
    final world = TestWorld();
    final c = await signedIn(world, 'door@acme.test');
    final someoneElses = world.store.registrations.first.id;
    c.listen(ticketProvider(someoneElses), (_, _) {});
    await expectLater(
      c.read(ticketProvider(someoneElses).future),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 404)),
    );
  });

  test('import attaches a web registration when the email matches', () async {
    final world = TestWorld();
    // A registration made on the web with door@'s email and no account.
    final acme = world.store.tenantBySlug('acme')!;
    final summer = world.store.eventBySlug(acme.id, 'summer-meetup')!;
    final row = world.store.registrationsOf(summer.id).firstWhere((r) => r.userId == null);
    row.email = 'door@acme.test';
    final c = await signedIn(world, 'door@acme.test');

    final ticket = await c.read(ticketActionsProvider.notifier).import(row.manageToken!);
    expect(ticket.id, row.id);
    expect(row.userId, world.store.userByEmail('door@acme.test')!.id);
    final state = await c.read(ticketsControllerProvider.future);
    expect(state.all.map((t) => t.id), [row.id]);
  });

  test('import refuses another person\'s link and unknown tokens', () async {
    final world = TestWorld();
    final c = await signedIn(world, 'door@acme.test');
    final theirs = world.store.registrations.firstWhere((r) => !r.erased && r.userId == null);
    await expectLater(
      c.read(ticketActionsProvider.notifier).import(theirs.manageToken!),
      throwsA(isA<ApiError>()
          .having((e) => e.status, 'status', 403)
          .having((e) => e.reason, 'reason', 'email_mismatch')),
    );
    expect(theirs.userId, isNull, reason: 'nothing attached');
    await expectLater(
      c.read(ticketActionsProvider.notifier).import('manage_nope'),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 404)),
    );
  });

  test('cancel gives up the place; again is "already"; started events refuse', () async {
    final world = TestWorld();
    final c = await signedIn(world);
    final state = await c.read(ticketsControllerProvider.future);
    final summer = state.all.firstWhere((t) => t.event.slug == 'summer-meetup');
    final kickoff = state.all.firstWhere((t) => t.event.slug == 'spring-kickoff');
    final actions = c.read(ticketActionsProvider.notifier);

    expect(await actions.cancel(summer.id), CancelOutcome.cancelled);
    expect(world.store.registrationById(summer.id)!.status, RegistrationStatus.cancelled);
    expect(await actions.cancel(summer.id), CancelOutcome.already);
    expect(await actions.cancel(kickoff.id), CancelOutcome.started);
    expect(world.store.registrationById(kickoff.id)!.status, RegistrationStatus.confirmed);

    // No promotion from the waitlist — that is the organizer's decision.
    final acme = world.store.tenantBySlug('acme')!;
    final ev = world.store.eventBySlug(acme.id, 'summer-meetup')!;
    expect(world.store.waitlistCount(ev.id), 4);
    expect(world.store.confirmedCount(ev.id), 39);

    final after = await c.read(ticketsControllerProvider.future);
    expect(after.all.firstWhere((t) => t.id == summer.id).isCancelled, isTrue);
    expect(after.all.firstWhere((t) => t.id == summer.id).hasQr, isFalse);
  });

  test('cancel 404s for tickets that are not mine', () async {
    final world = TestWorld();
    final c = await signedIn(world, 'door@acme.test');
    await expectLater(
      c.read(ticketActionsProvider.notifier).cancel(world.store.registrations.first.id),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 404)),
    );
  });

  test('signing out and in as someone else rebuilds the list', () async {
    final world = TestWorld();
    final c = await signedIn(world);
    expect((await c.read(ticketsControllerProvider.future)).all, hasLength(4));
    await c.read(authControllerProvider.notifier).signOut();
    await c.read(authControllerProvider.notifier).signInWithPassword('door@acme.test', FakeAccounts.password);
    expect((await c.read(ticketsControllerProvider.future)).all, isEmpty);
  });
}
