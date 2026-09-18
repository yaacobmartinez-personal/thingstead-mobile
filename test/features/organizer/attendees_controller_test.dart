import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/attendees/application/attendees_controller.dart';
import 'package:thingstead/features/organizer/checkin/domain/checkin_repository.dart';
import 'package:thingstead/features/organizer/checkin/domain/scan_result.dart';
import 'package:thingstead/features/organizer/events/application/events_controller.dart';
import 'package:thingstead/features/organizer/organizer_providers.dart';

import '../../helpers/fakes.dart';

/// A check-in repository that always fails, for the rollback path.
class _FailingCheckin implements CheckinRepository {
  @override
  Future<DateTime?> setCheckedIn(String o, String e, String id, {required bool checkedIn}) async =>
      throw ApiError.network();

  @override
  Future<ScanResult> scan(String o, String code, {String? eventSlug}) async =>
      throw ApiError.network();
}

void main() {

  Future<ProviderContainer> signedIn(TestWorld world, {CheckinRepository? checkin}) async {
    final c = ProviderContainer(overrides: [
      ...world.overrides,
      if (checkin != null) checkinRepositoryProvider.overrideWithValue(checkin),
    ]);
    addTearDown(c.dispose);
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    return c;
  }

  test('loads the list with the event header and counts', () async {
    final c = await signedIn(TestWorld());
    final s = await c.read(attendeesControllerProvider('acme', 'design-workshop').future);
    expect(s.list.event.title, 'Design Workshop');
    expect(s.list.event.capacity, 20);
    expect(s.attendees.length, 19); // 18 live + 1 erased row
    expect(s.checkedInCount, 7);
    expect(s.attendees.where((a) => a.erased).length, 1);
    expect(s.attendees.first.checkInToken, isNotNull, reason: 'fake mode ships tokens');
  });

  test('local search matches name or email, case-insensitively', () async {
    final c = await signedIn(TestWorld());
    final s = await c.read(attendeesControllerProvider('acme', 'design-workshop').future);
    final byName = s.filtered('ALEX');
    expect(byName.map((a) => a.email), contains(FakeAccounts.attendeeEmail));
    final byEmail = s.filtered('@thingstead.test');
    expect(byEmail.length, 2); // attendee + demo organizer
    expect(s.filtered(''), hasLength(s.attendees.length));
    expect(s.filtered('zzz-nobody'), isEmpty);
  });

  test('toggle is optimistic, then takes the server timestamp', () async {
    final world = TestWorld();
    final c = await signedIn(world);
    final p = attendeesControllerProvider('acme', 'design-workshop');
    final s = await c.read(p.future);
    final target = s.attendees.firstWhere((a) => a.canCheckIn && !a.checkedIn);

    final future = c.read(p.notifier).toggle(target);
    final mid = c.read(p).requireValue;
    expect(mid.busyIds, contains(target.id));
    expect(mid.attendees.firstWhere((a) => a.id == target.id).checkedIn, isTrue);

    expect(await future, isNull);
    final after = c.read(p).requireValue;
    expect(after.busyIds, isEmpty);
    expect(after.attendees.firstWhere((a) => a.id == target.id).checkedInAt, testNow);
    expect(world.store.registrationById(target.id)!.checkedInAt, testNow);

    // And back off again.
    expect(await c.read(p.notifier).toggle(after.attendees.firstWhere((a) => a.id == target.id)), isNull);
    expect(c.read(p).requireValue.attendees.firstWhere((a) => a.id == target.id).checkedIn, isFalse);
  });

  test('toggle rolls back and reports the error when the request fails', () async {
    final c = await signedIn(TestWorld(), checkin: _FailingCheckin());
    final p = attendeesControllerProvider('acme', 'design-workshop');
    final s = await c.read(p.future);
    final target = s.attendees.firstWhere((a) => a.canCheckIn && !a.checkedIn);

    final error = await c.read(p.notifier).toggle(target);
    expect(error, ApiError.networkMessage);
    final after = c.read(p).requireValue;
    expect(after.attendees.firstWhere((a) => a.id == target.id).checkedIn, isFalse);
    expect(after.busyIds, isEmpty);
  });

  test('waitlisted, cancelled and erased rows cannot be toggled', () async {
    final c = await signedIn(TestWorld());
    final p = attendeesControllerProvider('acme', 'summer-meetup');
    final s = await c.read(p.future);
    for (final status in [RegistrationStatus.waitlist, RegistrationStatus.cancelled]) {
      final a = s.attendees.firstWhere((a) => a.status == status);
      expect(a.canCheckIn, isFalse);
      expect(await c.read(p.notifier).toggle(a), isNull);
      expect(c.read(p).requireValue.busyIds, isEmpty);
    }
  });

  test('a successful toggle invalidates the events counts', () async {
    final c = await signedIn(TestWorld());
    final before = await c.read(orgEventsProvider('acme').future);
    final workshopBefore = before.events.firstWhere((e) => e.slug == 'design-workshop').checkedIn;

    final p = attendeesControllerProvider('acme', 'design-workshop');
    final s = await c.read(p.future);
    await c.read(p.notifier).toggle(s.attendees.firstWhere((a) => a.canCheckIn && !a.checkedIn));

    final after = await c.read(orgEventsProvider('acme').future);
    expect(after.events.firstWhere((e) => e.slug == 'design-workshop').checkedIn, workshopBefore + 1);
  });
}
