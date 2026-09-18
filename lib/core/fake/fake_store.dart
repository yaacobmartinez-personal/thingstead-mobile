import '../model/enums.dart';

/// An in-memory picture of the server's database, shaped like the Prisma
/// models in regista/prisma/schema.prisma. Every `Fake*Repository` reads and
/// mutates this one store, so the attendee and organizer sides of the app see
/// each other's changes exactly as they would through the real API.
///
/// Entities are plain mutable classes on purpose: this is a test double, not
/// domain code. Domain models live in each feature and are built from these.

class FakeUser {
  FakeUser({
    required this.id,
    required this.email,
    required this.name,
    this.password,
    this.emailVerified,
    this.googleSub,
    this.appleSub,
    required this.createdAt,
  });

  final String id;
  String email;
  String? name;
  String? password;
  DateTime? emailVerified;
  String? googleSub;
  String? appleSub;
  final DateTime createdAt;
}

class FakeTenant {
  FakeTenant({
    required this.id,
    required this.slug,
    required this.name,
    this.status = TenantStatus.active,
    this.plan = PlanTier.free,
    required this.createdAt,
  });

  final String id;
  String slug;
  String name;
  TenantStatus status;
  PlanTier plan;
  final DateTime createdAt;
}

class FakeMembership {
  FakeMembership({
    required this.id,
    required this.userId,
    required this.tenantId,
    required this.role,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String tenantId;
  Role role;
  final DateTime createdAt;
}

class FakeInvitation {
  FakeInvitation({
    required this.id,
    required this.tenantId,
    required this.email,
    required this.role,
    required this.token,
    required this.expiresAt,
    this.acceptedAt,
    required this.createdAt,
  });

  final String id;
  final String tenantId;
  final String email;
  final Role role;
  final String token;
  final DateTime expiresAt;
  DateTime? acceptedAt;
  final DateTime createdAt;
}

class FakeEvent {
  FakeEvent({
    required this.id,
    required this.tenantId,
    required this.slug,
    required this.title,
    this.description,
    required this.startsAt,
    this.endsAt,
    required this.timezone,
    this.capacity,
    this.waitlistEnabled = false,
    this.status = EventStatus.draft,
    required this.createdAt,
  });

  final String id;
  final String tenantId;
  String slug;
  String title;
  String? description;
  DateTime startsAt; // UTC
  DateTime? endsAt; // UTC
  String timezone; // IANA
  int? capacity;
  bool waitlistEnabled;
  EventStatus status;
  final DateTime createdAt;
}

class FakeRegistration {
  FakeRegistration({
    required this.id,
    required this.tenantId,
    required this.eventId,
    this.userId,
    this.name,
    required this.email,
    this.status = RegistrationStatus.confirmed,
    this.checkedInAt,
    this.anonymizedAt,
    this.manageToken,
    this.checkInToken,
    required this.createdAt,
  });

  final String id;
  final String tenantId;
  final String eventId;
  String? userId;
  String? name;
  String? email;
  RegistrationStatus status;
  DateTime? checkedInAt;
  DateTime? anonymizedAt;
  String? manageToken;
  String? checkInToken;
  final DateTime createdAt;

  bool get erased => anonymizedAt != null;
}

class FakeStore {
  FakeStore();

  final users = <FakeUser>[];
  final tenants = <FakeTenant>[];
  final memberships = <FakeMembership>[];
  final invitations = <FakeInvitation>[];
  final events = <FakeEvent>[];
  final registrations = <FakeRegistration>[];

  /// Raw verification token -> user id (single use).
  final verificationTokens = <String, String>{};

  /// Raw reset token -> (user id, expiry) (single use).
  final resetTokens = <String, (String, DateTime)>{};

  /// Emails the fake server would have sent, newest last.
  final outbox = <FakeEmail>[];

  int _sequence = 0;

  /// Deterministic ids (u_1, ev_12, ...) so tests and fixtures can name them.
  String nextId(String prefix) => '${prefix}_${++_sequence}';

  FakeUser? userById(String id) => users.where((u) => u.id == id).firstOrNull;

  FakeUser? userByEmail(String email) {
    final needle = email.trim().toLowerCase();
    return users.where((u) => u.email.toLowerCase() == needle).firstOrNull;
  }

  FakeTenant? tenantById(String id) =>
      tenants.where((t) => t.id == id).firstOrNull;

  FakeTenant? tenantBySlug(String slug) =>
      tenants.where((t) => t.slug == slug).firstOrNull;

  /// Only ACTIVE tenants resolve publicly, like `resolveActiveTenant`.
  FakeTenant? activeTenantBySlug(String slug) {
    final t = tenantBySlug(slug);
    return t != null && t.status == TenantStatus.active ? t : null;
  }

  FakeMembership? membership(String userId, String tenantId) => memberships
      .where((m) => m.userId == userId && m.tenantId == tenantId)
      .firstOrNull;

  Iterable<FakeMembership> membershipsOf(String userId) =>
      memberships.where((m) => m.userId == userId);

  FakeEvent? eventById(String id) => events.where((e) => e.id == id).firstOrNull;

  FakeEvent? eventBySlug(String tenantId, String slug) => events
      .where((e) => e.tenantId == tenantId && e.slug == slug)
      .firstOrNull;

  Iterable<FakeEvent> eventsOf(String tenantId) =>
      events.where((e) => e.tenantId == tenantId);

  Iterable<FakeRegistration> registrationsOf(String eventId) =>
      registrations.where((r) => r.eventId == eventId);

  FakeRegistration? registrationById(String id) =>
      registrations.where((r) => r.id == id).firstOrNull;

  FakeRegistration? registrationByCheckInToken(String token) => registrations
      .where((r) => r.checkInToken == token && !r.erased)
      .firstOrNull;

  FakeRegistration? registrationByManageToken(String token) => registrations
      .where((r) => r.manageToken == token && !r.erased)
      .firstOrNull;

  int confirmedCount(String eventId) => registrationsOf(eventId)
      .where((r) => r.status == RegistrationStatus.confirmed)
      .length;

  int waitlistCount(String eventId) => registrationsOf(eventId)
      .where((r) => r.status == RegistrationStatus.waitlist)
      .length;

  int checkedInCount(String eventId) =>
      registrationsOf(eventId).where((r) => r.checkedInAt != null).length;
}

/// A message the fake server "sent". Verification and reset tokens surface
/// here so fake mode can complete flows that need an inbox.
class FakeEmail {
  FakeEmail({
    required this.to,
    required this.kind,
    required this.token,
    required this.sentAt,
  });

  final String to;
  final FakeEmailKind kind;
  final String token;
  final DateTime sentAt;
}

enum FakeEmailKind { verify, reset, invite, registration }
