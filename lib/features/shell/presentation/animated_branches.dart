import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/motion.dart';

/// Renders a shell's branch navigators stacked, cross-fading (with a small
/// rise) to the current one, and keeping the others alive but inert — the
/// fade-through feel between tabs without losing each tab's stack.
class AnimatedBranches extends StatelessWidget {
  const AnimatedBranches({super.key, required this.shell, required this.children});

  final StatefulNavigationShell shell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final current = shell.currentIndex;
    return Stack(
      fit: StackFit.expand,
      children: [
        for (final (i, child) in children.indexed)
          _Branch(active: i == current, child: child),
      ],
    );
  }
}

class _Branch extends StatelessWidget {
  const _Branch({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TickerMode sits inside the fade so muting the inactive branch's own
    // animations never freezes the fade itself.
    return IgnorePointer(
      ignoring: !active,
      child: AnimatedOpacity(
        opacity: active ? 1 : 0,
        duration: Motion.base,
        curve: Motion.enter,
        child: AnimatedSlide(
          offset: active ? Offset.zero : const Offset(0, 0.02),
          duration: Motion.base,
          curve: Motion.enter,
          child: TickerMode(enabled: active, child: child),
        ),
      ),
    );
  }
}
