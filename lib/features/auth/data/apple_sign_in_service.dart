import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/fake/seed.dart';
import '../domain/social_credential.dart';

/// Wraps the native Apple sign-in sheet (iOS only in v1). Returns null when
/// the person cancelled.
abstract class AppleSignInService {
  Future<AppleCredential?> signIn();
}

class RealAppleSignInService implements AppleSignInService {
  static String _randomNonce([int length = 32]) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Future<AppleCredential?> signIn() async {
    final rawNonce = _randomNonce();
    final hashed = sha256.convert(utf8.encode(rawNonce)).toString();
    try {
      final c = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: hashed,
      );
      final identityToken = c.identityToken;
      if (identityToken == null) return null;
      return AppleCredential(
        identityToken: identityToken,
        rawNonce: rawNonce,
        authorizationCode: c.authorizationCode,
        givenName: c.givenName,
        familyName: c.familyName,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }
}

/// Fake mode: "Apple" is the seeded organizer account.
class FakeAppleSignInService implements AppleSignInService {
  @override
  Future<AppleCredential?> signIn() async => AppleCredential(
        identityToken: 'fake-apple:apple-demo:${FakeAccounts.organizerEmail}',
        rawNonce: 'fake-nonce',
        givenName: 'Demo',
        familyName: 'Organizer',
      );
}
