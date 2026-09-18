import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/connectivity/connectivity_provider.dart';
import '../../../../core/storage/db/app_database.dart';
import '../../../../core/time/clock.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/application/auth_state.dart';
import '../../events/application/events_controller.dart';
import '../../organizer_providers.dart';
import '../data/sync_worker.dart';
import '../domain/sync_status.dart';

part 'sync_controller.g.dart';

/// Drives the offline queue: counts for the badge, and drains whenever
/// something suggests the server is reachable again — connectivity comes
/// back, the app resumes, an op is enqueued, or a minute passes with work
/// still pending. Also wipes local data when the session ends.
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController with WidgetsBindingObserver {
  SyncWorker? _worker;
  StreamSubscription<List<PendingCheckin>>? _opsSub;
  Timer? _timer;

  @override
  SyncStatus build() {
    final db = ref.watch(appDatabaseProvider);
    _worker = SyncWorker(
      db,
      ref.watch(checkinRepositoryProvider),
      ref.watch(clockProvider),
    );

    _opsSub = db.watchOpenOps().listen((ops) {
      var pending = 0;
      var attention = 0;
      for (final op in ops) {
        if (op.state == AppDatabase.stateAttention) {
          attention++;
        } else {
          pending++;
        }
      }
      state = state.copyWith(pending: pending, attention: attention);
      _armTimer();
    });

    ref.listen<bool>(isOnlineProvider, (prev, next) {
      if (next && prev != true) kick();
    });
    ref.listen<AuthState>(authControllerProvider, (prev, next) {
      if (next is SignedIn && prev is! SignedIn) {
        kick();
      } else if (next is SignedOut && prev is SignedIn) {
        _onSignedOut(next.reason);
      }
    });

    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _opsSub?.cancel();
      _timer?.cancel();
    });
    return SyncStatus.idle;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) kick();
  }

  void _armTimer() {
    _timer?.cancel();
    if (state.pending > 0) {
      _timer = Timer(const Duration(seconds: 60), kick);
    }
  }

  /// Try to drain now. Safe to call often; the worker is single-flight.
  Future<void> kick() async {
    final worker = _worker;
    if (worker == null || worker.draining) return;
    if (!ref.read(authControllerProvider).isSignedIn) return;
    if (!ref.read(isOnlineProvider)) return;

    state = state.copyWith(syncing: true, clearBlocked: true);
    final result = await worker.drain();
    if (!ref.mounted) return;
    state = state.copyWith(
      syncing: false,
      blocked: switch (result.stop) {
        DrainStop.forbidden => 'membership',
        DrainStop.unauthorized => 'signedOut',
        _ => null,
      },
      clearBlocked: result.stop == DrainStop.none || result.stop == DrainStop.transport,
      lastSyncedAt: result.synced > 0 ? ref.read(clockProvider)() : null,
    );
    if (result.synced > 0) ref.invalidate(orgEventsProvider);
    _armTimer();
  }

  Future<void> _onSignedOut(SignOutReason? reason) async {
    final db = ref.read(appDatabaseProvider);
    // A session that simply expired keeps the queue so a re-login can finish
    // syncing; a deliberate sign-out takes everything with it.
    if (reason == SignOutReason.sessionExpired) {
      await db.wipeCaches();
    } else {
      await db.wipeAll();
    }
  }
}
