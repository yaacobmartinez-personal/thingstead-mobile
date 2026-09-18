import '../config/app_config.dart';
import '../util/slugify.dart';

/// What a URL means to the app. Pure data; the handler decides navigation.
sealed class DeepLinkTarget {
  const DeepLinkTarget();
}

/// `thingstead.pro/<org>` — an organization's published events.
final class OrgEventsTarget extends DeepLinkTarget {
  const OrgEventsTarget(this.org);
  final String org;
}

/// `thingstead.pro/<org>/<event>` — one event's public page.
final class EventDetailTarget extends DeepLinkTarget {
  const EventDetailTarget(this.org, this.event);
  final String org;
  final String event;
}

/// `thingstead.pro/<org>/<event>/manage?token=` — a registrant's manage link;
/// the app imports it as a ticket.
final class ImportTicketTarget extends DeepLinkTarget {
  const ImportTicketTarget(this.org, this.event, this.token);
  final String org;
  final String event;
  final String token;
}

/// `app.thingstead.pro/checkin?c=` — the URL inside a QR ticket.
final class CheckInTarget extends DeepLinkTarget {
  const CheckInTarget(this.code);
  final String code;
}

/// `app.thingstead.pro/verify?token=` — email verification.
final class VerifyEmailTarget extends DeepLinkTarget {
  const VerifyEmailTarget(this.token);
  final String token;
}

/// `app.thingstead.pro/reset?token=` — password reset.
final class ResetPasswordTarget extends DeepLinkTarget {
  const ResetPasswordTarget(this.token);
  final String token;
}

/// `app.thingstead.pro/invite?token=` — team invitation.
final class AcceptInviteTarget extends DeepLinkTarget {
  const AcceptInviteTarget(this.token);
  final String token;
}

/// A Thingstead URL the app has no native screen for (marketing pages, the
/// web dashboard, per-org privacy notice): open it in an in-app browser tab.
final class OpenInBrowserTarget extends DeepLinkTarget {
  const OpenInBrowserTarget(this.uri);
  final Uri uri;
}

/// Maps URLs to [DeepLinkTarget]s. Scheme-agnostic: `https://thingstead.pro/x`
/// and `thingstead://thingstead.pro/x` are the same target, so the custom
/// scheme fallback needs no separate rules.
class DeepLinkParser {
  DeepLinkParser({
    String? publicHost,
    String? appHost,
  })  : publicHost = publicHost ?? Uri.parse(AppConfig.publicOrigin).host,
        appHost = appHost ?? Uri.parse(AppConfig.appOrigin).host;

  final String publicHost;
  final String appHost;

  static const _appPathsWithToken = {
    '/verify': 'token',
    '/reset': 'token',
    '/invite': 'token',
    '/checkin': 'c',
  };

  /// Returns null when the URL is not a Thingstead URL at all.
  DeepLinkTarget? parse(Uri uri) {
    final host = uri.host.toLowerCase();
    if (host == appHost) return _parseApp(uri);
    if (host == publicHost || host == 'www.$publicHost') return _parsePublic(uri);
    return null;
  }

  DeepLinkTarget _parseApp(Uri uri) {
    final path = _normalizePath(uri.path);
    final param = _appPathsWithToken[path];
    final value = param == null ? null : uri.queryParameters[param];
    if (param == null || value == null || value.isEmpty) {
      return OpenInBrowserTarget(_asHttps(uri));
    }
    return switch (path) {
      '/checkin' => CheckInTarget(value),
      '/verify' => VerifyEmailTarget(value),
      '/reset' => ResetPasswordTarget(value),
      '/invite' => AcceptInviteTarget(value),
      _ => OpenInBrowserTarget(_asHttps(uri)),
    };
  }

  DeepLinkTarget _parsePublic(Uri uri) {
    final segments =
        uri.pathSegments.where((s) => s.isNotEmpty).toList(growable: false);
    final browser = OpenInBrowserTarget(_asHttps(uri));

    if (segments.isEmpty) return browser;
    final org = segments[0].toLowerCase();
    if (!isUsableSlug(org)) return browser;
    if (segments.length == 1) return OrgEventsTarget(org);

    final event = segments[1].toLowerCase();
    if (!isValidSlugShape(event)) return browser;
    if (segments.length == 2) return EventDetailTarget(org, event);

    if (segments.length == 3 && segments[2] == 'manage') {
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        return ImportTicketTarget(org, event, token);
      }
    }
    return browser;
  }

  static String _normalizePath(String path) {
    var p = path.toLowerCase();
    while (p.length > 1 && p.endsWith('/')) {
      p = p.substring(0, p.length - 1);
    }
    return p.isEmpty ? '/' : p;
  }

  /// Custom-scheme links should open in the browser as https.
  static Uri _asHttps(Uri uri) =>
      uri.scheme == 'http' || uri.scheme == 'https'
          ? uri
          : uri.replace(scheme: 'https');
}
