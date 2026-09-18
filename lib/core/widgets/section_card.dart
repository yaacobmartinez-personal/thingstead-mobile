import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/spacing.dart';

/// A white card with a heading and optional body text, for settings-style
/// screens. Port of the Expo `Card` + heading/body styles.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.heading,
    this.body,
    this.headingColor,
    this.borderColor,
    this.children = const [],
  });

  final String? heading;
  final String? body;
  final Color? headingColor;
  final Color? borderColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        side: BorderSide(color: borderColor ?? AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (heading != null)
              Text(
                heading!,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: headingColor ?? AppColors.text,
                ),
              ),
            if (body != null) ...[
              const SizedBox(height: Spacing.x1),
              Text(
                body!,
                style: const TextStyle(color: AppColors.muted, height: 1.4),
              ),
            ],
            if (children.isNotEmpty) ...[
              const SizedBox(height: Spacing.x3),
              ...children,
            ],
          ],
        ),
      ),
    );
  }
}
