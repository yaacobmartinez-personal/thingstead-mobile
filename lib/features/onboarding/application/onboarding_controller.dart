import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/storage/boot_data.dart';
import '../../../core/storage/prefs.dart';

part 'onboarding_controller.g.dart';

/// Whether the intro has been seen. Shown once on a fresh install; Account
/// can bring it back.
@Riverpod(keepAlive: true)
class OnboardingSeen extends _$OnboardingSeen {
  @override
  bool build() => ref.watch(bootDataProvider).onboardingSeen;

  void set(bool seen) {
    if (state == seen) return;
    state = seen;
    ref.read(prefsProvider).setString(Prefs.keyOnboardingSeen, seen ? 'true' : null);
  }
}
