import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/motion.dart';

/// Wraps a list item so it fades and rises into place, [index] × 40 ms after
/// the previous one. No-op under reduced motion.
class Enter extends ConsumerWidget {
  const Enter({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animate = ref.watch(motionSettingsProvider);
    return child.enter(delay: staggerDelay(index), enabled: animate);
  }
}

/// A column whose children stagger in.
class StaggeredColumn extends StatelessWidget {
  const StaggeredColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisSize = MainAxisSize.min,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: [for (final (i, c) in children.indexed) Enter(index: i, child: c)],
      );
}
