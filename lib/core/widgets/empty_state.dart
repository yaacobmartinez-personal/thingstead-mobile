import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/spacing.dart';

/// Centered icon + title + optional hint, used when a list has nothing to show.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.hint,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? hint;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.x8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.faint),
            const SizedBox(height: Spacing.x3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            if (hint != null) ...[
              const SizedBox(height: Spacing.x1),
              Text(
                hint!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: Spacing.x4),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
