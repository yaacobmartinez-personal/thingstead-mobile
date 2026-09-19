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
///
/// Everything but social sign-in shipped in regista#1 and is live. The contract
/// item numbers each one waits on are in the comment beside it, so the next
/// person can check a flag against the server rather than trusting this list.
const Map<Feature, bool> _shippedOnRealServer = {
  Feature.signup: true, // #1-#3
  Feature.passwordReset: true, // #4, #5
  // The one thing still missing: POST /mobile/auth/google and /auth/apple do
  // not exist. Everything else here has a route behind it.
  Feature.socialSignIn: false, // #6, #7 — not built
  Feature.attendeeMode: true, // #8-#17
  Feature.eventCrud: true, // #18-#22
  Feature.promoteErase: true, // #25, #26
  Feature.csvExport: true, // #27
  Feature.team: true, // #28-#33
  Feature.createOrg: true, // #34, #35
  // #23 ships `checkInToken` on the attendee payload, so a scan resolves
  // against the cache offline instead of queueing blind. Note that replaying an
  // offline *scan* still records the replay time, not the door time: #24 gives
  // `at` to the manual check-in only, and E6 has no equivalent yet.
  Feature.offlineTokens: true, // #23, #24
};

bool isAvailable(Feature feature, ApiMode mode) => switch (mode) {
      ApiMode.fake => true,
      ApiMode.real => _shippedOnRealServer[feature] ?? false,
    };
