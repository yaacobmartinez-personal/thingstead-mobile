import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/connectivity/connectivity_provider.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../../../../core/util/checkin_code.dart';
import '../../checkin/application/sync_controller.dart';
import '../../checkin/data/checkin_queue.dart';
import '../../checkin/data/offline_resolver.dart';
import '../../checkin/domain/scan_feedback.dart';
import '../../checkin/domain/scan_result.dart';
import '../../events/application/events_controller.dart';
import '../../local_cache.dart';
import '../../organizer_providers.dart';

part 'scanner_controller.g.dart';

enum ScannerPhase { scanning, busy, result }

class ScannerState {
  const ScannerState({
    this.phase = ScannerPhase.scanning,
    this.feedback,
    this.lastResult,
    this.scanned = 0,
  });

  final ScannerPhase phase;
  final ScanFeedback? feedback;
  final ScanResult? lastResult;

  /// Successful check-ins this session, for the little counter.
  final int scanned;

  bool get accepting => phase == ScannerPhase.scanning;

  ScannerState copyWith({
    ScannerPhase? phase,
    ScanFeedback? feedback,
    ScanResult? lastResult,
    int? scanned,
    bool clearFeedback = false,
  }) =>
      ScannerState(
        phase: phase ?? this.phase,
        feedback: clearFeedback ? null : (feedback ?? this.feedback),
        lastResult: clearFeedback ? null : (lastResult ?? this.lastResult),
        scanned: scanned ?? this.scanned,
      );
}

/// One scanning session for an org (optionally pinned to one event).
/// Guards against the camera reporting the same QR many times while a
/// request is in flight — port of the `lock` ref in the Expo ScannerScreen.
///
/// Offline (or when the server cannot be reached) the scan is decided
/// against the local cache and queued for replay; see [OfflineResolver].
@riverpod
class ScannerController extends _$ScannerController {
  @override
  ScannerState build(String org, String? eventSlug) => const ScannerState();

  Future<void> submit(String code, {String? zone}) async {
    if (!state.accepting || code.trim().isEmpty) return;
    state = state.copyWith(phase: ScannerPhase.busy);

    ScanFeedback feedback;
    ScanResult? result;
    try {
      result = ref.read(isOnlineProvider) ? await _online(code) : await _offline(code);
      feedback = ScanFeedback.fromResult(result, zone: zone);
    } on ApiError catch (e) {
      feedback = ScanFeedback.failure(e.message);
    } catch (_) {
      feedback = ScanFeedback.failure('Try again.');
    }
    if (!ref.mounted) return;
    state = state.copyWith(
      phase: ScannerPhase.result,
      feedback: feedback,
      lastResult: result,
      scanned: state.scanned + (result?.outcome == CheckInOutcome.checkedIn ? 1 : 0),
    );
  }

  Future<ScanResult> _online(String code) async {
    final ScanResult r;
    try {
      r = await ref.read(checkinRepositoryProvider).scan(org, code, eventSlug: eventSlug);
    } on ApiError catch (e) {
      if (e.isNetwork || e.status >= 500) return _offline(code);
      rethrow;
    }
    if (r.outcome == CheckInOutcome.checkedIn || r.outcome == CheckInOutcome.already) {
      final token = extractCheckInToken(code);
      if (token != null) {
        await ref.read(localCacheProvider).setCheckedInByToken(org, token, r.at);
      }
    }
    if (r.outcome == CheckInOutcome.checkedIn) ref.invalidate(orgEventsProvider(org));
    return r;
  }

  Future<ScanResult> _offline(String code) async {
    final token = extractCheckInToken(code);
    if (token == null) return const ScanResult(outcome: CheckInOutcome.invalid, offline: true);

    final cache = ref.read(localCacheProvider);
    final row = await cache.attendeeByToken(org, token);
    final decision = OfflineResolver.resolve(
      row: row,
      pinnedEvent: eventSlug,
      hasOpenCheckIn: row == null ? false : await cache.hasOpenCheckIn(org, row.id),
      now: ref.read(clockProvider)(),
    );
    if (decision.markLocal && row != null) {
      await cache.setCheckedIn(org, row.id, decision.result.at);
    }
    if (decision.enqueue) {
      await ref.read(checkinQueueProvider).enqueueScan(
            org: org,
            event: eventSlug ?? row?.eventSlug,
            code: code,
            registrationId: row?.id,
            name: row?.name,
          );
      unawaited(ref.read(syncControllerProvider.notifier).kick());
    }
    return decision.result;
  }

  void scanNext() => state = state.copyWith(phase: ScannerPhase.scanning, clearFeedback: true);
}
