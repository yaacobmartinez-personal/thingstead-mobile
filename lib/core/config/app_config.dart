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

  /// The API host. Fixed per build: `--dart-define=SERVER_URL=http://10.0.2.2:3000`
  /// for a laptop backend; there is no runtime setting.
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

  /// OAuth client ids for Google sign-in. The Web client id is what the
  /// backend verifies as the token audience; the iOS id is needed by the SDK.
  static const String googleWebClientId =
      String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
  static const String googleIosClientId =
      String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

  /// Sign in with Apple needs the capability on the App ID, which only a paid
  /// Developer Program team can add. A build without it must not show the
  /// button, so it is opt-in: `--dart-define=APPLE_SIGN_IN=true`.
  static const bool appleSignInEnabled =
      bool.fromEnvironment('APPLE_SIGN_IN');

  /// Reported in the X-Client header. Keep in step with pubspec.yaml.
  static const String appVersion = '0.1.0';
}
