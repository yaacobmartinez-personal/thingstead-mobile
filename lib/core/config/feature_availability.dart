import 'app_config.dart';

/// Features whose backend endpoints do not exist yet (see docs/API-CONTRACT.md).
///
/// In [ApiMode.fake] everything is available. In [ApiMode.real] a feature is
/// available only once its endpoints ship; until then the UI hides the entry
/// point so a build against today's server never shows a dead button.
enum Feature {
  signup,
  passwordReset,
  socialSignIn,
  attendeeMode,
  eventCrud,
  promoteErase,
  csvExport,
  team,

  /// Creating an organization from the app (#34–#35).
  createOrg,

  /// `checkInToken` on the attendees payload, enabling offline scan resolution.
  offlineTokens,
}

/// Flip an entry to `true` when the corresponding contract items land on the
/// real server. Kept as a plain map so the change is a one-line diff.
const Map<Feature, bool> _shippedOnRealServer = {
  Feature.signup: false,
  Feature.passwordReset: false,
  Feature.socialSignIn: false,
  Feature.attendeeMode: false,
  Feature.eventCrud: false,
  Feature.promoteErase: false,
  Feature.csvExport: false,
  Feature.team: false,
  Feature.createOrg: false,
  Feature.offlineTokens: false,
};

bool isAvailable(Feature feature, ApiMode mode) => switch (mode) {
      ApiMode.fake => true,
      ApiMode.real => _shippedOnRealServer[feature] ?? false,
    };
