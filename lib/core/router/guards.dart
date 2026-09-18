import '../../features/auth/application/auth_state.dart';
import '../../features/shell/application/app_mode_controller.dart';
import 'routes.dart';

/// Pure redirect rules, kept free of Riverpod so they can be unit-tested.
/// Returns the location to send the person to, or null to let them through.
///
/// - Auth screens bounce a signed-in person to `from` (or their shell home),
///   except verify/reset which may legitimately be opened while signed in.
/// - Ticket detail/import and everything under `/o` need a session; the tab
///   roots stay public and show an inline sign-in prompt instead. A session
///   that ended deliberately (sign out, delete, server change) goes to the
///   attendee home; one that expired goes to login and comes back here.
/// - The organizer shell needs at least one org membership.
///
/// Note: GoRouter re-runs these rules on auth changes only for the
/// *declarative* location, not for screens pushed on top of it, so the auth
/// screens also navigate explicitly on success (see [afterSignInTarget]).
String? computeRedirect({
  required Uri uri,
  required AuthState auth,
  required AppMode mode,
  bool onboardingSeen = true,
  bool organizeIntent = false,
}) {
  final path = uri.path;
  final signedIn = auth.isSignedIn;

  // A fresh install opens on the intro; deep links and everything else
  // skip it, and it never interrupts a signed-in person.
  if (!onboardingSeen && !signedIn && path == AppMode.attendee.home) {
    return Routes.onboarding;
  }

  if (path.startsWith('/auth/')) {
    final tokenScreen = path == Routes.verify || path == Routes.reset;
    if (signedIn && !tokenScreen) {
      // Signed up to organize: setup comes before anything else.
      if (organizeIntent && !auth.hasOrganizerAccess) return Routes.organize;
      return afterSignInTarget(from: uri.queryParameters['from'], mode: mode);
    }
    return null;
  }

  if (!signedIn && requiresSession(path)) {
    final reason = auth is SignedOut ? auth.reason : null;
    final deliberate = reason == SignOutReason.user ||
        reason == SignOutReason.accountDeleted ||
        reason == SignOutReason.serverChanged;
    return deliberate ? AppMode.attendee.home : loginFor(uri);
  }

  if (isOrganizerPath(path)) {
    if (!auth.hasOrganizerAccess) return AppMode.attendee.home;
  }
  return null;
}

/// `/o` and everything under it — not `/onboarding`.
bool isOrganizerPath(String path) => path == '/o' || path.startsWith('/o/');

bool requiresSession(String path) =>
    isOrganizerPath(path) ||
    path == Routes.organize ||
    (path.startsWith('${Routes.attendeeTickets}/') && path != Routes.attendeeTickets);

/// The login route that returns to [uri] afterwards.
String loginFor(Uri uri) =>
    '${Routes.login}?from=${Uri.encodeComponent(uri.toString())}';

/// Where to go once signed in. Organizers land in their shell (that is what
/// they came for) unless `from` was already an organizer route; everyone
/// else returns to `from` or the attendee home.
String afterSignInTarget({required String? from, required AppMode mode}) {
  final safe = safeFrom(from);
  if (mode == AppMode.organizer) {
    return safe != null && isOrganizerPath(safe) ? safe : mode.home;
  }
  return safe ?? AppMode.attendee.home;
}

/// Only in-app paths are honoured, so a crafted link cannot bounce the app to
/// an arbitrary location.
String? safeFrom(String? from) {
  if (from == null || !from.startsWith('/') || from.startsWith('//')) return null;
  if (from.startsWith('/auth/')) return null;
  return from;
}
