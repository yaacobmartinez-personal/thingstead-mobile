import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/motion.dart';
import '../theme/palette.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Centered illustration (or an icon on a lime disc) + title + optional hint
/// and action, used when a list has nothing to show. The visual floats
/// gently unless motion is reduced.
class EmptyState extends ConsumerWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.hint,
    this.action,
    this.asset,
  });

  final IconData icon;
  final String title;
  final String? hint;
  final Widget? action;

  /// An illustration asset path; falls back to [icon].
  final String? asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final animate = ref.watch(motionSettingsProvider);
    Widget visual = asset != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(Radii.card),
            child: Image.asset(asset!, width: 180, height: 180, fit: BoxFit.cover),
          )
        : Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(color: p.lime, shape: BoxShape.circle),
            child: Icon(icon, size: 38, color: p.onLime),
          );
    if (animate) {
      visual = visual
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: -4, end: 4, duration: 2200.ms, curve: Curves.easeInOutSine);
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.x8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            visual,
            const SizedBox(height: Spacing.x5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppType.heading.copyWith(color: p.ink),
            ),
            if (hint != null) ...[
              const SizedBox(height: Spacing.x2),
              Text(hint!, textAlign: TextAlign.center, style: AppType.body.copyWith(color: p.muted)),
            ],
            if (action != null) ...[const SizedBox(height: Spacing.x5), action!],
          ],
        ),
      ),
    );
  }
}
