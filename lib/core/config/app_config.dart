/// Build-time configuration, supplied with `--dart-define`.
///
/// `API_MODE` picks the data layer:
///  - `fake`: every repository is an in-memory fake seeded from `core/fake/seed.dart`.
///    This is the development default so the whole app can be exercised before
///    the backend has every endpoint.
///  - `real`: every repository talks to the Thingstead API over HTTPS. Endpoints
///    the server does not have yet are hidden by `Feature` gates.
enum ApiMode {
  real,
  fake;

  static ApiMode parse(String raw) => switch (raw.trim().toLowerCase()) {
        'real' => ApiMode.real,
        'fake' || '' => ApiMode.fake,
        final other => throw ArgumentError.value(
            other,
            'API_MODE',
            'Expected "real" or "fake".',
          ),
      };
}

abstract final class AppConfig {
  static const String _apiModeRaw =
      String.fromEnvironment('API_MODE', defaultValue: 'fake');

  static final ApiMode apiMode = ApiMode.parse(_apiModeRaw);

  /// Default API host. Editable at runtime in Settings (mirrors the Expo app).
  static const String defaultServerUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'https://thingstead.onrender.com',
  );

  /// Where public tenant pages live: `https://thingstead.pro/<org>/<event>`.
  static const String publicOrigin = String.fromEnvironment(
    'PUBLIC_ORIGIN',
    defaultValue: 'https://thingstead.pro',
  );

  /// The organizer dashboard host; also the host encoded in QR tickets.
  static const String appOrigin = String.fromEnvironment(
    'APP_ORIGIN',
    defaultValue: 'https://app.thingstead.pro',
  );

  /// Custom URL scheme used as the deep-link fallback before App Links /
  /// Universal Links are verified.
  static const String customScheme = 'thingstead';

  static const String appName = 'Thingstead';
}
