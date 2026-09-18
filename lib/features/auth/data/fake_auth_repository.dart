import '../../../core/fake/fake_latency.dart';
import '../../../core/fake/fake_store.dart';
import '../../../core/model/enums.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/token_codec.dart';
import '../../../core/time/clock.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_result.dart';
import '../domain/social_credential.dart';
import '../domain/user.dart';

/// In-memory implementation of every auth endpoint, enforcing the same rules
/// the server does: unverified accounts cannot sign in, tokens are single
/// use, signup never reveals whether an email exists, and the sole admin of a
/// populated org cannot delete their account.
///
/// Fake social sign-in accepts synthetic tokens produced by the fake
/// platform services: `fake-google:<email>:<name>` and
/// `fake-apple:<sub>[:<email>]`.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(
    this._store,
    this._latency,
    this._clock,
    this._currentUserId,
  );

  final FakeStore _store;
  final FakeLatency _latency;
  final Clock _clock;
  final String? Function() _currentUserId;

  static const tokenTtl = Duration(days: 30);
  static const resetTtl = Duration(hours: 1);
  static const wrongCredentials = 'Wrong email or password.';

  AuthResult _session(FakeUser u, {bool isNewUser = false}) => AuthResult(
        token: TokenCodec.mintFake(u.id, _clock().add(tokenTtl)),
        user: _toUser(u),
        isNewUser: isNewUser,
      );

  User _toUser(FakeUser u) => User(
        id: u.id,
        email: u.email,
        name: u.name,
        emailVerified: u.emailVerified != null,
      );

  FakeUser _requireSignedIn() {
    final id = _currentUserId();
    final user = id == null ? null : _store.userById(id);
    if (user == null) throw ApiError.fromResponse(401, null);
    return user;
  }

  void _send(String to, FakeEmailKind kind, String token) {
    _store.outbox.add(FakeEmail(to: to, kind: kind, token: token, sentAt: _clock()));
  }

  @override
  Future<AuthResult> login(String email, String password) async {
    await _latency.wait();
    if (email.trim().isEmpty || password.isEmpty) {
      throw ApiError.fromResponse(400, {'error': 'Enter your email and password.'});
    }
    final user = _store.userByEmail(email);
    // Same answer for unknown, wrong password and unverified (no enumeration).
    if (user == null || user.password != password || user.emailVerified == null) {
      throw ApiError.fromResponse(401, {'error': wrongCredentials});
    }
    return _session(user);
  }

  @override
  Future<AuthResult> signInWithGoogle(String idToken) async {
    await _latency.wait();
    final parts = idToken.split(':');
    if (parts.length < 2 || parts[0] != 'fake-google') {
      throw ApiError.fromResponse(401, {'error': 'Google sign-in failed.'});
    }
    final email = parts[1];
    final name = parts.length > 2 ? parts.sublist(2).join(':') : null;
    var user = _store.userByEmail(email);
    final isNew = user == null;
    if (user == null) {
      user = FakeUser(
        id: _store.nextId('u'),
        email: email,
        name: name,
        emailVerified: _clock(),
        googleSub: 'google-$email',
        createdAt: _clock(),
      );
      _store.users.add(user);
    } else {
      user.googleSub ??= 'google-$email';
      user.emailVerified ??= _clock();
    }
    return _session(user, isNewUser: isNew);
  }

  @override
  Future<AuthResult> signInWithApple(AppleCredential credential) async {
    await _latency.wait();
    final parts = credential.identityToken.split(':');
    if (parts.length < 2 || parts[0] != 'fake-apple') {
      throw ApiError.fromResponse(401, {'error': 'Apple sign-in failed.'});
    }
    final sub = parts[1];
    final email = parts.length > 2 && parts[2].isNotEmpty ? parts[2] : null;

    var user = _store.users.where((u) => u.appleSub == sub).firstOrNull;
    if (user != null) return _session(user);

    if (email == null) {
      throw ApiError.fromResponse(400, {
        'error': 'Apple did not share your email. In Settings > Apple ID > '
            'Sign in with Apple, stop using Thingstead, then try again.',
        'reason': 'apple_identity_incomplete',
      });
    }
    user = _store.userByEmail(email);
    final isNew = user == null;
    final name = [credential.givenName, credential.familyName]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(' ');
    if (user == null) {
      user = FakeUser(
        id: _store.nextId('u'),
        email: email,
        name: name.isEmpty ? null : name,
        emailVerified: _clock(),
        appleSub: sub,
        createdAt: _clock(),
      );
      _store.users.add(user);
    } else {
      user.appleSub = sub;
      user.emailVerified ??= _clock();
    }
    return _session(user, isNewUser: isNew);
  }

  @override
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    await _latency.wait();
    final fields = <String, String>{};
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim())) {
      fields['email'] = 'Enter a valid email address.';
    }
    if (password.length < 8) fields['password'] = 'Use at least 8 characters.';
    if (name.trim().length < 2) fields['name'] = 'Enter your name.';
    if (fields.isNotEmpty) {
      throw ApiError.fromResponse(400, {
        'error': 'Check the highlighted fields.',
        'fieldErrors': fields,
      });
    }

    var user = _store.userByEmail(email);
    if (user != null && user.emailVerified != null) {
      // Existing verified account: say nothing, send nothing.
      return;
    }
    if (user == null) {
      user = FakeUser(
        id: _store.nextId('u'),
        email: email.trim(),
        name: name.trim(),
        password: password,
        createdAt: _clock(),
      );
      _store.users.add(user);
    } else {
      // Unverified account is claimable; latest attempt wins.
      user.name = name.trim();
      user.password = password;
    }
    final token = 'verify_${_store.nextId('tok')}';
    _store.verificationTokens[token] = user.id;
    _send(user.email, FakeEmailKind.verify, token);
  }

  @override
  Future<AuthResult> verifyEmail(String token) async {
    await _latency.wait();
    final userId = _store.verificationTokens.remove(token.trim());
    final user = userId == null ? null : _store.userById(userId);
    if (user == null) {
      throw ApiError.fromResponse(400, {
        'error': 'That verification link is invalid or has already been used.',
      });
    }
    user.emailVerified ??= _clock();
    return _session(user);
  }

  @override
  Future<void> resendVerification(String email) async {
    await _latency.wait();
    final user = _store.userByEmail(email);
    if (user == null || user.emailVerified != null) return;
    final token = 'verify_${_store.nextId('tok')}';
    _store.verificationTokens[token] = user.id;
    _send(user.email, FakeEmailKind.verify, token);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _latency.wait();
    final user = _store.userByEmail(email);
    if (user == null) return;
    final token = 'reset_${_store.nextId('tok')}';
    _store.resetTokens[token] = (user.id, _clock().add(resetTtl));
    _send(user.email, FakeEmailKind.reset, token);
  }

  @override
  Future<AuthResult> resetPassword(String token, String password) async {
    await _latency.wait();
    if (password.length < 8) {
      throw ApiError.fromResponse(400, {
        'error': 'Check the highlighted fields.',
        'fieldErrors': {'password': 'Use at least 8 characters.'},
      });
    }
    final entry = _store.resetTokens.remove(token.trim());
    final user = entry == null ? null : _store.userById(entry.$1);
    if (user == null || entry!.$2.isBefore(_clock())) {
      throw ApiError.fromResponse(400, {
        'error': 'That reset link is invalid or has expired.',
      });
    }
    user.password = password;
    user.emailVerified ??= _clock();
    _store.resetTokens.removeWhere((_, v) => v.$1 == user.id);
    return _session(user);
  }

  @override
  Future<User> updateName(String name) async {
    await _latency.wait();
    final user = _requireSignedIn();
    if (name.trim().length < 2) {
      throw ApiError.fromResponse(400, {
        'error': 'Check the highlighted fields.',
        'fieldErrors': {'name': 'Enter your name.'},
      });
    }
    user.name = name.trim();
    return _toUser(user);
  }

  @override
  Future<void> deleteAccount() async {
    await _latency.wait();
    final user = _requireSignedIn();

    // Mirror `deleteUserAccount`: blocked while sole admin of an org that
    // still has other members or events.
    final blocked = <Map<String, String>>[];
    for (final m in _store.membershipsOf(user.id)) {
      if (m.role != Role.admin) continue;
      final tenant = _store.tenantById(m.tenantId);
      if (tenant == null) continue;
      final admins = _store.memberships
          .where((x) => x.tenantId == tenant.id && x.role == Role.admin)
          .length;
      final others = _store.memberships
          .where((x) => x.tenantId == tenant.id && x.userId != user.id)
          .isNotEmpty;
      final hasEvents = _store.eventsOf(tenant.id).isNotEmpty;
      if (admins == 1 && (others || hasEvents)) {
        blocked.add({'tenantSlug': tenant.slug, 'tenantName': tenant.name});
      }
    }
    if (blocked.isNotEmpty) {
      final names = blocked.map((b) => b['tenantName']).join(', ');
      throw ApiError.fromResponse(409, {
        'error': "You're the only admin of $names. Make someone else an admin "
            'or delete the organization first.',
        'reason': 'sole_admin',
        'blocked': blocked,
      });
    }

    _store.memberships.removeWhere((m) => m.userId == user.id);
    user
      ..email = 'deleted+${user.id}@anon.invalid'
      ..name = null
      ..password = null
      ..emailVerified = null
      ..googleSub = null
      ..appleSub = null;
    for (final r in _store.registrations.where((r) => r.userId == user.id)) {
      r.userId = null;
    }
  }
}
