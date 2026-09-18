import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../checkin/domain/scan_feedback.dart';

/// The coloured outcome card at the bottom of the scanner, with "Scan next".
class ScanResultCard extends StatelessWidget {
  const ScanResultCard({super.key, required this.feedback, required this.onNext});

  final ScanFeedback feedback;
  final VoidCallback onNext;

  static Color toneColor(FeedbackTone tone) => switch (tone) {
        FeedbackTone.success => AppColors.success,
        FeedbackTone.warn => AppColors.warn,
        FeedbackTone.danger => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.x5),
          decoration: BoxDecoration(
            color: toneColor(feedback.tone),
            borderRadius: BorderRadius.circular(Radii.lg),
          ),
          child: Column(
            children: [
              Text(
                feedback.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (feedback.detail != null) ...[
                const SizedBox(height: Spacing.x1),
                Text(
                  feedback.detail!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: Spacing.x3),
        FilledButton(
          onPressed: onNext,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.navyDark,
          ),
          child: const Text('Scan next'),
        ),
      ],
    );
  }
}
