import 'package:flutter/material.dart';

import 'palette.dart';
import 'spacing.dart';
import 'typography.dart';

enum ChipTone { success, danger, warn, muted, navy, lime }

/// A soft pill label for statuses: Published, Checked in, Waitlist. Reads the
/// palette so it follows dark mode. [dot] adds a leading status dot.
class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key, this.tone = ChipTone.muted, this.dot = false});

  final String label;
  final ChipTone tone;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final (bg, fg) = switch (tone) {
      ChipTone.success => (p.successBg, p.success),
      ChipTone.danger => (p.dangerBg, p.danger),
      ChipTone.warn => (p.warnBg, p.warn),
      ChipTone.navy => (p.strong, p.onInk),
      ChipTone.lime => (p.lime, p.onLime),
      ChipTone.muted => (p.surfaceTint, p.muted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.x3, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Radii.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.caption.copyWith(color: fg, letterSpacing: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
