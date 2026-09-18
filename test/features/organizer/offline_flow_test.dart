import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/connectivity/connectivity_provider.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/attendees/application/attendees_controller.dart';
import 'package:thingstead/features/organizer/checkin/application/sync_controller.dart';
import 'package:thingstead/features/organizer/checkin/domain/scan_result.dart';
import 'package:thingstead/features/organizer/events/application/events_controller.dart';
import 'package:thingstead/features/organizer/scanner/application/scanner_controller.dart';

import '../../helpers/fakes.dart';

/// The offline story end to end, against the in-memory database and the
/// fake server: go offline, scan and toggle, come back, watch it sync.
void main() {
  Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 30));

  test('scans and toggles made offline replay when the network returns', () async {
    final world = TestWorld();
    final c = world.container();
    c.listen(isOnlineProvider, (_, _) {}); // as the app does at start
    c.listen(syncControllerProvider, (_, _) {}); // as the organizer shell does
    await settle();
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);

    // Warm the cache while online (as opening the list would).
    final list = attendeesControllerProvider('acme', 'summer-meetup');
    c.listen(list, (_, _) {});
    final s0 = await c.read(list.future);
    expect(s0.stale, isFalse);
    final acme = world.store.tenantBySlug('acme')!;
    final summer = world.store.eventBySlug(acme.id, 'summer-meetup')!;

    // Go offline.
    world.setOnline(false);
    await settle();

    // A manual toggle is applied locally and queued.
    final target = s0.attendees.firstWhere((a) => a.canCheckIn && !a.checkedIn);
    expect(await c.read(list.notifier).toggle(target), isNull);
    await settle();
    var s = c.read(list).requireValue;
    expect(s.attendees.firstWhere((a) => a.id == target.id).checkedIn, isTrue);
    expect(s.pendingIds, contains(target.id));
    expect(world.store.registrationById(target.id)!.checkedInAt, isNull, reason: 'server untouched');

    // A known ticket resolves offline with instant feedback.
    final scanner = scannerControllerProvider('acme', 'summer-meetup');
    c.listen(scanner, (_, _) {});
    final other = s0.attendees.firstWhere((a) => a.canCheckIn && !a.checkedIn && a.id != target.id);
    await c.read(scanner.notifier).submit(other.checkInToken!);
    var sc = c.read(scanner);
    expect(sc.lastResult?.outcome, CheckInOutcome.checkedIn);
    expect(sc.lastResult?.offline, isTrue);
    expect(sc.feedback?.title, 'Checked in (offline)');
    c.read(scanner.notifier).scanNext();

    // The same ticket again reads "already" from the cache.
    await c.read(scanner.notifier).submit(other.checkInToken!);
    expect(c.read(scanner).lastResult?.outcome, CheckInOutcome.already);
    c.read(scanner.notifier).scanNext();

    // An unknown ticket is queued blind.
    await c.read(scanner.notifier).submit('chk_unknown');
    sc = c.read(scanner);
    expect(sc.lastResult?.outcome, CheckInOutcome.queuedUnverified);
    c.read(scanner.notifier).scanNext();

    await settle();
    expect(c.read(syncControllerProvider).pending, 3);

    // Back online: everything drains.
    world.setOnline(true);
    await settle();
    await settle();
    final status = c.read(syncControllerProvider);
    expect(status.pending, 0);
    expect(status.attention, 1, reason: 'the unknown ticket is invalid on the server');
    expect(status.lastSyncedAt, isNotNull);

    expect(world.store.registrationById(target.id)!.checkedInAt, testNow);
    expect(world.store.registrationById(other.id)!.checkedInAt, testNow);
    s = c.read(list).requireValue;
    expect(s.pendingIds, isEmpty);
    expect(s.attendees.firstWhere((a) => a.id == other.id).checkedInAt, testNow);
    expect(world.store.checkedInCount(summer.id), 2);
  });

  test('the attendee list and events open from the cache when offline', () async {
    final world = TestWorld();
    final c = world.container();
    c.listen(isOnlineProvider, (_, _) {});
    await settle();
    await c
        .read(authControllerProvider.notifier)
        .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);

    final events = orgEventsProvider('acme');
    c.listen(events, (_, _) {});
    expect((await c.read(events.future)).stale, isFalse);
    final list = attendeesControllerProvider('acme', 'design-workshop');
    c.listen(list, (_, _) {});
    await c.read(list.future);

    // Simulate an unreachable server for the next fetches.
    world.setOnline(false);
    await settle();
    c.invalidate(events);
    c.invalidate(list);

    final offlineEvents = await c.read(events.future);
    expect(offlineEvents.stale, isTrue);
    expect(offlineEvents.events.map((e) => e.slug), contains('design-workshop'));
    expect(offlineEvents.org.name, 'Acme Meetups');

    final offlineList = await c.read(list.future);
    expect(offlineList.stale, isTrue);
    expect(offlineList.attendees, isNotEmpty);
    expect(offlineList.list.event.title, 'Design Workshop');
  });

  test('a deliberate sign-out wipes the queue; an expired session keeps it', () async {
    final world = TestWorld();
    final c = world.container();
    c.listen(isOnlineProvider, (_, _) {});
    await settle();
    final auth = c.read(authControllerProvider.notifier);
    await auth.signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
    c.listen(syncControllerProvider, (_, _) {});
    final list = attendeesControllerProvider('acme', 'summer-meetup');
    c.listen(list, (_, _) {});
    final s0 = await c.read(list.future);

    world.setOnline(false);
    await settle();
    await c.read(list.notifier).toggle(s0.attendees.firstWhere((a) => a.canCheckIn && !a.checkedIn));
    await settle();
    expect(c.read(syncControllerProvider).pending, 1);

    await auth.signOut();
    await settle();
    expect(await world.db.watchOpenOps().first, isEmpty);
    expect(await world.db.readEvents('acme'), isEmpty);
  });

  test('status enums round-trip through the cache', () {
    for (final s in RegistrationStatus.values) {
      expect(RegistrationStatus.fromWire(s.wire), s);
    }
    for (final s in EventStatus.values) {
      expect(EventStatus.fromWire(s.wire), s);
    }
  });
}
