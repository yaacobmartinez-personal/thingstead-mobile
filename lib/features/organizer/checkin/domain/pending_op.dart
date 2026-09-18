import '../../../../core/storage/db/app_database.dart';

enum PendingKind { manual, scan }

enum PendingState { pending, syncing, synced, attention }

/// A queued check-in as the UI sees it.
class PendingOp {
  const PendingOp({
    required this.id,
    required this.org,
    required this.event,
    required this.kind,
    required this.state,
    required this.clientAt,
    this.registrationId,
    this.code,
    this.desiredCheckedIn,
    this.attendeeName,
    this.attempts = 0,
    this.lastError,
    this.serverOutcome,
  });

  factory PendingOp.fromRow(PendingCheckin r) => PendingOp(
        id: r.id,
        org: r.orgSlug,
        event: r.eventSlug,
        kind: r.kind == 'scan' ? PendingKind.scan : PendingKind.manual,
        state: PendingState.values.firstWhere(
          (s) => s.name == r.state,
          orElse: () => PendingState.pending,
        ),
        clientAt: r.clientAt,
        registrationId: r.registrationId,
        code: r.code,
        desiredCheckedIn: r.desiredCheckedIn,
        attendeeName: r.attendeeName,
        attempts: r.attempts,
        lastError: r.lastError,
        serverOutcome: r.serverOutcome,
      );

  final String id;
  final String org;
  final String? event;
  final PendingKind kind;
  final PendingState state;
  final DateTime clientAt;
  final String? registrationId;
  final String? code;
  final bool? desiredCheckedIn;
  final String? attendeeName;
  final int attempts;
  final String? lastError;
  final String? serverOutcome;

  /// Human summary for the attention list.
  String get whatHappened {
    if (serverOutcome != null) {
      return switch (serverOutcome) {
        'invalid' => 'The server did not recognise this ticket.',
        'wrong_event' => 'This ticket is for a different event.',
        'cancelled' => 'This place was cancelled.',
        'waitlist' => 'This person is on the waitlist, not confirmed.',
        'not_found' => 'This registration no longer exists.',
        final o => 'Server answered: $o.',
      };
    }
    return lastError ?? 'Could not sync.';
  }
}
