/// What the native Apple sign-in sheet hands back, ready for
/// `POST /mobile/auth/apple` (API-CONTRACT #7).
class AppleCredential {
  const AppleCredential({
    required this.identityToken,
    required this.rawNonce,
    this.authorizationCode,
    this.givenName,
    this.familyName,
  });

  final String identityToken;

  /// The un-hashed nonce; the backend hashes it and compares with the token.
  final String rawNonce;
  final String? authorizationCode;

  /// Only present on the very first authorization for this app.
  final String? givenName;
  final String? familyName;

  bool get hasName =>
      (givenName ?? '').isNotEmpty || (familyName ?? '').isNotEmpty;

  Map<String, dynamic> toJson() => {
        'identityToken': identityToken,
        if (authorizationCode != null) 'authorizationCode': authorizationCode,
        'nonce': rawNonce,
        if (hasName)
          'fullName': {
            if (givenName != null) 'givenName': givenName,
            if (familyName != null) 'familyName': familyName,
          },
      };
}
