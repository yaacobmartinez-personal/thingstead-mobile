import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/shell/application/app_mode_controller.dart';
import '../../features/shell/presentation/attendee_shell.dart';
import '../../features/shell/presentation/mode_switch_tile.dart';
import '../../features/shell/presentation/organizer_shell.dart';
import '../../features/shell/presentation/placeholder_screen.dart';
import 'router_refresh.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// Two independent bottom-nav shells (attendee `/a`, organizer `/o`) plus the
/// auth stack. Each shell keeps its own tab state via `indexedStack`.
///
/// Guards (auth, organizer access, role, feature gates) are added to
/// [_redirect] in Phase 1; Phase 0 only needs the skeleton to render.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  final initialMode = ref.read(appModeControllerProvider);

  return GoRouter(
    initialLocation: initialMode.home,
    refreshListenable: refresh,
    debugLogDiagnostics: false,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      // ---- attendee shell ---------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AttendeeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.attendeeEvents,
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Find events',
                  phase: 'Phase 5',
                  icon: Icons.search,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.attendeeTickets,
                builder: (context, state) => const PlaceholderScreen(
                  title: 'My tickets',
                  phase: 'Phase 5',
                  icon: Icons.confirmation_number_outlined,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.attendeeAccount,
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Account',
                  phase: 'Phase 1',
                  icon: Icons.person_outline,
                  trailing: ModeSwitchTile(target: AppMode.organizer),
                ),
              ),
            ],
          ),
        ],
      ),

      // ---- organizer shell --------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            OrganizerShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.orgEvents,
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Events',
                  phase: 'Phase 2',
                  icon: Icons.event_note_outlined,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.orgScan,
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Scan check-in',
                  phase: 'Phase 2',
                  icon: Icons.qr_code_scanner,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.orgTeam,
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Team',
                  phase: 'Phase 4',
                  icon: Icons.group_outlined,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.orgSettings,
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Settings',
                  phase: 'Phase 1',
                  icon: Icons.settings_outlined,
                  trailing: ModeSwitchTile(target: AppMode.attendee),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

String? _redirect(Ref ref, GoRouterState state) {
  // Phase 1 adds: booting -> splash, auth-required routes -> login, organizer
  // routes without access -> attendee home, org selection, role and feature
  // gates. Nothing to enforce yet.
  return null;
}
