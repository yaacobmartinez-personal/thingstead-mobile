import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/motion.dart';
import '../theme/palette.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Inline error with an optional Retry, shown above stale content rather than
/// replacing it. Slides down into place.
class ErrorBanner extends ConsumerWidget {
  const ErrorBanner({super.key, required this.message, this.onRetry, this.margin});

  final String message;
  final VoidCallback? onRetry;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final animate = ref.watch(motionSettingsProvider);
    final banner = Container(
      margin: margin ?? const EdgeInsets.all(Spacing.gutter),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.x4, vertical: Spacing.x3),
      decoration: BoxDecoration(
        color: p.dangerBg,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: p.danger, size: 20),
          const SizedBox(width: Spacing.x2),
          Expanded(
            child: Text(message, style: AppType.small.copyWith(color: p.danger, fontWeight: FontWeight.w600)),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(foregroundColor: p.danger),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
    if (!animate) return banner;
    return banner.animate().fadeIn(duration: Motion.base).slideY(begin: -0.2, end: 0, curve: Motion.enter);
  }
}
