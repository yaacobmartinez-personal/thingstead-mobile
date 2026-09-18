import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/widgets/empty_state.dart';

/// Stand-in for a screen that a later phase implements. Keeps the router and
/// shells runnable while features land one at a time.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.phase,
    this.icon = Icons.construction,
    this.trailing,
  });

  final String title;
  final String phase;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Expanded(
            child: EmptyState(
              icon: icon,
              title: title,
              hint: 'Coming in $phase',
            ),
          ),
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.x4),
              child: trailing!,
            ),
        ],
      ),
    );
  }
}
