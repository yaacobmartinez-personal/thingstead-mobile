import 'dart:convert';

/// Reads the expiry out of a mobile token without verifying it.
///
/// The token is `base64url(JSON{sub, exp}).signature` (regista/lib/mobile-auth.ts).
/// The app only uses `exp` to decide whether to bother sending the token and
/// to show "session expires in N days"; the server is the authority.
///
/// Fake-mode tokens are the same shape with a `fake.` prefix.
abstract final class TokenCodec {
  static const fakePrefix = 'fake.';

  static bool isFake(String token) => token.startsWith(fakePrefix);

  static Map<String, dynamic>? payload(String token) {
    final raw = isFake(token) ? token.substring(fakePrefix.length) : token;
    final dot = raw.indexOf('.');
    if (dot < 1) return null;
    try {
      final body = utf8.decode(base64Url.decode(base64Url.normalize(raw.substring(0, dot))));
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  /// Expiry as a UTC instant, or null when the token is unreadable.
  static DateTime? expiry(String token) {
    final exp = payload(token)?['exp'];
    if (exp is! num) return null;
    return DateTime.fromMillisecondsSinceEpoch(exp.toInt(), isUtc: true);
  }

  static String? subject(String token) {
    final sub = payload(token)?['sub'];
    return sub is String ? sub : null;
  }

  /// Mint a fake-mode token with the real token's shape.
  static String mintFake(String userId, DateTime expiresAt) {
    final body = base64Url
        .encode(utf8.encode(jsonEncode({
          'sub': userId,
          'exp': expiresAt.millisecondsSinceEpoch,
        })))
        .replaceAll('=', '');
    return '$fakePrefix$body.fake';
  }
}
