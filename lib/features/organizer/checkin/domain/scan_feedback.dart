import '../../../../core/time/app_time.dart';
import 'scan_result.dart';

enum FeedbackTone { success, warn, danger }

/// What the result card says. Port of `toFeedback` in the Expo ScannerScreen.
class ScanFeedback {
  const ScanFeedback({required this.tone, required this.title, this.detail});

  final FeedbackTone tone;
  final String title;
  final String? detail;

  static ScanFeedback fromResult(ScanResult r, {String? zone}) {
    final name = r.name ?? 'Attendee';
    final offlineTag = r.offline ? ' (offline)' : '';
    return switch (r.outcome) {
      CheckInOutcome.checkedIn => ScanFeedback(
          tone: FeedbackTone.success,
          title: 'Checked in$offlineTag',
          detail: name,
        ),
      CheckInOutcome.already => ScanFeedback(
          tone: FeedbackTone.warn,
          title: '$name is already in',
          detail: r.at == null ? null : 'Checked in at ${AppTime.formatTime(r.at!, zone)}',
        ),
      CheckInOutcome.wrongEvent => ScanFeedback(
          tone: FeedbackTone.danger,
          title: 'Wrong event',
          detail: r.eventTitle == null ? name : 'This ticket is for ${r.eventTitle}',
        ),
      CheckInOutcome.cancelled => ScanFeedback(
          tone: FeedbackTone.danger,
          title: 'Place cancelled',
          detail: name,
        ),
      CheckInOutcome.waitlist => ScanFeedback(
          tone: FeedbackTone.warn,
          title: 'On the waitlist',
          detail: "$name isn't confirmed",
        ),
      CheckInOutcome.invalid => const ScanFeedback(
          tone: FeedbackTone.danger,
          title: 'Not a valid ticket',
          detail: 'Nothing matched that code',
        ),
      CheckInOutcome.queuedUnverified => const ScanFeedback(
          tone: FeedbackTone.warn,
          title: 'Queued',
          detail: 'Will confirm when back online',
        ),
    };
  }

  static ScanFeedback failure(String message) =>
      ScanFeedback(tone: FeedbackTone.danger, title: "Couldn't check in", detail: message);
}
