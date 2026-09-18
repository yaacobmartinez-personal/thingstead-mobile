import '../model/enums.dart';
import 'fake_store.dart';

/// Demo accounts for fake mode. Passwords are plain text here because this is
/// a test double that never leaves the device.
abstract final class FakeAccounts {
  /// ADMIN of Acme, STAFF at Beta; also holds a couple of tickets.
  static const organizerEmail = 'demo@thingstead.test';

  /// No memberships: exercises the attendee-only experience.
  static const attendeeEmail = 'attendee@thingstead.test';

  static const password = 'password123';
}

const _firstNames = [
  'Ava', 'Ben', 'Carla', 'Diego', 'Elena', 'Farid', 'Grace', 'Hugo', 'Isla',
  'Jonas', 'Kaya', 'Liam', 'Mira', 'Noel', 'Odette', 'Paolo', 'Quinn', 'Rosa',
  'Sami', 'Tess', 'Uma', 'Vince', 'Wren', 'Xavi', 'Yara', 'Zed',
];

const _lastNames = [
  'Reyes', 'Santos', 'Cruz', 'Bautista', 'Garcia', 'Mendoza', 'Torres',
  'Flores', 'Ramos', 'Villanueva', 'Aquino', 'Castillo', 'Navarro',
];

/// Populate [store] with a coherent world relative to [now] (UTC).
///
/// Orgs: `acme` (Acme Meetups, demo user is ADMIN) and `beta` (Beta
/// Collective, demo user is STAFF). Events cover DRAFT / PUBLISHED / CLOSED,
/// upcoming / today / past, capacity full with a waitlist, and no capacity.
/// Registrations cover every status plus checked-in, cancelled, and erased.
void seedFakeStore(FakeStore store, DateTime now) {
  final t0 = now.toUtc().subtract(const Duration(days: 120));

  // --- users ---------------------------------------------------------------
  final demo = FakeUser(
    id: store.nextId('u'),
    email: FakeAccounts.organizerEmail,
    name: 'Demo Organizer',
    password: FakeAccounts.password,
    emailVerified: t0,
    createdAt: t0,
  );
  final attendee = FakeUser(
    id: store.nextId('u'),
    email: FakeAccounts.attendeeEmail,
    name: 'Alex Attendee',
    password: FakeAccounts.password,
    emailVerified: t0,
    createdAt: t0,
  );
  final coAdmin = FakeUser(
    id: store.nextId('u'),
    email: 'maria@acme.test',
    name: 'Maria Lopez',
    password: FakeAccounts.password,
    emailVerified: t0,
    createdAt: t0,
  );
  final staffer = FakeUser(
    id: store.nextId('u'),
    email: 'door@acme.test',
    name: 'Door Staff',
    password: FakeAccounts.password,
    emailVerified: t0,
    createdAt: t0,
  );
  final betaOwner = FakeUser(
    id: store.nextId('u'),
    email: 'owner@beta.test',
    name: 'Beta Owner',
    password: FakeAccounts.password,
    emailVerified: t0,
    createdAt: t0,
  );
  store.users.addAll([demo, attendee, coAdmin, staffer, betaOwner]);

  // --- tenants + memberships ------------------------------------------------
  final acme = FakeTenant(
    id: store.nextId('t'),
    slug: 'acme',
    name: 'Acme Meetups',
    plan: PlanTier.premium,
    createdAt: t0,
  );
  final beta = FakeTenant(
    id: store.nextId('t'),
    slug: 'beta',
    name: 'Beta Collective',
    createdAt: t0.add(const Duration(days: 3)),
  );
  store.tenants.addAll([acme, beta]);

  void join(FakeUser u, FakeTenant t, Role role, int dayOffset) {
    store.memberships.add(FakeMembership(
      id: store.nextId('m'),
      userId: u.id,
      tenantId: t.id,
      role: role,
      createdAt: t0.add(Duration(days: dayOffset)),
    ));
  }

  join(demo, acme, Role.admin, 0);
  join(coAdmin, acme, Role.admin, 5);
  join(staffer, acme, Role.staff, 20);
  join(betaOwner, beta, Role.admin, 3);
  join(demo, beta, Role.staff, 10);

  store.invitations.add(FakeInvitation(
    id: store.nextId('inv'),
    tenantId: acme.id,
    email: 'newhire@acme.test',
    role: Role.staff,
    token: 'invite_acme_newhire',
    expiresAt: now.add(const Duration(days: 5)),
    createdAt: now.subtract(const Duration(days: 2)),
  ));
  store.invitations.add(FakeInvitation(
    id: store.nextId('inv'),
    tenantId: acme.id,
    email: 'expired@acme.test',
    role: Role.admin,
    token: 'invite_acme_expired',
    expiresAt: now.subtract(const Duration(days: 1)),
    createdAt: now.subtract(const Duration(days: 8)),
  ));

  // --- events ---------------------------------------------------------------
  DateTime at(int days, int hourUtc) =>
      DateTime.utc(now.year, now.month, now.day, hourUtc)
          .add(Duration(days: days));

  final summer = FakeEvent(
    id: store.nextId('ev'),
    tenantId: acme.id,
    slug: 'summer-meetup',
    title: 'Summer Meetup',
    description:
        'Our biggest gathering of the year. Talks, demos, and an open mic. '
        'Doors open 30 minutes early; bring your ticket QR.',
    startsAt: at(7, 10), // 18:00 Manila
    endsAt: at(7, 13),
    timezone: 'Asia/Manila',
    capacity: 40,
    waitlistEnabled: true,
    status: EventStatus.published,
    createdAt: now.subtract(const Duration(days: 30)),
  );
  final workshop = FakeEvent(
    id: store.nextId('ev'),
    tenantId: acme.id,
    slug: 'design-workshop',
    title: 'Design Workshop',
    description: 'Hands-on session on product design fundamentals. '
        'Laptops recommended.',
    startsAt: now.add(const Duration(hours: 2)),
    endsAt: now.add(const Duration(hours: 5)),
    timezone: 'Asia/Manila',
    capacity: 20,
    waitlistEnabled: false,
    status: EventStatus.published,
    createdAt: now.subtract(const Duration(days: 14)),
  );
  final dinner = FakeEvent(
    id: store.nextId('ev'),
    tenantId: acme.id,
    slug: 'founders-dinner',
    title: 'Founders Dinner',
    description: 'Invite-only dinner. Draft until the venue confirms.',
    startsAt: at(30, 11),
    endsAt: at(30, 14),
    timezone: 'Asia/Manila',
    capacity: 12,
    waitlistEnabled: true,
    status: EventStatus.draft,
    createdAt: now.subtract(const Duration(days: 2)),
  );
  final kickoff = FakeEvent(
    id: store.nextId('ev'),
    tenantId: acme.id,
    slug: 'spring-kickoff',
    title: 'Spring Kickoff',
    description: 'Season opener. Closed after the event.',
    startsAt: at(-60, 10),
    endsAt: at(-60, 12),
    timezone: 'Asia/Manila',
    capacity: 50,
    waitlistEnabled: true,
    status: EventStatus.closed,
    createdAt: now.subtract(const Duration(days: 90)),
  );
  final hackathon = FakeEvent(
    id: store.nextId('ev'),
    tenantId: beta.id,
    slug: 'community-hackathon',
    title: 'Community Hackathon',
    description: 'A weekend of building. No cap on attendance.',
    startsAt: at(14, 1), // 09:00 Manila... but Beta is in London
    endsAt: at(15, 17),
    timezone: 'Europe/London',
    capacity: null,
    waitlistEnabled: false,
    status: EventStatus.published,
    createdAt: now.subtract(const Duration(days: 20)),
  );
  store.events.addAll([summer, workshop, dinner, kickoff, hackathon]);

  // --- registrations --------------------------------------------------------
  var personIndex = 0;
  FakeRegistration reg(
    FakeEvent ev, {
    RegistrationStatus status = RegistrationStatus.confirmed,
    bool checkedIn = false,
    bool erased = false,
    FakeUser? user,
    int minutesAgo = 0,
  }) {
    final i = personIndex++;
    final first = _firstNames[i % _firstNames.length];
    final last = _lastNames[(i ~/ _firstNames.length + i) % _lastNames.length];
    final id = store.nextId('r');
    final createdAt = ev.createdAt.add(Duration(hours: 6 + i * 3));
    final r = FakeRegistration(
      id: id,
      tenantId: ev.tenantId,
      eventId: ev.id,
      userId: user?.id,
      name: erased ? null : (user?.name ?? '$first $last'),
      email: erased
          ? null
          : (user?.email ?? '${first.toLowerCase()}.${last.toLowerCase()}@example.com'),
      status: status,
      checkedInAt: checkedIn
          ? now.subtract(Duration(minutes: minutesAgo == 0 ? 15 + i : minutesAgo))
          : null,
      anonymizedAt: erased ? now.subtract(const Duration(days: 1)) : null,
      manageToken: erased ? null : 'manage_$id',
      checkInToken: erased ? null : 'chk_$id',
      createdAt: createdAt,
    );
    store.registrations.add(r);
    return r;
  }

  // Summer Meetup: full (40/40) with a waitlist of 4, a cancellation, the
  // attendee demo account holds a confirmed ticket, the organizer is waitlisted.
  for (var i = 0; i < 38; i++) {
    reg(summer);
  }
  reg(summer, user: attendee);
  reg(summer, user: coAdmin);
  reg(summer, status: RegistrationStatus.cancelled);
  for (var i = 0; i < 3; i++) {
    reg(summer, status: RegistrationStatus.waitlist);
  }
  reg(summer, status: RegistrationStatus.waitlist, user: demo);

  // Design Workshop (today): 18/20, 7 already checked in, one erased row.
  for (var i = 0; i < 7; i++) {
    reg(workshop, checkedIn: true);
  }
  for (var i = 0; i < 9; i++) {
    reg(workshop);
  }
  reg(workshop, user: attendee, checkedIn: false);
  reg(workshop, user: demo);
  reg(workshop, erased: true);

  // Spring Kickoff (closed, past): 45 attended out of 50, 2 cancelled, 1 erased.
  for (var i = 0; i < 45; i++) {
    reg(kickoff, checkedIn: true, minutesAgo: 60 * 24 * 60 + i);
  }
  for (var i = 0; i < 3; i++) {
    reg(kickoff);
  }
  reg(kickoff, status: RegistrationStatus.cancelled);
  reg(kickoff, status: RegistrationStatus.cancelled);
  reg(kickoff, erased: true);
  reg(kickoff, user: attendee, checkedIn: true, minutesAgo: 60 * 24 * 60);

  // Community Hackathon (Beta, no capacity): a handful signed up.
  for (var i = 0; i < 6; i++) {
    reg(hackathon);
  }
  reg(hackathon, user: attendee);
}
