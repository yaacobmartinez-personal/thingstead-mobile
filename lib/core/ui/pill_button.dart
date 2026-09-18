import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/motion.dart';
import '../theme/palette.dart';
import '../theme/typography.dart';

enum PillVariant { primary, strong, ghost, danger, subtle }

/// The pill button (docs/REDESIGN.md §1.5): lime with ink text for the main
/// action, ink for a strong secondary, white ghost, danger for destructive.
/// Presses scale to 0.97 with a light haptic; [loading] swaps the label for
/// a spinner without changing the width.
class PillButton extends StatefulWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = PillVariant.primary,
    this.loading = false,
    this.expanded = true,
    this.height = 52,
    this.compact = false,
    this.trailingIcon = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PillVariant variant;
  final bool loading;

  /// Full width (default) or hug the label.
  final bool expanded;
  final double height;

  /// Smaller text and padding for inline use.
  final bool compact;

  /// Put the icon after the label ("Next →").
  final bool trailingIcon;

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  bool _down = false;

  bool get _enabled => widget.onPressed != null && !widget.loading;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final (Color bg, Color fg) = switch (widget.variant) {
      PillVariant.primary => (p.lime, p.onLime),
      PillVariant.strong => (p.strong, p.onInk),
      PillVariant.ghost => (p.surface, p.ink),
      PillVariant.subtle => (p.surfaceTint, p.ink),
      PillVariant.danger => (p.dangerBg, p.danger),
    };
    final disabledBg = p.surfaceTint;
    final disabledFg = p.faint;
    final enabled = _enabled;
    final height = widget.compact ? 40.0 : widget.height;
    final textStyle = AppType.label.copyWith(
      fontSize: widget.compact ? 13 : 15,
      color: enabled ? fg : disabledFg,
    );

    final child = Row(
      mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.loading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.2, color: fg),
          )
        else ...[
          if (widget.icon != null && !widget.trailingIcon) ...[
            Icon(widget.icon, size: widget.compact ? 16 : 20, color: enabled ? fg : disabledFg),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              widget.label,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.icon != null && widget.trailingIcon) ...[
            const SizedBox(width: 8),
            Icon(widget.icon, size: widget.compact ? 16 : 20, color: enabled ? fg : disabledFg),
          ],
        ],
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: Motion.fast,
        curve: Curves.easeOut,
        child: Material(
          color: enabled || widget.loading ? bg : disabledBg,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled
                ? () {
                    HapticFeedback.lightImpact();
                    widget.onPressed!();
                  }
                : null,
            onHighlightChanged: (v) => setState(() => _down = v && enabled),
            child: Container(
              height: height,
              padding: EdgeInsets.symmetric(horizontal: widget.compact ? 16 : 24),
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
