import 'package:json_annotation/json_annotation.dart';

// Wire-level enums shared by every feature. Values match the Prisma enums and
// the JSON the API emits, so they serialize by name.

enum Role {
  @JsonValue('ADMIN')
  admin('ADMIN'),
  @JsonValue('STAFF')
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
  @JsonValue('FREE')
  free('FREE'),
  @JsonValue('PREMIUM')
  premium('PREMIUM'),
  @JsonValue('CUSTOM')
  custom('CUSTOM');

  const PlanTier(this.wire);
  final String wire;

  static PlanTier fromWire(String v) =>
      values.firstWhere((p) => p.wire == v, orElse: () => PlanTier.free);
}

enum EventStatus {
  @JsonValue('DRAFT')
  draft('DRAFT'),
  @JsonValue('PUBLISHED')
  published('PUBLISHED'),
  @JsonValue('CLOSED')
  closed('CLOSED');

  const EventStatus(this.wire);
  final String wire;

  static EventStatus fromWire(String v) =>
      values.firstWhere((s) => s.wire == v, orElse: () => EventStatus.draft);
}

enum RegistrationStatus {
  @JsonValue('CONFIRMED')
  confirmed('CONFIRMED'),
  @JsonValue('WAITLIST')
  waitlist('WAITLIST'),
  @JsonValue('CANCELLED')
  cancelled('CANCELLED');

  const RegistrationStatus(this.wire);
  final String wire;

  static RegistrationStatus fromWire(String v) => values.firstWhere(
        (s) => s.wire == v,
        orElse: () => RegistrationStatus.confirmed,
      );
}

enum TenantStatus { pending, active }
