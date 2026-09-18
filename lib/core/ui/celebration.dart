import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/motion.dart';
import '../theme/palette.dart';

/// The register/check-in success mark: a lime disc, a checkmark that draws
/// itself, and a burst of lime/coral dots. Drawn with a painter so nothing
/// else needs bundling. [icon] swaps the check for another glyph (hourglass
/// for "waitlisted") and skips the confetti.
class Celebration extends ConsumerStatefulWidget {
  const Celebration({super.key, this.size = 96, this.icon, this.color});

  final double size;
  final IconData? icon;
  final Color? color;

  @override
  ConsumerState<Celebration> createState() => _CelebrationState();
}

class _CelebrationState extends ConsumerState<Celebration> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  @override
  void initState() {
    super.initState();
    if (ref.read(motionSettingsProvider)) {
      _c.forward();
    } else {
      _c.value = 1;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = widget.color ?? p.success;
    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 1.4,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;
          final pop = Curves.easeOutBack.transform(t.clamp(0, 0.5) * 2);
          return CustomPaint(
            painter: widget.icon == null ? _BurstPainter(t, p.lime, const Color(0xFFF08A90)) : null,
            child: Center(
              child: Transform.scale(
                scale: pop,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(color: p.lime, shape: BoxShape.circle),
                  child: widget.icon != null
                      ? Icon(widget.icon, size: widget.size * 0.5, color: p.onLime)
                      : CustomPaint(
                          painter: _CheckPainter(
                            Curves.easeOutCubic.transform(((t - 0.35) / 0.4).clamp(0, 1)),
                            color,
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter(this.t, this.color);
  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0) return;
    final path = Path()
      ..moveTo(size.width * 0.28, size.height * 0.52)
      ..lineTo(size.width * 0.44, size.height * 0.68)
      ..lineTo(size.width * 0.72, size.height * 0.36);
    final metric = path.computeMetrics().first;
    final partial = metric.extractPath(0, metric.length * t);
    canvas.drawPath(
      partial,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.09
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.t != t;
}

class _BurstPainter extends CustomPainter {
  _BurstPainter(this.t, this.a, this.b);
  final double t;
  final Color a;
  final Color b;

  @override
  void paint(Canvas canvas, Size size) {
    if (t < 0.3) return;
    final k = Curves.easeOutCubic.transform(((t - 0.3) / 0.7).clamp(0, 1));
    final center = size.center(Offset.zero);
    final rnd = math.Random(7);
    for (var i = 0; i < 18; i++) {
      final angle = (i / 18) * math.pi * 2 + rnd.nextDouble() * 0.3;
      final dist = size.width * (0.22 + rnd.nextDouble() * 0.22) * k;
      final r = (2.5 + rnd.nextDouble() * 2.5) * (1 - k * 0.6);
      final pos = center + Offset(math.cos(angle), math.sin(angle)) * dist;
      canvas.drawCircle(pos, r, Paint()..color = (i.isEven ? a : b).withValues(alpha: 1 - k));
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.t != t;
}
