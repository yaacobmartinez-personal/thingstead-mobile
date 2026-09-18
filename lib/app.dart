import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/connectivity/connectivity_provider.dart';
import 'core/router/app_router.dart';
import 'core/router/deep_link_handler.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/application/appearance_controller.dart';

class ThingsteadApp extends ConsumerWidget {
  const ThingsteadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Start the connectivity stream now so the first offline decision is
    // based on a real reading rather than the optimistic default.
    ref.watch(connectivityProvider);
    final router = ref.watch(appRouterProvider);
    // Starts listening for links (cold start + while running).
    ref.watch(deepLinkHandlerProvider);
    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(appearanceControllerProvider),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
