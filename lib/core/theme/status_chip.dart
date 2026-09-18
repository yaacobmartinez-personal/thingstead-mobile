import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'spacing.dart';

enum ChipTone { success, danger, warn, muted, navy }

/// A soft pill label for statuses: Published, Checked in, Waitlist.
/// Same look as the Expo app's statusChip helper.
class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key, this.tone = ChipTone.muted});

  final String label;
  final ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      ChipTone.success => (AppColors.successBg, AppColors.success),
      ChipTone.danger => (AppColors.dangerBg, AppColors.danger),
      ChipTone.warn => (AppColors.warnBg, AppColors.warn),
      ChipTone.navy => (AppColors.navy, AppColors.onNavy),
      ChipTone.muted => (AppColors.neutralBg, AppColors.muted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x2,
        vertical: Spacing.x1,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
