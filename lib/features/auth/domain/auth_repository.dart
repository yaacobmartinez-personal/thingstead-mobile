import 'auth_result.dart';
import 'social_credential.dart';
import 'user.dart';

/// Sign-in, sign-up, and account endpoints. Numbers refer to
/// docs/API-CONTRACT.md; `E` numbers exist on the real server today.
abstract class AuthRepository {
  /// E1 — 401 means wrong email or password (also for unverified accounts).
  Future<AuthResult> login(String email, String password);

  /// #6
  Future<AuthResult> signInWithGoogle(String idToken);

  /// #7 — 400 `apple_identity_incomplete` when Apple withheld the email.
  Future<AuthResult> signInWithApple(AppleCredential credential);

  /// #1 — always succeeds from the caller's point of view (no enumeration).
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  });

  /// #2 — signs the user in on success.
  Future<AuthResult> verifyEmail(String token);

  /// #3
  Future<void> resendVerification(String email);

  /// #4
  Future<void> forgotPassword(String email);

  /// #5 — signs the user in on success.
  Future<AuthResult> resetPassword(String token, String password);

  /// #9
  Future<User> updateName(String name);

  /// E7 — 409 `sole_admin` when they still own a populated org.
  Future<void> deleteAccount();
}
