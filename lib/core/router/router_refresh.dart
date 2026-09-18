import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/shell/application/app_mode_controller.dart';

/// Bridges Riverpod state into GoRouter's `refreshListenable` so redirects
/// re-run when auth or mode changes. Auth is wired in here in Phase 1.
class RouterRefresh extends ChangeNotifier {
  RouterRefresh(Ref ref) {
    ref.listen<AppMode>(appModeControllerProvider, (_, _) => notifyListeners());
  }
}
