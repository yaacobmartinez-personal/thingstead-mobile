import '../../../../core/model/enums.dart';
import '../../../../core/storage/db/app_database.dart';
import '../domain/scan_result.dart';

/// What to do with a scan while offline.
class OfflineDecision {
  const OfflineDecision({
    required this.result,
    this.enqueue = false,
    this.markLocal = false,
  });

  /// Shown on the card (always `offline: true`).
  final ScanResult result;

  /// Whether a `scan` op should be queued for replay.
  final bool enqueue;

  /// Whether the cached row should be marked present now.
  final bool markLocal;
}

/// The check-in decision table (regista/lib/checkin.ts) applied to the
/// local cache. Same order as the server: wrong event, cancelled, waitlist,
/// already, checked in — so staff get the same instant, named feedback
/// offline as online. A token the cache does not know is queued blind and
/// verified on sync.
abstract final class OfflineResolver {
  static OfflineDecision resolve({
    required CachedAttendee? row,
    required String? pinnedEvent,
    required bool hasOpenCheckIn,
    required DateTime now,
  }) {
    if (row == null) {
      return const OfflineDecision(
        result: ScanResult(outcome: CheckInOutcome.queuedUnverified, offline: true),
        enqueue: true,
      );
    }
    if (pinnedEvent != null && row.eventSlug != pinnedEvent) {
      return OfflineDecision(
        result: ScanResult(
          outcome: CheckInOutcome.wrongEvent,
          name: row.name,
          offline: true,
        ),
      );
    }
    final status = RegistrationStatus.fromWire(row.status);
    if (status == RegistrationStatus.cancelled) {
      return OfflineDecision(
        result: ScanResult(outcome: CheckInOutcome.cancelled, name: row.name, offline: true),
      );
    }
    if (status == RegistrationStatus.waitlist) {
      return OfflineDecision(
        result: ScanResult(outcome: CheckInOutcome.waitlist, name: row.name, offline: true),
      );
    }
    if (row.checkedInAt != null || hasOpenCheckIn) {
      return OfflineDecision(
        result: ScanResult(
          outcome: CheckInOutcome.already,
          name: row.name,
          at: row.checkedInAt,
          offline: true,
        ),
      );
    }
    return OfflineDecision(
      result: ScanResult(
        outcome: CheckInOutcome.checkedIn,
        name: row.name,
        at: now,
        offline: true,
      ),
      enqueue: true,
      markLocal: true,
    );
  }
}
