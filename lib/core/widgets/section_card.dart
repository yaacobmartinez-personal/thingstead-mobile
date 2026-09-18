import 'package:flutter/material.dart';

import '../theme/palette.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// A white rounded card with a heading and optional body text, for
/// settings-style screens.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.heading,
    this.body,
    this.headingColor,
    this.borderColor,
    this.color,
    this.children = const [],
    this.padding,
  });

  final String? heading;
  final String? body;
  final Color? headingColor;

  /// Kept for the danger card; null = no border.
  final Color? borderColor;
  final Color? color;
  final List<Widget> children;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: color ?? p.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        border: borderColor == null ? null : Border.all(color: borderColor!, width: 1.5),
      ),
      padding: padding ?? const EdgeInsets.all(Spacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (heading != null)
            Text(heading!, style: AppType.heading.copyWith(color: headingColor ?? p.ink)),
          if (body != null) ...[
            const SizedBox(height: Spacing.x1),
            Text(body!, style: AppType.small.copyWith(color: p.muted)),
          ],
          if (children.isNotEmpty) ...[
            if (heading != null || body != null) const SizedBox(height: Spacing.x4),
            ...children,
          ],
        ],
      ),
    );
  }
}
