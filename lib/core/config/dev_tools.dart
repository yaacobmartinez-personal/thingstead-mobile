import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dev_tools.g.dart';

/// Whether developer affordances (the server address) are visible. On in
/// debug and profile builds; hidden in release until the version line in
/// Account/Settings is long-pressed, so support can still reach it without
/// it cluttering the app for everyone else.
@Riverpod(keepAlive: true)
class DevTools extends _$DevTools {
  @override
  bool build() => !kReleaseMode;

  void reveal() => state = true;
}
