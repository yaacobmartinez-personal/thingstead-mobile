import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/motion.dart';

/// Page transitions (docs/REDESIGN.md §2): shared-axis for pushes inside a
/// tab, fade-through for tab roots, a slide-up for sheet-like screens.

CustomTransitionPage<T> sharedAxisPage<T>({
  required GoRouterState state,
  required Widget child,
  SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
}) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: Motion.slow,
      reverseTransitionDuration: Motion.base,
      transitionsBuilder: (context, animation, secondary, child) => SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondary,
        transitionType: type,
        fillColor: Colors.transparent,
        child: child,
      ),
    );

CustomTransitionPage<T> fadeThroughPage<T>({required GoRouterState state, required Widget child}) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: Motion.base,
      transitionsBuilder: (context, animation, secondary, child) => FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondary,
        fillColor: Colors.transparent,
        child: child,
      ),
    );

CustomTransitionPage<T> slideUpPage<T>({required GoRouterState state, required Widget child}) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: Motion.slow,
      reverseTransitionDuration: Motion.base,
      transitionsBuilder: (context, animation, secondary, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero)
            .chain(CurveTween(curve: Motion.enter))
            .animate(animation),
        child: child,
      ),
    );
