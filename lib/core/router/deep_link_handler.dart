import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/shell/application/app_mode_controller.dart';
import '../config/app_config.dart';
import 'app_router.dart';
import 'deep_link_parser.dart';
import 'routes.dart';

part 'deep_link_handler.g.dart';

/// What the app does with a parsed link. Pure data so the decision can be
/// unit-tested apart from the router.
sealed class DeepLinkAction {
  const DeepLinkAction();
}

/// Switch mode (when given) and `go` to [location]. Targets nest under their
/// tab root, so the declarative stack already has somewhere for Back to go.
final class GoTo extends DeepLinkAction {
  const GoTo({this.mode, required this.location});
  final AppMode? mode;
  final String location;
}

final class OpenExternally extends DeepLinkAction {
  const OpenExternally(this.uri);
  final Uri uri;
}

final class ShowNotice extends DeepLinkAction {
  const ShowNotice(this.title, this.message);
  final String title;
  final String message;
}

String _q(String value) => Uri.encodeQueryComponent(value);

/// The routing table from docs/PLAN.md §D5.
DeepLinkAction actionFor(DeepLinkTarget target, {required bool hasOrganizerAccess}) =>
    switch (target) {
      OrgEventsTarget(:final org) =>
        GoTo(mode: AppMode.attendee, location: Routes.attendeeOrg(org)),
      EventDetailTarget(:final org, :final event) =>
        GoTo(mode: AppMode.attendee, location: Routes.attendeeEvent(org, event)),
      ImportTicketTarget(:final token) => GoTo(
          mode: AppMode.attendee,
          location: '${Routes.ticketImport}?token=${_q(token)}',
        ),
      CheckInTarget(:final code) => hasOrganizerAccess
          ? GoTo(
              mode: AppMode.organizer,
              location: '${Routes.orgScanLive}?code=${_q(code)}',
            )
          : const ShowNotice(
              'This is a check-in link',
              "It's meant for the organizer's scanner. Your own ticket is under "
                  'Tickets — show its QR code at the door.',
            ),
      VerifyEmailTarget(:final token) => GoTo(location: '${Routes.verify}?token=${_q(token)}'),
      ResetPasswordTarget(:final token) => GoTo(location: '${Routes.reset}?token=${_q(token)}'),
      // No in-app invitation screen (API-CONTRACT #33 is optional); the web
      // handles it and the app picks the membership up on next sign-in.
      AcceptInviteTarget(:final token) =>
        OpenExternally(Uri.parse('${AppConfig.appOrigin}/invite?token=${_q(token)}')),
      OpenInBrowserTarget(:final uri) => OpenExternally(uri),
    };

/// Listens for links (cold start and while running), waits for the session
/// to be known, and applies [actionFor]. Non-Thingstead URLs are ignored.
class DeepLinkHandler {
  DeepLinkHandler({
    required this.router,
    required this.hasOrganizerAccess,
    required this.setMode,
    required this.ready,
    this._links,
    this._initialLink,
    Future<bool> Function(Uri)? open,
    DeepLinkParser? parser,
    void Function(String title, String message)? notify,
  })  : _open = open ?? ((uri) => launchUrl(uri, mode: LaunchMode.inAppBrowserView)),
        _notify = notify ?? _showRootDialog,
        _parser = parser ?? DeepLinkParser();

  final GoRouter router;
  final bool Function() hasOrganizerAccess;
  final void Function(AppMode) setMode;

  /// Completes once the boot-time session check has run, so a cold-start
  /// link sees the real organizer status.
  final Future<void> Function() ready;

  final Stream<Uri>? _links;
  final Future<Uri?> Function()? _initialLink;
  final Future<bool> Function(Uri) _open;
  final void Function(String title, String message) _notify;
  final DeepLinkParser _parser;
  StreamSubscription<Uri>? _sub;

  static void _showRootDialog(String title, String message) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    ));
  }

  /// The last action taken; tests read it, the app ignores it.
  DeepLinkAction? lastAction;

  Future<void> start() async {
    _sub = _links?.listen(handle);
    final initial = await _initialLink?.call();
    if (initial != null) await handle(initial);
  }

  Future<void> handle(Uri uri) async {
    final target = _parser.parse(uri);
    if (target == null) return;
    await ready();
    final action = actionFor(target, hasOrganizerAccess: hasOrganizerAccess());
    lastAction = action;
    switch (action) {
      case GoTo(:final mode, :final location):
        if (mode != null) setMode(mode);
        router.go(location);
      case OpenExternally(:final uri):
        await _open(uri);
      case ShowNotice(:final title, :final message):
        _notify(title, message);
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}

/// Wired to `app_links`; watched once from the app widget so it starts with
/// the router and is rebuilt only if the router is.
@Riverpod(keepAlive: true)
DeepLinkHandler deepLinkHandler(Ref ref) {
  final appLinks = AppLinks();
  final handler = DeepLinkHandler(
    router: ref.watch(appRouterProvider),
    hasOrganizerAccess: () => ref.read(authControllerProvider).hasOrganizerAccess,
    setMode: (mode) => ref.read(appModeControllerProvider.notifier).set(mode),
    ready: () async {
      await ref.read(authControllerProvider.notifier).bootRefresh;
    },
    links: appLinks.uriLinkStream,
    initialLink: appLinks.getInitialLink,
  );
  ref.onDispose(handler.dispose);
  unawaited(handler.start());
  return handler;
}
