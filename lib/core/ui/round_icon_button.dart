import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// The floating circle button from the reference (back, skip, close, menu):
/// a 40 px white disc on light, ink on [dark], inside a 48 px hit target.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.dark = false,
    this.size = 40,
    this.badge,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  /// Ink disc with pale icon — for use over light images.
  final bool dark;
  final double size;

  /// A small count pill on the top-right corner.
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bg = dark ? p.strong : p.surface;
    final fg = dark ? p.onInk : p.ink;
    final button = Material(
      color: bg,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: size * 0.5, color: onPressed == null ? p.faint : fg),
        ),
      ),
    );
    final decorated = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: p.shadow, blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: button,
    );
    final withBadge = badge == null
        ? decorated
        : Stack(
            clipBehavior: Clip.none,
            children: [
              decorated,
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: p.lime,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(color: p.onLime, fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          );
    // Taps in the ring outside the disc still count (48 px minimum target).
    final hit = math.max(size, 48.0);
    final target = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: SizedBox(width: hit, height: hit, child: Center(child: withBadge)),
    );
    return tooltip == null ? target : Tooltip(message: tooltip!, child: target);
  }
}
