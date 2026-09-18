import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/motion.dart';
import '../theme/palette.dart';
import '../theme/typography.dart';

/// "Swipe and let's go": a lime track with a round ink thumb. Dragging past
/// 85 % (or a long-press, or the semantics tap action) runs [onComplete];
/// the thumb shows a spinner while it awaits, then springs back.
class SlideToAct extends StatefulWidget {
  const SlideToAct({
    super.key,
    required this.label,
    required this.onComplete,
    this.enabled = true,
    this.icon = Icons.arrow_forward,
    this.disabledLabel,
  });

  final String label;
  final Future<void> Function() onComplete;
  final bool enabled;
  final IconData icon;

  /// Shown instead of [label] when disabled (e.g. "Full").
  final String? disabledLabel;

  @override
  State<SlideToAct> createState() => _SlideToActState();
}

class _SlideToActState extends State<SlideToAct> with SingleTickerProviderStateMixin {
  static const _height = 62.0;
  static const _thumb = 54.0;
  static const _pad = 4.0;

  double _x = 0; // thumb offset, 0..max
  double _max = 0;
  bool _busy = false;
  late final AnimationController _reset = AnimationController(vsync: this, duration: Motion.base);

  @override
  void dispose() {
    _reset.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    if (_busy || !widget.enabled) return;
    setState(() {
      _busy = true;
      _x = _max;
    });
    unawaited(HapticFeedback.mediumImpact());
    try {
      await widget.onComplete();
    } finally {
      if (mounted) _snapBack();
    }
  }

  void _snapBack() {
    final from = _x;
    final anim = CurvedAnimation(parent: _reset, curve: Motion.enter);
    void tick() => setState(() => _x = from * (1 - anim.value));
    anim.addListener(tick);
    _reset.forward(from: 0).whenComplete(() {
      anim.removeListener(tick);
      if (mounted) {
        setState(() {
          _x = 0;
          _busy = false;
        });
      }
    });
  }

  void _onEnd() {
    if (_busy) return;
    if (_x >= _max * 0.85) {
      _complete();
    } else {
      _snapBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final enabled = widget.enabled && !_busy;
    final label = widget.enabled ? widget.label : (widget.disabledLabel ?? widget.label);
    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: label,
      onTap: widget.enabled ? _complete : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _max = constraints.maxWidth - _thumb - _pad * 2;
          final progress = _max == 0 ? 0.0 : (_x / _max).clamp(0.0, 1.0);
          return GestureDetector(
            onHorizontalDragUpdate: enabled
                ? (d) => setState(() => _x = (_x + d.delta.dx).clamp(0, _max))
                : null,
            onHorizontalDragEnd: enabled ? (_) => _onEnd() : null,
            onHorizontalDragCancel: enabled ? _onEnd : null,
            onLongPress: enabled ? _complete : null,
            child: Container(
              height: _height,
              decoration: BoxDecoration(
                color: widget.enabled ? p.lime : p.surfaceTint,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Fill trails the thumb.
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: _x + _thumb + _pad * 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: p.limeDeep.withValues(alpha: 0.35 * progress),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: _thumb),
                      child: Opacity(
                        opacity: (1 - progress * 1.6).clamp(0.0, 1.0),
                        child: Text(
                          label,
                          style: AppType.label.copyWith(
                            fontSize: 15,
                            color: widget.enabled ? p.onLime : p.faint,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: _pad + _x,
                    child: Container(
                      width: _thumb,
                      height: _thumb,
                      decoration: BoxDecoration(
                        color: widget.enabled ? p.strong : p.faint,
                        shape: BoxShape.circle,
                      ),
                      child: _busy
                          ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: CircularProgressIndicator(strokeWidth: 2.4, color: p.onInk),
                            )
                          : Icon(widget.icon, color: p.onInk, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
