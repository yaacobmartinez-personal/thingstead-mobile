import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/fake_store.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/features/attendee/orgs/application/public_events_controller.dart';
import 'package:thingstead/features/attendee/registration/application/register_controller.dart';
import 'package:thingstead/features/attendee/registration/domain/register_result.dart';
import 'package:thingstead/features/attendee/tickets/application/tickets_controller.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';

import '../../helpers/fakes.dart';

void main() {
  Future<ProviderContainer> signedIn(TestWorld world, String email) async {
    final c = world.container();
    await c.read(authControllerProvider.notifier).signInWithPassword(email, FakeAccounts.password);
    return c;
  }

  test('confirmed: takes the last place and the public count follows', () async {
    final world = TestWorld();
    final c = await signedIn(world, 'door@acme.test');
    c.listen(publicEventProvider('acme', 'design-workshop'), (_, _) {});
    var page = await c.read(publicEventProvider('acme', 'design-workshop').future);
    expect(page.event.remaining, 1);

    final result = await c
        .read(registerControllerProvider.notifier)
        .register('acme', 'design-workshop', name: '  Door Staff ');
    expect(result.outcome, RegisterOutcome.confirmed);
    expect(result.gotAPlace, isTrue);
    final ticket = result.ticket!;
    expect(ticket.status, RegistrationStatus.confirmed);
    expect(ticket.name, 'Door Staff');
    expect(ticket.email, 'door@acme.test');
    expect(ticket.hasQr, isTrue);
    expect(ticket.qrPayload, startsWith('https://app.thingstead.pro/checkin?c=chk_'));
    expect(ticket.event.title, 'Design Workshop');
    expect(ticket.org.name, 'Acme Meetups');
    expect(ticket.started, isFalse);

    page = await c.read(publicEventProvider('acme', 'design-workshop').future);
    expect(page.event.remaining, 0);
    expect(page.event.isFull, isTrue);

    // The confirmation email went out and the row belongs to the account.
    expect(world.store.outbox.last.kind, FakeEmailKind.registration);
    expect(world.store.outbox.last.to, 'door@acme.test');
    expect(world.store.registrationById(ticket.id)!.userId,
        world.store.userByEmail('door@acme.test')!.id);
  });

  test('waitlisted: a full event with a waitlist queues the person', () async {
    final c = await signedIn(TestWorld(), 'door@acme.test');
    final result = await c
        .read(registerControllerProvider.notifier)
        .register('acme', 'summer-meetup', name: 'Door Staff');
    expect(result.outcome, RegisterOutcome.waitlisted);
    expect(result.ticket!.status, RegistrationStatus.waitlist);
    expect(result.ticket!.hasQr, isFalse, reason: 'nothing to check in for yet');
  });

  test('full: no waitlist means no registration and no ticket', () async {
    final world = TestWorld();
    final acme = world.store.tenantBySlug('acme')!;
    world.store.eventBySlug(acme.id, 'design-workshop')!.capacity = 19;
    final c = await signedIn(world, 'door@acme.test');
    final before = world.store.registrations.length;
    final result = await c
        .read(registerControllerProvider.notifier)
        .register('acme', 'design-workshop', name: 'Door Staff');
    expect(result.outcome, RegisterOutcome.full);
    expect(result.ticket, isNull);
    expect(world.store.registrations.length, before);
  });

  test('duplicate: an existing live registration is returned, not doubled', () async {
    final world = TestWorld();
    final c = await signedIn(world, FakeAccounts.attendeeEmail);
    final before = world.store.registrations.length;
    final result = await c
        .read(registerControllerProvider.notifier)
        .register('acme', 'summer-meetup', name: 'Alex Attendee');
    expect(result.outcome, RegisterOutcome.duplicate);
    expect(result.ticket, isNotNull);
    expect(result.ticket!.status, RegistrationStatus.confirmed);
    expect(world.store.registrations.length, before);
  });

  test('closed: drafts, closed events, unknown events and orgs', () async {
    final c = await signedIn(TestWorld(), 'door@acme.test');
    final controller = c.read(registerControllerProvider.notifier);
    for (final (org, event) in [
      ('acme', 'founders-dinner'),
      ('acme', 'spring-kickoff'),
      ('acme', 'missing'),
      ('nope', 'summer-meetup'),
    ]) {
      final result = await controller.register(org, event, name: 'Door Staff');
      expect(result.outcome, RegisterOutcome.closed, reason: '$org/$event');
      expect(result.ticket, isNull);
    }
  });

  test('re-registering after a cancellation reuses the row at the back of the queue', () async {
    final world = TestWorld();
    final c = await signedIn(world, FakeAccounts.attendeeEmail);
    c.listen(ticketsControllerProvider, (_, _) {});
    final tickets = await c.read(ticketsControllerProvider.future);
    final hack = tickets.all.firstWhere((t) => t.event.slug == 'community-hackathon');
    final oldToken = hack.checkInToken;
    expect(await c.read(ticketActionsProvider.notifier).cancel(hack.id), isNotNull);

    final result = await c
        .read(registerControllerProvider.notifier)
        .register('beta', 'community-hackathon', name: 'Alex Attendee');
    expect(result.outcome, RegisterOutcome.confirmed);
    expect(result.ticket!.id, hack.id, reason: 'same row');
    expect(result.ticket!.checkInToken, isNot(oldToken), reason: 'fresh ticket');
    expect(result.ticket!.createdAt, world.now, reason: 'back of the queue');
  });

  test('a blank name is a field error', () async {
    final c = await signedIn(TestWorld(), 'door@acme.test');
    try {
      await c.read(registerControllerProvider.notifier).register('acme', 'summer-meetup', name: '  ');
      fail('expected ApiError');
    } on ApiError catch (e) {
      expect(e.status, 400);
      expect(e.fieldErrors['name'], 'Tell us your name.');
    }
  });

  test('registering needs a session', () async {
    final c = TestWorld().container();
    await expectLater(
      c.read(registerControllerProvider.notifier).register('acme', 'summer-meetup', name: 'X'),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 401)),
    );
  });

  test('outcome copy matches the web form', () {
    expect(RegisterCopy.title(RegisterOutcome.waitlisted), "You're on the waitlist");
    expect(RegisterCopy.body(RegisterOutcome.duplicate),
        'That email address is already registered for this event.');
    expect(RegisterCopy.body(RegisterOutcome.closed),
        "This event isn't accepting sign-ups right now.");
  });
}
