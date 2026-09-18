import 'dart:async';

/// Where scanned codes come from. The camera in the app; a controllable
/// stream in tests, so the scanner screen and controller can be exercised
/// without hardware.
abstract class ScanSource {
  Stream<String> get codes;
  Future<void> start();
  Future<void> stop();
  void dispose();
}

/// Test double and manual-entry source: push codes by hand.
class ManualScanSource implements ScanSource {
  final _controller = StreamController<String>.broadcast();
  bool started = false;

  @override
  Stream<String> get codes => _controller.stream;

  void emit(String code) => _controller.add(code);

  @override
  Future<void> start() async => started = true;

  @override
  Future<void> stop() async => started = false;

  @override
  void dispose() => _controller.close();
}
