import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/motion.dart';
import '../theme/palette.dart';
import '../theme/spacing.dart';

/// Shimmer placeholders while a list loads. The shimmer is a loop, so it
/// only runs when motion is allowed.
class Skeleton extends ConsumerWidget {
  const Skeleton.box({super.key, this.width, this.height = 16, this.radius = Radii.sm})
      : rows = 0;

  /// A stack of [rows] card-shaped placeholders.
  const Skeleton.cards({super.key, this.rows = 3, this.height = 96, this.radius = Radii.card})
      : width = null;

  final double? width;
  final double height;
  final double radius;
  final int rows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final animate = ref.watch(motionSettingsProvider);
    Widget block({double? w, required double h}) {
      final box = Container(
        width: w,
        height: h,
        decoration: BoxDecoration(color: p.surfaceTint, borderRadius: BorderRadius.circular(radius)),
      );
      if (!animate) return box;
      return box
          .animate(onPlay: (c) => c.repeat())
          .shimmer(duration: 1400.ms, color: p.surface.withValues(alpha: 0.7));
    }

    if (rows == 0) return block(w: width, h: height);
    return Column(
      children: [
        for (var i = 0; i < rows; i++) ...[
          if (i > 0) const SizedBox(height: Spacing.x3),
          block(h: height),
        ],
      ],
    );
  }
}
