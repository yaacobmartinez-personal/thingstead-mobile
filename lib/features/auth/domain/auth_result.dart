import 'user.dart';

/// What every sign-in path returns: `{token, user}` (plus `isNewUser` for
/// social sign-in).
class AuthResult {
  const AuthResult({
    required this.token,
    required this.user,
    this.isNewUser = false,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        token: json['token'] as String,
        user: User.fromJson(json['user'] as Map<String, dynamic>),
        isNewUser: json['isNewUser'] == true,
      );

  final String token;
  final User user;
  final bool isNewUser;
}
