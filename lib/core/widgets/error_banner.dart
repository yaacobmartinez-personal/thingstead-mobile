import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/spacing.dart';

/// Inline error with an optional Retry, shown above stale content rather than
/// replacing it (the Expo screens keep the previous list visible).
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Spacing.x4),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x4,
        vertical: Spacing.x3,
      ),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
          const SizedBox(width: Spacing.x2),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}
