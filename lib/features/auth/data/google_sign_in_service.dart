import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/fake/seed.dart';

/// Wraps the native Google sign-in sheet. Returns an ID token for
/// `POST /mobile/auth/google`, or null when the person dismissed the sheet.
abstract class GoogleSignInService {
  Future<String?> signIn();
  Future<void> signOut();
}

/// google_sign_in 7.x: `initialize` once, `authenticate` for the UI flow.
/// `serverClientId` must be the **Web** OAuth client id — that is the `aud`
/// the backend verifies (API-CONTRACT #6).
class RealGoogleSignInService implements GoogleSignInService {
  RealGoogleSignInService({this.serverClientId, this.clientId});

  final String? serverClientId;
  final String? clientId;
  Future<void>? _init;

  Future<void> _ensureInitialized() => _init ??= GoogleSignIn.instance.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      );

  @override
  Future<String?> signIn() async {
    await _ensureInitialized();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      return account.authentication.idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _ensureInitialized();
    await GoogleSignIn.instance.signOut();
  }
}

/// Fake mode: "Google" is the seeded attendee account.
class FakeGoogleSignInService implements GoogleSignInService {
  @override
  Future<String?> signIn() async =>
      'fake-google:${FakeAccounts.attendeeEmail}:Alex Attendee';

  @override
  Future<void> signOut() async {}
}
