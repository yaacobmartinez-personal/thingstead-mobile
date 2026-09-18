import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/storage/boot_data.dart';
import '../../../core/storage/prefs.dart';

part 'appearance_controller.g.dart';

/// Light, dark, or follow the system. Read at boot so the first frame is
/// already the right theme.
@Riverpod(keepAlive: true)
class AppearanceController extends _$AppearanceController {
  @override
  ThemeMode build() => parse(ref.watch(bootDataProvider).appearance);

  static ThemeMode parse(String? raw) => switch (raw) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  void set(ThemeMode mode) {
    if (state == mode) return;
    state = mode;
    ref.read(prefsProvider).setString(
          Prefs.keyAppearance,
          mode == ThemeMode.system ? null : mode.name,
        );
  }
}
