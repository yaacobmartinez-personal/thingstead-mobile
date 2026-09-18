import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/motion.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/ui/pill_button.dart';
import '../../checkin/domain/scan_feedback.dart';

/// The outcome sheet at the bottom of the scanner: a status disc, the title
/// and detail, and "Scan next". Slides up and the disc pops.
class ScanResultCard extends ConsumerWidget {
  const ScanResultCard({super.key, required this.feedback, required this.onNext});

  final ScanFeedback feedback;
  final VoidCallback onNext;

  static Color toneColor(BuildContext context, FeedbackTone tone) => switch (tone) {
        FeedbackTone.success => context.palette.success,
        FeedbackTone.warn => context.palette.warn,
        FeedbackTone.danger => context.palette.danger,
      };

  static IconData toneIcon(FeedbackTone tone) => switch (tone) {
        FeedbackTone.success => Icons.check,
        FeedbackTone.warn => Icons.priority_high,
        FeedbackTone.danger => Icons.close,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final animate = ref.watch(motionSettingsProvider);
    final color = toneColor(context, feedback.tone);
    Widget disc = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(toneIcon(feedback.tone), color: Colors.white, size: 30),
    );
    if (animate) {
      disc = disc.animate().scale(
            begin: const Offset(0.4, 0.4),
            end: const Offset(1, 1),
            duration: Motion.slow,
            curve: Motion.bounce,
          );
    }
    final card = Container(
      padding: const EdgeInsets.all(Spacing.gutter),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(Radii.sheet),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              disc,
              const SizedBox(width: Spacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feedback.title, style: AppType.title.copyWith(color: color, fontSize: 22)),
                    if (feedback.detail != null)
                      Text(feedback.detail!, style: AppType.body.copyWith(color: p.muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.x4),
          PillButton(label: 'Scan next', icon: Icons.qr_code_scanner, onPressed: onNext),
        ],
      ),
    );
    if (!animate) return card;
    return card.animate().fadeIn(duration: Motion.base).slideY(begin: 0.3, end: 0, curve: Motion.enter);
  }
}
