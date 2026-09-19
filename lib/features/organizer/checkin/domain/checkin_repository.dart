import 'scan_result.dart';

abstract class CheckinRepository {
  /// E5 — mark a registration present (or not) by hand. Returns the server's
  /// `checkedInAt`. 404 when the id is not in the org.
  ///
  /// [at] is when it really happened (API-CONTRACT #24): offline replays pass
  /// the door time so a queue drained an hour later does not record the whole
  /// door as arriving at once. The server clamps it into
  /// [registration.createdAt, now] and rejects anything more than five
  /// minutes in the future with a 400. Omitted = now.
  Future<DateTime?> setCheckedIn(
    String orgSlug,
    String eventSlug,
    String registrationId, {
    required bool checkedIn,
    DateTime? at,
  });

  /// E6 — check in from a scanned QR (raw token or full URL). Always a
  /// business outcome for a valid request; never throws for a bad ticket.
  ///
  /// [at] is the real door time when an offline scan is replayed, bounded
  /// like the manual one (see [setCheckedIn]). Omitted = now.
  Future<ScanResult> scan(String orgSlug, String code, {String? eventSlug, DateTime? at});
}
