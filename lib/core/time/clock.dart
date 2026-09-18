import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

/// "Now", injectable so tests can pin time for expiry, DST, and "started"
/// checks.
typedef Clock = DateTime Function();

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => () => DateTime.now().toUtc();
