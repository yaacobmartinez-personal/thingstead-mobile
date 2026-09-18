import '../../../core/config/app_config.dart';
import '../../../core/config/feature_availability.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_result.dart';
import '../domain/social_credential.dart';
import '../domain/user.dart';

/// Talks to the live API. Endpoints the server does not have yet throw
/// [ApiError.notAvailable] unless their feature flag says they shipped.
class RealAuthRepository implements AuthRepository {
  RealAuthRepository(this._api);

  final ApiClient _api;

  void _require(Feature feature) {
    if (!isAvailable(feature, ApiMode.real)) throw ApiError.notAvailable();
  }

  @override
  Future<AuthResult> login(String email, String password) async {
    final json = await _api.post(
      '/mobile/auth/login',
      body: {'email': email.trim(), 'password': password},
    );
    return AuthResult.fromJson(json);
  }

  @override
  Future<AuthResult> signInWithGoogle(String idToken) async {
    _require(Feature.socialSignIn);
    final json = await _api.post('/mobile/auth/google', body: {'idToken': idToken});
    return AuthResult.fromJson(json);
  }

  @override
  Future<AuthResult> signInWithApple(AppleCredential credential) async {
    _require(Feature.socialSignIn);
    final json = await _api.post('/mobile/auth/apple', body: credential.toJson());
    return AuthResult.fromJson(json);
  }

  @override
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    _require(Feature.signup);
    await _api.post(
      '/mobile/auth/signup',
      body: {'email': email.trim(), 'password': password, 'name': name.trim()},
    );
  }

  @override
  Future<AuthResult> verifyEmail(String token) async {
    _require(Feature.signup);
    final json = await _api.post('/mobile/auth/verify', body: {'token': token});
    return AuthResult.fromJson(json);
  }

  @override
  Future<void> resendVerification(String email) async {
    _require(Feature.signup);
    await _api.post('/mobile/auth/resend-verification', body: {'email': email.trim()});
  }

  @override
  Future<void> forgotPassword(String email) async {
    _require(Feature.passwordReset);
    await _api.post('/mobile/auth/forgot-password', body: {'email': email.trim()});
  }

  @override
  Future<AuthResult> resetPassword(String token, String password) async {
    _require(Feature.passwordReset);
    final json = await _api.post(
      '/mobile/auth/reset-password',
      body: {'token': token, 'password': password},
    );
    return AuthResult.fromJson(json);
  }

  @override
  Future<User> updateName(String name) async {
    _require(Feature.attendeeMode);
    final json = await _api.patch('/mobile/me', body: {'name': name.trim()});
    return User.fromJson(json['user'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteAccount() => _api.delete('/mobile/account');
}
