import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_error.dart';
import '../theme/motion.dart';
import '../theme/spacing.dart';
import '../ui/skeleton.dart';
import 'error_banner.dart';

/// Renders an [AsyncValue]: a skeleton on first load, an [ErrorBanner] with
/// Retry on failure, and — on a refresh error — the banner above the stale
/// data instead of throwing the data away. Content cross-fades in.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.loading,
    this.skeletonRows = 3,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  /// Custom loading widget; default is a card skeleton.
  final Widget? loading;
  final int skeletonRows;

  static String messageFor(Object error) =>
      error is ApiError ? error.message : 'Something went wrong. Try again.';

  @override
  Widget build(BuildContext context) {
    final stale = value.hasValue ? value.value : null;
    final error = value.hasError ? value.error : null;

    Widget child;
    if (stale != null || (value.hasValue && !value.isLoading)) {
      final body = data(value.requireValue);
      child = error == null
          ? body
          : Column(
              children: [
                ErrorBanner(message: messageFor(error), onRetry: onRetry),
                Expanded(child: body),
              ],
            );
    } else if (error != null) {
      child = Center(child: ErrorBanner(message: messageFor(error), onRetry: onRetry));
    } else {
      child = loading ??
          Padding(
            padding: const EdgeInsets.all(Spacing.gutter),
            child: Skeleton.cards(rows: skeletonRows),
          );
    }
    return AnimatedSwitcher(
      duration: Motion.base,
      switchInCurve: Motion.enter,
      switchOutCurve: Curves.easeIn,
      layoutBuilder: (current, previous) => Stack(
        fit: StackFit.passthrough,
        children: [...previous, ?current],
      ),
      child: KeyedSubtree(key: ValueKey(value.hasValue), child: child),
    );
  }
}
