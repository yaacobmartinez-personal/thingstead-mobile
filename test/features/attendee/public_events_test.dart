import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/features/attendee/attendee_providers.dart';
import 'package:thingstead/features/attendee/orgs/application/public_events_controller.dart';

import '../../helpers/fakes.dart';

void main() {
  test('getOrg resolves ACTIVE orgs only', () async {
    final world = TestWorld();
    final c = world.container();
    final repo = c.read(publicEventsRepositoryProvider);
    expect((await repo.getOrg('acme')).name, 'Acme Meetups');
    expect((await repo.getOrg('  ACME ')).slug, 'acme', reason: 'codes are normalized');

    await expectLater(
      repo.getOrg('nope'),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 404)),
    );
    world.store.tenantBySlug('beta')!.status = TenantStatus.pending;
    await expectLater(
      repo.getOrg('beta'),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 404)),
    );
  });

  test('listEvents shows PUBLISHED events soonest first, with availability', () async {
    final c = TestWorld().container();
    c.listen(publicEventsProvider('acme'), (_, _) {});
    final page = await c.read(publicEventsProvider('acme').future);
    expect(page.org.name, 'Acme Meetups');
    // Draft (founders-dinner) and closed (spring-kickoff) are invisible.
    expect(page.events.map((e) => e.slug), ['design-workshop', 'summer-meetup']);

    final workshop = page.events[0];
    expect(workshop.capacity, 20);
    expect(workshop.remaining, 1);
    expect(workshop.isFull, isFalse);
    expect(workshop.placesLabel, '1 of 20 place left');
    expect(workshop.description, isNull, reason: 'list omits descriptions');

    final summer = page.events[1];
    expect(summer.remaining, 0);
    expect(summer.isFull, isTrue);
    expect(summer.waitlistEnabled, isTrue);
    expect(summer.placesLabel, 'Full');
    expect(summer.canRegister, isTrue, reason: 'waitlist is open');
  });

  test('uncapped events have no places label', () async {
    final c = TestWorld().container();
    c.listen(publicEventsProvider('beta'), (_, _) {});
    final page = await c.read(publicEventsProvider('beta').future);
    final hack = page.events.single;
    expect(hack.capacity, isNull);
    expect(hack.remaining, isNull);
    expect(hack.placesLabel, isNull);
    expect(hack.canRegister, isTrue);
  });

  test('getEvent returns the description and 404s for drafts and closed events', () async {
    final c = TestWorld().container();
    final repo = c.read(publicEventsRepositoryProvider);
    final page = await repo.getEvent('acme', 'summer-meetup');
    expect(page.event.description, contains('open mic'));
    expect(page.org.slug, 'acme');

    for (final slug in ['founders-dinner', 'spring-kickoff', 'missing']) {
      await expectLater(
        repo.getEvent('acme', slug),
        throwsA(isA<ApiError>().having((e) => e.status, 'status', 404)),
        reason: slug,
      );
    }
  });

  test('a full event without a waitlist cannot be registered for', () async {
    final world = TestWorld();
    final c = world.container();
    final acme = world.store.tenantBySlug('acme')!;
    world.store.eventBySlug(acme.id, 'design-workshop')!.capacity = 19;
    final page = await c.read(publicEventsRepositoryProvider).getEvent('acme', 'design-workshop');
    expect(page.event.isFull, isTrue);
    expect(page.event.canRegister, isFalse);
  });
}
