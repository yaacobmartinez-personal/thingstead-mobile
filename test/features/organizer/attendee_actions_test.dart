import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/core/network/retry_policy.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/attendees/application/attendee_actions.dart';
import 'package:thingstead/features/organizer/attendees/application/attendees_controller.dart';
import 'package:thingstead/features/organizer/attendees/application/csv_sharer.dart';
import 'package:thingstead/features/organizer/events/application/event_detail_controller.dart';
import 'package:thingstead/features/organizer/events/domain/event_detail.dart';

import '../../helpers/fakes.dart';

/// Captures what would have gone to the share sheet.
class _RecordingSharer implements CsvSharer {
  final shared = <(String, String)>[];

  @override
  Future<void> share(List<int> bytes, String filename) async {
    shared.add((utf8.decode(bytes), filename));
  }
}

Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 30));

void main() {
  late _RecordingSharer sharer;

  Future<ProviderContainer> signedIn(TestWorld world) async {
    sharer = _RecordingSharer();
    final c = ProviderContainer(retry: appRetryPolicy, overrides: [
      ...world.overrides,
      csvSharerProvider.overrideWithValue(sharer),
    ]);
    addTearDown(c.dispose);
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    return c;
  }

  test('promote on a full event reports full and changes nothing', () async {
    final world = TestWorld();
    final c = await signedIn(world);
    final actions = c.read(attendeeActionsProvider.notifier);
    final list = await c.read(attendeesControllerProvider('acme', 'summer-meetup').future);
    final waiting = list.attendees.firstWhere((a) => a.status == RegistrationStatus.waitlist);

    expect(await actions.promote('acme', 'summer-meetup', waiting.id), PromoteOutcome.full);
    expect(world.store.registrationById(waiting.id)!.status, RegistrationStatus.waitlist);
  });

  test('promote gives a place once there is room, and the list refreshes', () async {
    final world = TestWorld();
    final c = await signedIn(world);
    final provider = attendeesControllerProvider('acme', 'summer-meetup');
    c.listen(provider, (_, _) {});
    final list = await c.read(provider.future);
    final waiting = list.attendees.firstWhere((a) => a.status == RegistrationStatus.waitlist);

    // Make room by cancelling one confirmed person server-side.
    world.store.registrations
        .firstWhere((r) => r.eventId == world.store.registrationById(waiting.id)!.eventId &&
            r.status == RegistrationStatus.confirmed)
        .status = RegistrationStatus.cancelled;

    final actions = c.read(attendeeActionsProvider.notifier);
    expect(await actions.promote('acme', 'summer-meetup', waiting.id), PromoteOutcome.promoted);
    await settle();
    final after = c.read(provider).requireValue;
    expect(after.attendees.firstWhere((a) => a.id == waiting.id).status,
        RegistrationStatus.confirmed);

    // Counts on the event follow.
    final detail = await c.read(eventDetailProvider('acme', 'summer-meetup').future);
    expect(detail.waitlist, 3);
    expect(detail.confirmed, 40);
  });

  test('promote on a confirmed or unknown registration is "gone"', () async {
    final c = await signedIn(TestWorld());
    final actions = c.read(attendeeActionsProvider.notifier);
    final list = await c.read(attendeesControllerProvider('acme', 'summer-meetup').future);
    final confirmed = list.attendees.firstWhere((a) => a.status == RegistrationStatus.confirmed);
    expect(await actions.promote('acme', 'summer-meetup', confirmed.id), PromoteOutcome.gone);
    expect(await actions.promote('acme', 'summer-meetup', 'nope'), PromoteOutcome.gone);
  });

  test('erase clears identity and check-in but keeps the row', () async {
    final world = TestWorld();
    final c = await signedIn(world);
    final provider = attendeesControllerProvider('acme', 'design-workshop');
    c.listen(provider, (_, _) {});
    final list = await c.read(provider.future);
    final target = list.attendees.firstWhere((a) => a.checkedIn && !a.erased);

    await c.read(attendeeActionsProvider.notifier).erase('acme', 'design-workshop', target.id);
    await settle();

    final row = world.store.registrationById(target.id)!;
    expect(row.erased, isTrue);
    expect(row.name, isNull);
    expect(row.email, 'deleted+${target.id}@anon.invalid');
    expect(row.checkedInAt, isNull);
    expect(row.checkInToken, isNull);
    expect(row.status, RegistrationStatus.confirmed, reason: 'still counted');

    final after = c.read(provider).requireValue;
    final shown = after.attendees.firstWhere((a) => a.id == target.id);
    expect(shown.erased, isTrue);
    expect(shown.name, isNull);
    expect(shown.email, isNull);
    expect(shown.checkInToken, isNull, reason: 'offline scans must not resolve it');
    expect(after.attendees.length, list.attendees.length);
    expect(after.checkedInCount, list.checkedInCount - 1);

    // Idempotent.
    await c.read(attendeeActionsProvider.notifier).erase('acme', 'design-workshop', target.id);
  });

  test('erase of an unknown row is a 404', () async {
    final c = await signedIn(TestWorld());
    await expectLater(
      c.read(attendeeActionsProvider.notifier).erase('acme', 'design-workshop', 'nope'),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 404)),
    );
  });

  test('export hands a CSV with the web columns to the share sheet', () async {
    final c = await signedIn(TestWorld());
    final name = await c.read(attendeeActionsProvider.notifier).export('acme', 'design-workshop');
    expect(name, 'design-workshop-attendees.csv');
    expect(sharer.shared, hasLength(1));
    final (csv, filename) = sharer.shared.single;
    expect(filename, name);
    final lines = const LineSplitter().convert(csv);
    expect(lines.first, 'Name,Email,Status,Checked in,Registered at');
    expect(lines.length, 1 + 19);
    expect(csv, contains('\r\n'));
    expect(lines.where((l) => l.startsWith('(erased),(erased),CONFIRMED')), hasLength(1));
    expect(lines.where((l) => l.contains(',CONFIRMED,2026-')), hasLength(7),
        reason: 'seven checked-in rows carry a timestamp');
  });

  test('export needs membership', () async {
    final world = TestWorld();
    sharer = _RecordingSharer();
    final c = ProviderContainer(retry: appRetryPolicy, overrides: [
      ...world.overrides,
      csvSharerProvider.overrideWithValue(sharer),
    ]);
    addTearDown(c.dispose);
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.attendeeEmail, FakeAccounts.password);
    await expectLater(
      c.read(attendeeActionsProvider.notifier).export('acme', 'design-workshop'),
      throwsA(isA<ApiError>().having((e) => e.status, 'status', 403)),
    );
    expect(sharer.shared, isEmpty);
  });
}
