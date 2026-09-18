import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'motion.g.dart';

/// Durations and curves from docs/REDESIGN.md §2. Everything animated in
/// the app takes its timing from here.
abstract final class Motion {
  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
  static const hero = Duration(milliseconds: 500);
  static const countUp = Duration(milliseconds: 600);

  /// Gap between successive items in a staggered list entrance.
  static const stagger = Duration(milliseconds: 40);

  static const enter = Curves.easeOutCubic;
  static const move = Curves.easeInOutCubicEmphasized;
  static const bounce = Curves.easeOutBack;
}

/// Whether looping and decorative animation should run. Off when the OS
/// asks for reduced motion (or animations are disabled), and forced off in
/// tests so `pumpAndSettle` never waits on a pulse.
@Riverpod(keepAlive: true)
class MotionSettings extends _$MotionSettings {
  @override
  bool build() {
    final platform = SchedulerBinding.instance.platformDispatcher;
    final reduced = platform.accessibilityFeatures.reduceMotion ||
        platform.accessibilityFeatures.disableAnimations;
    return !reduced;
  }

  /// `true` = animate freely; `false` = reduced motion.
  void set(bool enabled) => state = enabled;
}

/// Convenience for the `flutter_animate` helpers: a stagger delay for the
/// [index]th item, capped so long lists don't wait forever.
Duration staggerDelay(int index, {int cap = 12}) =>
    Motion.stagger * (index < cap ? index : cap);

/// Common entrance: fade + rise. Used by lists and sheet content.
extension EntranceX on Widget {
  Widget enter({Duration delay = Duration.zero, bool enabled = true}) {
    if (!enabled) return this;
    return animate(delay: delay)
        .fadeIn(duration: Motion.base, curve: Motion.enter)
        .slideY(begin: 0.08, end: 0, duration: Motion.slow, curve: Motion.enter);
  }
}
