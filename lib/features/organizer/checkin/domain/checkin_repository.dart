import 'scan_result.dart';

abstract class CheckinRepository {
  /// E5 — mark a registration present (or not) by hand. Returns the server's
  /// `checkedInAt`. 404 when the id is not in the org.
  Future<DateTime?> setCheckedIn(
    String orgSlug,
    String eventSlug,
    String registrationId, {
    required bool checkedIn,
  });

  /// E6 — check in from a scanned QR (raw token or full URL). Always a
  /// business outcome for a valid request; never throws for a bad ticket.
  Future<ScanResult> scan(String orgSlug, String code, {String? eventSlug});
}
