import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/application/auth_state.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import '../../features/shell/application/app_mode_controller.dart';

/// Bridges Riverpod state into GoRouter's `refreshListenable` so redirects
/// re-run when the session or the mode changes.
class RouterRefresh extends ChangeNotifier {
  RouterRefresh(Ref ref) {
    ref.listen<AuthState>(authControllerProvider, (_, _) => notifyListeners());
    ref.listen<AppMode>(appModeControllerProvider, (_, _) => notifyListeners());
    ref.listen<bool>(onboardingSeenProvider, (_, _) => notifyListeners());
  }
}
