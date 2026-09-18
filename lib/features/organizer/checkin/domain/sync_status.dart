/// What the sync badge shows.
class SyncStatus {
  const SyncStatus({
    this.pending = 0,
    this.attention = 0,
    this.syncing = false,
    this.blocked,
    this.lastSyncedAt,
  });

  static const idle = SyncStatus();

  /// Ops waiting to be replayed (pending + in flight).
  final int pending;

  /// Ops the server refused; someone has to look.
  final int attention;
  final bool syncing;

  /// Why draining stopped, when it did: `membership` (403) or `signedOut`.
  final String? blocked;
  final DateTime? lastSyncedAt;

  bool get isClean => pending == 0 && attention == 0 && !syncing;

  SyncStatus copyWith({
    int? pending,
    int? attention,
    bool? syncing,
    String? blocked,
    bool clearBlocked = false,
    DateTime? lastSyncedAt,
  }) =>
      SyncStatus(
        pending: pending ?? this.pending,
        attention: attention ?? this.attention,
        syncing: syncing ?? this.syncing,
        blocked: clearBlocked ? null : (blocked ?? this.blocked),
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      );
}
