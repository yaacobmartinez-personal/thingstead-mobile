import '../../features/organizer/checkin/domain/scan_result.dart';
import '../model/enums.dart';
import '../util/checkin_code.dart';
import 'fake_store.dart';

/// Port of `performCheckIn` (regista/lib/checkin.ts): the token identifies a
/// registration inside the scanning org only; the decision table is
/// wrong_event → cancelled → waitlist → already → checked_in; idempotent.
ScanResult performFakeCheckIn(
  FakeStore store, {
  required String tenantId,
  required String rawCode,
  String? requireEventId,
  required DateTime now,

  /// The claimed door time, already known not to be impossibly ahead of
  /// [now]; pulled into [registration.createdAt, now] like the server does.
  DateTime? at,
}) {
  final token = extractCheckInToken(rawCode);
  if (token == null) return const ScanResult(outcome: CheckInOutcome.invalid);

  final r = store.registrationByCheckInToken(token);
  if (r == null || r.tenantId != tenantId) {
    return const ScanResult(outcome: CheckInOutcome.invalid);
  }
  final tenant = store.tenantById(r.tenantId);
  if (tenant == null || tenant.status != TenantStatus.active) {
    return const ScanResult(outcome: CheckInOutcome.invalid);
  }
  final event = store.eventById(r.eventId);

  if (requireEventId != null && r.eventId != requireEventId) {
    return ScanResult(
      outcome: CheckInOutcome.wrongEvent,
      name: r.name,
      eventTitle: event?.title,
    );
  }
  if (r.status == RegistrationStatus.cancelled) {
    return ScanResult(outcome: CheckInOutcome.cancelled, name: r.name);
  }
  if (r.status == RegistrationStatus.waitlist) {
    return ScanResult(outcome: CheckInOutcome.waitlist, name: r.name);
  }
  if (r.checkedInAt != null) {
    return ScanResult(outcome: CheckInOutcome.already, name: r.name, at: r.checkedInAt);
  }
  final stamp = at == null
      ? now
      : at.isBefore(r.createdAt)
          ? r.createdAt
          : at.isAfter(now)
              ? now
              : at.toUtc();
  r.checkedInAt = stamp;
  return ScanResult(outcome: CheckInOutcome.checkedIn, name: r.name, at: stamp);
}
