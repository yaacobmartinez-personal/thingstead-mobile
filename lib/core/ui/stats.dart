import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/motion.dart';
import '../theme/palette.dart';
import '../theme/typography.dart';

/// A big numeral that counts up on first appearance, with a caption.
class StatCounter extends ConsumerWidget {
  const StatCounter({
    super.key,
    required this.value,
    required this.label,
    this.suffix,
    this.color,
    this.small = false,
  });

  final int value;
  final String label;

  /// e.g. " / 40" after the number.
  final String? suffix;
  final Color? color;
  final bool small;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final animate = ref.watch(motionSettingsProvider);
    final style = (small ? AppType.numeralSmall : AppType.numeral).copyWith(color: color ?? p.ink);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: animate ? 0 : value.toDouble(), end: value.toDouble()),
          duration: animate ? Motion.countUp : Duration.zero,
          curve: Motion.enter,
          builder: (context, v, _) => RichText(
            text: TextSpan(
              text: '${v.round()}',
              style: style,
              children: [
                if (suffix != null)
                  TextSpan(
                    text: suffix,
                    style: style.copyWith(color: p.faint, fontSize: style.fontSize! * 0.6),
                  ),
              ],
            ),
          ),
        ),
        Text(label.toUpperCase(), style: AppType.caption.copyWith(color: p.faint, fontSize: 11)),
      ],
    );
  }
}

/// A ring that sweeps to [value] (0..1) on load, with [child] in the middle.
class ProgressRing extends ConsumerWidget {
  const ProgressRing({
    super.key,
    required this.value,
    this.size = 48,
    this.stroke = 5,
    this.color,
    this.child,
  });

  final double value;
  final double size;
  final double stroke;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final animate = ref.watch(motionSettingsProvider);
    final v = value.clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: animate ? 0 : v, end: v),
      duration: animate ? Motion.countUp : Duration.zero,
      curve: Motion.enter,
      builder: (context, t, _) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(t, stroke, color ?? p.limeDeep, p.surfaceTint),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.t, this.stroke, this.color, this.track);

  final double t;
  final double stroke;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = rect.deflate(stroke / 2);
    final bg = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(r, 0, math.pi * 2, false, bg);
    if (t > 0) canvas.drawArc(r, -math.pi / 2, math.pi * 2 * t, false, fg);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.t != t || old.color != color || old.track != track || old.stroke != stroke;
}
