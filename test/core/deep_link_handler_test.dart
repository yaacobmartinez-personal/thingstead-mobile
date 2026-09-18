import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:thingstead/core/router/deep_link_handler.dart';
import 'package:thingstead/core/router/deep_link_parser.dart';
import 'package:thingstead/features/shell/application/app_mode_controller.dart';

void main() {
  group('actionFor', () {
    test('public pages go to the attendee Events tab with the page pushed', () {
      final a = actionFor(const OrgEventsTarget('acme'), hasOrganizerAccess: true) as GoTo;
      expect(a.mode, AppMode.attendee);
      expect(a.location, '/a/events/orgs/acme');

      final b = actionFor(const EventDetailTarget('acme', 'summer-meetup'),
          hasOrganizerAccess: false) as GoTo;
      expect(b.location, '/a/events/orgs/acme/events/summer-meetup');
    });

    test('manage links import a ticket, token query-encoded', () {
      final a = actionFor(const ImportTicketTarget('acme', 'x', 'a b&c'),
          hasOrganizerAccess: false) as GoTo;
      expect(a.mode, AppMode.attendee);
      expect(a.location, '/a/tickets/import?token=a+b%26c');
    });

    test('check-in links open the scanner for organizers, a notice for everyone else', () {
      final org = actionFor(const CheckInTarget('chk_1'), hasOrganizerAccess: true) as GoTo;
      expect(org.mode, AppMode.organizer);
      expect(org.location, '/o/scan/live?code=chk_1');

      final other = actionFor(const CheckInTarget('chk_1'), hasOrganizerAccess: false);
      expect(other, isA<ShowNotice>());
      expect((other as ShowNotice).title, 'This is a check-in link');
    });

    test('verify and reset land on the auth screens without a mode switch', () {
      final v = actionFor(const VerifyEmailTarget('t'), hasOrganizerAccess: false) as GoTo;
      expect(v.mode, isNull);
      expect(v.location, '/auth/verify?token=t');
      final r = actionFor(const ResetPasswordTarget('t'), hasOrganizerAccess: false) as GoTo;
      expect(r.location, '/auth/reset?token=t');
    });

    test('invitations and unknown pages open in the browser', () {
      final i = actionFor(const AcceptInviteTarget('tok'), hasOrganizerAccess: true);
      expect((i as OpenExternally).uri.toString(), 'https://app.thingstead.pro/invite?token=tok');
      final uri = Uri.parse('https://thingstead.pro/privacy');
      final o = actionFor(OpenInBrowserTarget(uri), hasOrganizerAccess: true);
      expect((o as OpenExternally).uri, uri);
    });
  });

  group('DeepLinkHandler', () {
    late GoRouter router;
    late List<Uri> opened;
    late List<String> notices;
    late List<AppMode> modes;

    DeepLinkHandler handler({
      bool organizer = false,
      Stream<Uri>? links,
      Future<Uri?> Function()? initialLink,
      Future<void> Function()? ready,
    }) {
      opened = [];
      notices = [];
      modes = [];
      router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, _) => const SizedBox()),
          GoRoute(path: '/:any(.*)', builder: (_, _) => const SizedBox()),
        ],
      );
      return DeepLinkHandler(
        router: router,
        hasOrganizerAccess: () => organizer,
        setMode: modes.add,
        ready: ready ?? () async {},
        links: links,
        initialLink: initialLink,
        open: (uri) async {
          opened.add(uri);
          return true;
        },
        notify: (title, _) => notices.add(title),
      );
    }

    test('ignores URLs that are not Thingstead links', () async {
      final h = handler();
      await h.handle(Uri.parse('https://example.com/acme'));
      expect(h.lastAction, isNull);
      expect(modes, isEmpty);
    });

    test('navigates: mode, root, then the pushed page', () async {
      final h = handler();
      await h.handle(Uri.parse('https://thingstead.pro/acme/summer-meetup'));
      expect(modes, [AppMode.attendee]);
      expect(router.routeInformationProvider.value.uri.toString(), '/a/events/orgs/acme/events/summer-meetup');
    });

    test('custom scheme links behave like https', () async {
      final h = handler();
      await h.handle(Uri.parse('thingstead://thingstead.pro/acme'));
      expect(router.routeInformationProvider.value.uri.toString(), '/a/events/orgs/acme');
    });

    test('waits for the session check before deciding', () async {
      final gate = Completer<void>();
      var organizer = false;
      final h = DeepLinkHandler(
        router: GoRouter(routes: [GoRoute(path: '/', builder: (_, _) => const SizedBox()),
          GoRoute(path: '/:any(.*)', builder: (_, _) => const SizedBox())]),
        hasOrganizerAccess: () => organizer,
        setMode: (_) {},
        ready: () => gate.future,
        notify: (_, _) {},
      );
      final done = h.handle(Uri.parse('https://app.thingstead.pro/checkin?c=chk_1'));
      organizer = true; // the boot refresh discovers a membership
      gate.complete();
      await done;
      expect(h.lastAction, isA<GoTo>());
      expect((h.lastAction as GoTo).mode, AppMode.organizer);
    });

    test('non-organizers get a notice for check-in links', () async {
      final h = handler();
      await h.handle(Uri.parse('https://app.thingstead.pro/checkin?c=chk_1'));
      expect(notices, ['This is a check-in link']);
      expect(modes, isEmpty);
    });

    test('browser targets open externally as https', () async {
      final h = handler();
      await h.handle(Uri.parse('thingstead://thingstead.pro/privacy'));
      expect(opened.single.toString(), 'https://thingstead.pro/privacy');
    });

    test('start handles the initial link and then the stream', () async {
      final links = StreamController<Uri>();
      final h = handler(
        links: links.stream,
        initialLink: () async => Uri.parse('https://thingstead.pro/acme'),
      );
      await h.start();
      expect(router.routeInformationProvider.value.uri.toString(), '/a/events/orgs/acme');
      links.add(Uri.parse('https://thingstead.pro/beta'));
      await Future<void>.delayed(Duration.zero);
      expect(router.routeInformationProvider.value.uri.toString(), '/a/events/orgs/beta');
      h.dispose();
      await links.close();
    });
  });
}
