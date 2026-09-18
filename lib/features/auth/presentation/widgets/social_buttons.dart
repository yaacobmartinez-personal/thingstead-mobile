import 'package:flutter/material.dart';

import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// "Continue with Google" and, on iOS, "Continue with Apple" (Apple's rule
/// 4.8: offering any other social login means offering theirs too). Ghost
/// pills on the white card, so they sit on a tinted fill.
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
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: busy ? null : onGoogle,
          style: OutlinedButton.styleFrom(backgroundColor: p.surfaceTint),
          icon: const _GoogleMark(),
          label: const Text('Continue with Google'),
        ),
        if (showApple) ...[
          const SizedBox(height: Spacing.x3),
          FilledButton.icon(
            onPressed: busy ? null : onApple,
            style: FilledButton.styleFrom(
              backgroundColor: p.strong,
              foregroundColor: p.onInk,
            ),
            icon: const Icon(Icons.apple, size: 22),
            label: const Text('Continue with Apple'),
          ),
        ],
      ],
    );
  }
}

/// A simple "G" so the button reads as Google without shipping the official
/// asset.
class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Text(
        'G',
        style: AppType.label.copyWith(fontSize: 13, color: const Color(0xFF4285F4)),
      ),
    );
  }
}
