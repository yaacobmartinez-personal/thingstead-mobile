import 'dart:math';

/// Simulated network delay for fake repositories, so loading states and
/// optimistic updates are visible in development. Zero in tests.
class FakeLatency {
  const FakeLatency({
    this.min = const Duration(milliseconds: 250),
    this.max = const Duration(milliseconds: 600),
  });

  static const none = FakeLatency(min: Duration.zero, max: Duration.zero);

  final Duration min;
  final Duration max;

  static final _random = Random();

  Future<void> wait() {
    if (max == Duration.zero) return Future.value();
    final span = max.inMilliseconds - min.inMilliseconds;
    final ms = min.inMilliseconds + (span <= 0 ? 0 : _random.nextInt(span));
    return Future<void>.delayed(Duration(milliseconds: ms));
  }
}
