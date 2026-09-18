import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/router/deep_link_parser.dart';

void main() {
  final parser = DeepLinkParser(
    publicHost: 'thingstead.pro',
    appHost: 'app.thingstead.pro',
  );

  DeepLinkTarget? parse(String url) => parser.parse(Uri.parse(url));

  group('public host', () {
    test('org page', () {
      final t = parse('https://thingstead.pro/acme');
      expect(t, isA<OrgEventsTarget>().having((t) => t.org, 'org', 'acme'));
    });

    test('event page, case-insensitive and tolerant of a trailing slash', () {
      final t = parse('https://thingstead.pro/Acme/Summer-Meetup/');
      expect(
        t,
        isA<EventDetailTarget>()
            .having((t) => t.org, 'org', 'acme')
            .having((t) => t.event, 'event', 'summer-meetup'),
      );
    });

    test('manage link imports a ticket', () {
      final t = parse(
        'https://thingstead.pro/acme/summer-meetup/manage?token=abc.def',
      );
      expect(
        t,
        isA<ImportTicketTarget>()
            .having((t) => t.org, 'org', 'acme')
            .having((t) => t.event, 'event', 'summer-meetup')
            .having((t) => t.token, 'token', 'abc.def'),
      );
    });

    test('manage link without a token opens in the browser', () {
      expect(
        parse('https://thingstead.pro/acme/summer-meetup/manage'),
        isA<OpenInBrowserTarget>(),
      );
    });

    test('www is treated as the apex', () {
      expect(parse('https://www.thingstead.pro/acme'), isA<OrgEventsTarget>());
    });

    test('marketing and reserved paths open in the browser', () {
      for (final url in [
        'https://thingstead.pro/',
        'https://thingstead.pro/signup',
        'https://thingstead.pro/privacy',
        'https://thingstead.pro/app/o/acme',
        'https://thingstead.pro/api/mobile/orgs',
        'https://thingstead.pro/acme/privacy/extra',
      ]) {
        expect(parse(url), isA<OpenInBrowserTarget>(), reason: url);
      }
    });

    test('an org-level privacy page is not an event', () {
      // "privacy" is a valid slug shape but reserved; as a second segment it is
      // an event slug, so it must render the web page, not an app screen.
      expect(parse('https://thingstead.pro/acme/privacy'), isA<EventDetailTarget>());
    });

    test('invalid slug shapes open in the browser', () {
      expect(parse('https://thingstead.pro/ab'), isA<OpenInBrowserTarget>());
      expect(
        parse('https://thingstead.pro/acme/has spaces'),
        isA<OpenInBrowserTarget>(),
      );
    });
  });

  group('app host', () {
    test('check-in QR', () {
      final t = parse('https://app.thingstead.pro/checkin?c=tok123');
      expect(t, isA<CheckInTarget>().having((t) => t.code, 'code', 'tok123'));
    });

    test('verify, reset, invite carry their token', () {
      expect(
        parse('https://app.thingstead.pro/verify?token=v1'),
        isA<VerifyEmailTarget>().having((t) => t.token, 'token', 'v1'),
      );
      expect(
        parse('https://app.thingstead.pro/reset?token=r1'),
        isA<ResetPasswordTarget>().having((t) => t.token, 'token', 'r1'),
      );
      expect(
        parse('https://app.thingstead.pro/invite?token=i1'),
        isA<AcceptInviteTarget>().having((t) => t.token, 'token', 'i1'),
      );
    });

    test('missing token or dashboard paths open in the browser', () {
      expect(parse('https://app.thingstead.pro/checkin'), isA<OpenInBrowserTarget>());
      expect(parse('https://app.thingstead.pro/o/acme'), isA<OpenInBrowserTarget>());
      expect(parse('https://app.thingstead.pro/login'), isA<OpenInBrowserTarget>());
    });
  });

  group('schemes', () {
    test('custom scheme maps to the same targets', () {
      expect(parse('thingstead://thingstead.pro/acme/summer'), isA<EventDetailTarget>());
      expect(
        parse('thingstead://app.thingstead.pro/checkin?c=x'),
        isA<CheckInTarget>(),
      );
    });

    test('custom-scheme browser fallbacks are rewritten to https', () {
      final t = parse('thingstead://thingstead.pro/privacy');
      expect(
        t,
        isA<OpenInBrowserTarget>()
            .having((t) => t.uri.toString(), 'uri', 'https://thingstead.pro/privacy'),
      );
    });

    test('foreign hosts are not ours', () {
      expect(parse('https://example.com/acme'), isNull);
      expect(parse('https://evil.thingstead.pro.example.com/acme'), isNull);
    });
  });

  test('defaults derive hosts from AppConfig', () {
    final d = DeepLinkParser();
    expect(d.publicHost, 'thingstead.pro');
    expect(d.appHost, 'app.thingstead.pro');
  });
}
