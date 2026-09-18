import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_error.dart';
import '../../checkin/domain/scan_feedback.dart';
import '../../checkin/domain/scan_result.dart';
import '../../events/application/events_controller.dart';
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
      result = await ref
          .read(checkinRepositoryProvider)
          .scan(org, code, eventSlug: eventSlug);
      feedback = ScanFeedback.fromResult(result, zone: zone);
      if (result.outcome == CheckInOutcome.checkedIn) {
        ref.invalidate(orgEventsProvider(org));
      }
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

  void scanNext() => state = state.copyWith(phase: ScannerPhase.scanning, clearFeedback: true);
}
