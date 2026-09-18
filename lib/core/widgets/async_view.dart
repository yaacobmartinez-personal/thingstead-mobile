import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_error.dart';
import 'error_banner.dart';

/// Renders an [AsyncValue]: a spinner on first load, an [ErrorBanner] with
/// Retry on failure, and — on a refresh error — the banner above the stale
/// data instead of throwing the data away.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? loading;

  static String messageFor(Object error) =>
      error is ApiError ? error.message : 'Something went wrong. Try again.';

  @override
  Widget build(BuildContext context) {
    final stale = value.hasValue ? value.value : null;
    final error = value.hasError ? value.error : null;

    if (stale != null || (value.hasValue && !value.isLoading)) {
      final body = data(value.requireValue);
      if (error == null) return body;
      return Column(
        children: [
          ErrorBanner(message: messageFor(error), onRetry: onRetry),
          Expanded(child: body),
        ],
      );
    }
    if (error != null) {
      return Center(
        child: ErrorBanner(message: messageFor(error), onRetry: onRetry),
      );
    }
    return loading ?? const Center(child: CircularProgressIndicator());
  }
}
