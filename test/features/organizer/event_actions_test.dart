import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/events/application/event_detail_controller.dart';
import 'package:thingstead/features/organizer/events/application/events_controller.dart';
import 'package:thingstead/features/organizer/events/domain/event_input.dart';

import '../../helpers/fakes.dart';

void main() {
  Future<ProviderContainer> signedIn(TestWorld world, {String email = FakeAccounts.organizerEmail}) async {
    final c = world.container();
    await c.read(authControllerProvider.notifier).signInWithPassword(email, FakeAccounts.password);
    return c;
  }

  EventInput input({
    String title = 'Autumn Social',
    String? slug,
    int? capacity,
    String startsAt = '2026-11-05T19:00',
    String? endsAt,
  }) =>
      EventInput(
        title: title,
        slug: slug,
        startsAt: startsAt,
        endsAt: endsAt,
        timezone: 'Asia/Manila',
        capacity: capacity,
      );

  test('detail carries wall-clock times and live counts', () async {
    final c = await signedIn(TestWorld());
    final e = await c.read(eventDetailProvider('acme', 'summer-meetup').future);
    expect(e.startsAtLocal, '2026-09-25T18:00'); // 10:00Z in Manila
    expect(e.endsAtLocal, '2026-09-25T21:00');
    expect(e.confirmed, 40);
    expect(e.waitlist, 4);
    expect(e.isFull, isTrue);
    expect(e.headcount, '40 / 40');
    expect(e.registrations, 44);
  });

  test('create makes a draft with a unique slug and refreshes the list', () async {
    final c = await signedIn(TestWorld());
    c.listen(orgEventsProvider('acme'), (_, _) {});
    final before = (await c.read(orgEventsProvider('acme').future)).events.length;

    final actions = c.read(eventActionsProvider.notifier);
    final created = await actions.create('acme', input());
    expect(created.status, EventStatus.draft);
    expect(created.slug, 'autumn-social');
    expect(created.startsAt, DateTime.utc(2026, 11, 5, 11));

    // Same title again → the slug gets a suffix rather than clashing.
    final again = await actions.create('acme', input());
    expect(again.slug, 'autumn-social-2');

    // A slug already used by another org is fine — uniqueness is per org.
    final other = await actions.create('beta', input(slug: 'summer-meetup'));
    expect(other.slug, 'summer-meetup');

    final after = (await c.read(orgEventsProvider('acme').future)).events.length;
    expect(after, before + 2);
  });

  test('create rejects invalid input with field errors, server-style', () async {
    final c = await signedIn(TestWorld());
    final actions = c.read(eventActionsProvider.notifier);
    try {
      await actions.create('acme', input(title: '', startsAt: ''));
      fail('expected ApiError');
    } on ApiError catch (e) {
      expect(e.status, 400);
      expect(e.fieldErrors['title'], 'Give the event a title.');
      expect(e.fieldErrors['startsAt'], 'Pick a start date and time.');
    }
  });

  test('update refuses a capacity below the confirmed count', () async {
    final c = await signedIn(TestWorld());
    final actions = c.read(eventActionsProvider.notifier);
    try {
      await actions.update('acme', 'summer-meetup', input(title: 'Summer Meetup', capacity: 39));
      fail('expected ApiError');
    } on ApiError catch (e) {
      expect(e.status, 400);
      expect(e.fieldErrors['capacity'],
          "40 people already have a place, so capacity can't be lower than that.");
    }
  });

  test('raising capacity promotes the longest-waiting people', () async {
    final c = await signedIn(TestWorld());
    final actions = c.read(eventActionsProvider.notifier);
    final updated = await actions.update(
      'acme',
      'summer-meetup',
      input(title: 'Summer Meetup', slug: 'summer-meetup', capacity: 42),
    );
    expect(updated.confirmed, 42);
    expect(updated.waitlist, 2);
    expect(updated.capacity, 42);
    // Detail was invalidated and re-reads the new numbers.
    final fresh = await c.read(eventDetailProvider('acme', 'summer-meetup').future);
    expect(fresh.confirmed, 42);
  });

  test('update can change the slug; the old address is gone', () async {
    final c = await signedIn(TestWorld());
    final actions = c.read(eventActionsProvider.notifier);
    final updated = await actions.update(
      'acme',
      'founders-dinner',
      input(title: 'Founders Dinner', slug: 'dinner', capacity: 12),
    );
    expect(updated.slug, 'dinner');
    c.listen(eventDetailProvider('acme', 'founders-dinner'), (_, _) {});
    await expectLater(
      c.read(eventDetailProvider('acme', 'founders-dinner').future),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 404)),
    );
  });

  test('setStatus flips publish/close and the list reflects it', () async {
    final c = await signedIn(TestWorld());
    c.listen(orgEventsProvider('acme'), (_, _) {});
    final actions = c.read(eventActionsProvider.notifier);
    expect(await actions.setStatus('acme', 'founders-dinner', EventStatus.published),
        EventStatus.published);
    var page = await c.read(orgEventsProvider('acme').future);
    expect(page.events.firstWhere((e) => e.slug == 'founders-dinner').status,
        EventStatus.published);
    await actions.setStatus('acme', 'founders-dinner', EventStatus.closed);
    page = await c.read(orgEventsProvider('acme').future);
    expect(page.events.firstWhere((e) => e.slug == 'founders-dinner').status,
        EventStatus.closed);
  });

  test('delete is ADMIN-only and cascades registrations', () async {
    final world = TestWorld();
    final c = await signedIn(world);
    final actions = c.read(eventActionsProvider.notifier);

    // demo is STAFF at Beta → 403.
    await expectLater(
      actions.delete('beta', 'community-hackathon'),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 403)),
    );
    expect(world.store.eventBySlug(world.store.tenantBySlug('beta')!.id, 'community-hackathon'),
        isNotNull);

    // demo is ADMIN at Acme → the event and its 45 rows (incl. cancelled) go.
    final gone = await actions.delete('acme', 'summer-meetup');
    expect(gone, 45);
    final acme = world.store.tenantBySlug('acme')!;
    expect(world.store.eventBySlug(acme.id, 'summer-meetup'), isNull);
    expect(world.store.registrations.where((r) => r.tenantId == acme.id).length, 19 + 52);
  });

  test('every mutation needs membership', () async {
    final c = await signedIn(TestWorld(), email: FakeAccounts.attendeeEmail);
    final actions = c.read(eventActionsProvider.notifier);
    await expectLater(
      actions.create('acme', input()),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 403)),
    );
  });
}
