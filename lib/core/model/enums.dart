// Wire-level enums shared by every feature. Values match the Prisma enums and
// the JSON the API emits, so they serialize by name.

enum Role {
  admin('ADMIN'),
  staff('STAFF');

  const Role(this.wire);
  final String wire;

  static Role fromWire(String v) =>
      values.firstWhere((r) => r.wire == v, orElse: () => Role.staff);

  /// ADMIN outranks STAFF; mirrors roleAtLeast in regista/lib/authz.ts.
  bool atLeast(Role min) => _rank >= min._rank;
  int get _rank => this == Role.admin ? 2 : 1;
}

enum PlanTier {
  free('FREE'),
  premium('PREMIUM'),
  custom('CUSTOM');

  const PlanTier(this.wire);
  final String wire;

  static PlanTier fromWire(String v) =>
      values.firstWhere((p) => p.wire == v, orElse: () => PlanTier.free);
}

enum EventStatus {
  draft('DRAFT'),
  published('PUBLISHED'),
  closed('CLOSED');

  const EventStatus(this.wire);
  final String wire;

  static EventStatus fromWire(String v) =>
      values.firstWhere((s) => s.wire == v, orElse: () => EventStatus.draft);
}

enum RegistrationStatus {
  confirmed('CONFIRMED'),
  waitlist('WAITLIST'),
  cancelled('CANCELLED');

  const RegistrationStatus(this.wire);
  final String wire;

  static RegistrationStatus fromWire(String v) => values.firstWhere(
        (s) => s.wire == v,
        orElse: () => RegistrationStatus.confirmed,
      );
}

enum TenantStatus { pending, active }
