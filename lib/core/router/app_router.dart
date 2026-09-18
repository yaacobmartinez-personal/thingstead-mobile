import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/attendee/account/presentation/account_screen.dart';
import '../../features/attendee/orgs/presentation/find_events_screen.dart';
import '../../features/attendee/orgs/presentation/org_events_screen.dart';
import '../../features/attendee/orgs/presentation/public_event_screen.dart';
import '../../features/attendee/tickets/presentation/import_ticket_screen.dart';
import '../../features/attendee/tickets/presentation/ticket_detail_screen.dart';
import '../../features/attendee/tickets/presentation/tickets_screen.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/check_email_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/verify_screen.dart';
import '../../features/organizer/attendees/presentation/attendees_screen.dart';
import '../../features/organizer/checkin/presentation/needs_attention_screen.dart';
import '../../features/organizer/events/presentation/event_detail_screen.dart';
import '../../features/organizer/events/presentation/event_form_screen.dart';
import '../../features/organizer/events/presentation/events_screen.dart';
import '../../features/organizer/orgs/presentation/org_picker_screen.dart';
import '../../features/organizer/scanner/presentation/scan_entry_screen.dart';
import '../../features/organizer/scanner/presentation/scanner_screen.dart';
import '../../features/organizer/settings/presentation/server_address_screen.dart';
import '../../features/organizer/settings/presentation/settings_screen.dart';
import '../../features/organizer/team/presentation/team_screen.dart';
import '../../features/shell/application/app_mode_controller.dart';
import '../../features/shell/presentation/attendee_shell.dart';
import '../../features/shell/presentation/organizer_shell.dart';
import 'guards.dart';
import 'router_refresh.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// Two independent bottom-nav shells (attendee `/a`, organizer `/o`), the
/// auth stack, and a few top-level screens. Each shell keeps its own tab
/// state via `indexedStack`. Redirect rules live in [computeRedirect].
///
/// Routes that must cover the bottom nav (the live scanner) push on the root
/// navigator via [rootNavigatorKey].
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  final auth = ref.read(authControllerProvider);
  final mode = ref.read(appModeControllerProvider);
  final initial = auth.isSignedIn ? mode.home : AppMode.attendee.home;

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initial,
    refreshListenable: refresh,
    debugLogDiagnostics: false,
    redirect: (context, state) => computeRedirect(
      uri: state.uri,
      auth: ref.read(authControllerProvider),
      mode: ref.read(appModeControllerProvider),
    ),
    routes: [
      // ---- auth stack -------------------------------------------------------
      GoRoute(
        path: Routes.login,
        builder: (context, state) =>
            LoginScreen(from: state.uri.queryParameters['from']),
      ),
      GoRoute(
        path: Routes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: Routes.checkEmail,
        builder: (context, state) =>
            CheckEmailScreen(email: state.uri.queryParameters['email']),
      ),
      GoRoute(
        path: Routes.verify,
        builder: (context, state) =>
            VerifyScreen(token: state.uri.queryParameters['token']),
      ),
      GoRoute(
        path: Routes.forgot,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.reset,
        builder: (context, state) =>
            ResetPasswordScreen(token: state.uri.queryParameters['token']),
      ),
      GoRoute(
        path: Routes.serverAddress,
        builder: (context, state) => const ServerAddressScreen(),
      ),

      // ---- attendee shell ---------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AttendeeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.attendeeEvents,
                builder: (context, state) => const FindEventsScreen(),
                routes: [
                  // Public org pages nest here so `go` builds Find → org →
                  // event and the back button always has somewhere to go.
                  GoRoute(
                    path: 'orgs/:org',
                    builder: (context, state) =>
                        OrgEventsScreen(orgSlug: state.pathParameters['org']!),
                    routes: [
                      GoRoute(
                        path: 'events/:event',
                        builder: (context, state) => PublicEventScreen(
                          orgSlug: state.pathParameters['org']!,
                          eventSlug: state.pathParameters['event']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.attendeeTickets,
                builder: (context, state) => const TicketsScreen(),
                routes: [
                  // Literal before the parameter so "import" is never an id.
                  GoRoute(
                    path: 'import',
                    builder: (context, state) =>
                        ImportTicketScreen(token: state.uri.queryParameters['token']),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) =>
                        TicketDetailScreen(ticketId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.attendeeAccount,
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: Routes.orgPicker,
        builder: (context, state) => const OrgPickerScreen(),
      ),
      GoRoute(
        path: Routes.orgSyncAttention,
        builder: (context, state) => const NeedsAttentionScreen(),
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
                builder: (context, state) => const EventsScreen(),
                routes: [
                  // Literal segments before the `:event` parameter so "new"
                  // is never read as a slug.
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const EventFormScreen(),
                  ),
                  GoRoute(
                    path: ':event',
                    builder: (context, state) =>
                        EventDetailScreen(eventSlug: state.pathParameters['event']!),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) =>
                            EventFormScreen(eventSlug: state.pathParameters['event']!),
                      ),
                      GoRoute(
                        path: 'attendees',
                        builder: (context, state) =>
                            AttendeesScreen(eventSlug: state.pathParameters['event']!),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.orgScan,
                builder: (context, state) => const ScanEntryScreen(),
                routes: [
                  GoRoute(
                    path: 'live',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => ScannerScreen(
                      eventSlug: state.uri.queryParameters['event'],
                      initialCode: state.uri.queryParameters['code'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.orgTeam,
                builder: (context, state) => const TeamScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.orgSettings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
