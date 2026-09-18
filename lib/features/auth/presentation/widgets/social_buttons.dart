import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';

/// "Continue with Google" and, on iOS, "Continue with Apple" (Apple's rule
/// 4.8: offering any other social login means offering theirs too).
class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
    required this.busy,
    required this.showApple,
    required this.onGoogle,
    required this.onApple,
  });

  final bool busy;
  final bool showApple;
  final VoidCallback onGoogle;
  final VoidCallback onApple;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: busy ? null : onGoogle,
          icon: const _GoogleMark(),
          label: const Text('Continue with Google'),
        ),
        if (showApple) ...[
          const SizedBox(height: Spacing.x3),
          FilledButton.icon(
            onPressed: busy ? null : onApple,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.apple, size: 22),
            label: const Text('Continue with Apple'),
          ),
        ],
      ],
    );
  }
}

/// A simple four-colour "G" so the button reads as Google without shipping
/// the official asset.
class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
        color: Colors.white,
      ),
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF4285F4),
        ),
      ),
    );
  }
}
