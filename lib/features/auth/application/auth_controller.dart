import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/token_codec.dart';
import '../../../core/network/unauthorized_events.dart';
import '../../../core/storage/boot_data.dart';
import '../../../core/storage/secure_store.dart';
import '../../../core/time/clock.dart';
import '../../organizer/orgs/application/selected_org_controller.dart';
import '../../organizer/orgs/domain/org.dart';
import '../../shell/application/app_mode_controller.dart';
import '../data/auth_providers.dart';
import '../domain/auth_result.dart';
import '../domain/social_credential.dart';
import 'auth_state.dart';

part 'auth_controller.g.dart';

/// The session state machine.
///
/// Sign-in of any kind ends in [_establish], which persists the session,
/// loads org memberships, and — for a fresh sign-in — opens the organizer
/// shell when the person has any. Every sign-out path ends in [signOut],
/// which wipes the session and returns the app to attendee mode.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  Timer? _expiryTimer;

  /// The background token validation started at boot, so tests (and a future
  /// splash) can await it. Null when the app booted signed out.
  Future<void>? bootRefresh;

  @override
  AuthState build() {
    final unauthorized = ref.watch(unauthorizedEventsProvider).stream.listen((_) {
      if (state.isSignedIn) signOut(reason: SignOutReason.sessionExpired);
    });
    ref.onDispose(() {
      unauthorized.cancel();
      _expiryTimer?.cancel();
    });

    final boot = ref.watch(bootDataProvider);
    final token = boot.token;
    final user = boot.user;
    final expiresAt = token == null ? null : TokenCodec.expiry(token);
    final now = ref.read(clockProvider)();

    if (token == null || user == null || expiresAt == null || !expiresAt.isAfter(now)) {
      return const AuthState.signedOut();
    }

    // Trust the cached orgs for the first frame; validate in the background.
    _armExpiry(expiresAt);
    bootRefresh = Future.microtask(refreshOrgs);
    return AuthState.signedIn(
      user: user,
      token: token,
      expiresAt: expiresAt,
      orgs: boot.orgs,
    );
  }

  SecureStore get _secure => ref.read(secureStoreProvider);

  // --- sign in --------------------------------------------------------------

  /// E1. Throws [ApiError] (401 = wrong email or password).
  Future<void> signInWithPassword(String email, String password) async {
    final result = await ref.read(authRepositoryProvider).login(email, password);
    await _establish(result, fresh: true);
  }

  /// Returns false when the person dismissed the Google sheet.
  Future<bool> signInWithGoogle() async {
    final idToken = await ref.read(googleSignInServiceProvider).signIn();
    if (idToken == null) return false;
    final result = await ref.read(authRepositoryProvider).signInWithGoogle(idToken);
    await _establish(result, fresh: true);
    return true;
  }

  /// Returns false when the person dismissed the Apple sheet. Apple only
  /// shares the name on the first authorization, so it is kept in secure
  /// storage and re-sent on later sign-ins.
  Future<bool> signInWithApple() async {
    final credential = await ref.read(appleSignInServiceProvider).signIn();
    if (credential == null) return false;

    var merged = credential;
    if (credential.hasName) {
      await _secure.writeJson(SecureStore.keyAppleFullName, {
        'givenName': credential.givenName,
        'familyName': credential.familyName,
      });
    } else {
      final stored = await _secure.readJson(SecureStore.keyAppleFullName);
      if (stored != null) {
        merged = AppleCredential(
          identityToken: credential.identityToken,
          rawNonce: credential.rawNonce,
          authorizationCode: credential.authorizationCode,
          givenName: stored['givenName'] as String?,
          familyName: stored['familyName'] as String?,
        );
      }
    }
    final result = await ref.read(authRepositoryProvider).signInWithApple(merged);
    await _establish(result, fresh: true);
    return true;
  }

  // --- sign up / verify / reset ---------------------------------------------

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) =>
      ref.read(authRepositoryProvider).signup(
            email: email,
            password: password,
            name: name,
          );

  Future<void> verifyEmail(String token) async {
    final result = await ref.read(authRepositoryProvider).verifyEmail(token);
    await _establish(result, fresh: true);
  }

  Future<void> resendVerification(String email) =>
      ref.read(authRepositoryProvider).resendVerification(email);

  Future<void> forgotPassword(String email) =>
      ref.read(authRepositoryProvider).forgotPassword(email);

  Future<void> resetPassword(String token, String password) async {
    final result =
        await ref.read(authRepositoryProvider).resetPassword(token, password);
    await _establish(result, fresh: true);
  }

  // --- session --------------------------------------------------------------

  Future<void> _establish(AuthResult result, {required bool fresh}) async {
    _expiryTimer?.cancel();
    final expiresAt = TokenCodec.expiry(result.token) ??
        ref.read(clockProvider)().add(const Duration(days: 30));

    ref.read(currentTokenProvider.notifier).set(result.token);
    await _secure.write(SecureStore.keyToken, result.token);
    await _secure.writeJson(SecureStore.keyUser, result.user.toJson());
    state = AuthState.signedIn(
      user: result.user,
      token: result.token,
      expiresAt: expiresAt,
    );
    _armExpiry(expiresAt);

    final orgs = await refreshOrgs();
    if (fresh) {
      // People with an org came for the organizer tools; everyone else is an
      // attendee. Mirrors the Expo app landing on the org list after login.
      ref.read(appModeControllerProvider.notifier).set(
            orgs.isNotEmpty ? AppMode.organizer : AppMode.attendee,
          );
    }
  }

  /// E2. Refreshes memberships; keeps the cached list on transport errors.
  /// A 401 here means the token is dead.
  Future<List<Org>> refreshOrgs() async {
    final current = state;
    if (current is! SignedIn) return const [];
    try {
      final orgs = await ref.read(orgsRepositoryProvider).list();
      if (!ref.mounted) return orgs;
      final latest = state;
      if (latest is SignedIn && latest.token == current.token) {
        state = latest.copyWith(orgs: orgs, orgsFresh: true);
        await _secure.writeJson(
          SecureStore.keyOrgs,
          orgs.map((o) => o.toJson()).toList(),
        );
      }
      return orgs;
    } on ApiError catch (e) {
      if (e.isUnauthorized && ref.mounted) {
        await signOut(reason: SignOutReason.sessionExpired);
      }
      return current.orgs;
    }
  }

  Future<void> updateName(String name) async {
    final user = await ref.read(authRepositoryProvider).updateName(name);
    final current = state;
    if (current is SignedIn) {
      state = current.copyWith(user: user);
      await _secure.writeJson(SecureStore.keyUser, user.toJson());
    }
  }

  /// E7. Throws [ApiError] 409 `sole_admin` when blocked.
  Future<void> deleteAccount() async {
    await ref.read(authRepositoryProvider).deleteAccount();
    await signOut(reason: SignOutReason.accountDeleted);
  }

  Future<void> signOut({SignOutReason reason = SignOutReason.user}) async {
    _expiryTimer?.cancel();
    if (!state.isSignedIn) {
      state = AuthState.signedOut(reason: reason);
      return;
    }
    try {
      await ref.read(googleSignInServiceProvider).signOut();
    } catch (_) {}
    ref.read(currentTokenProvider.notifier).set(null);
    await _secure.clearSession();
    ref.read(selectedOrgSlugProvider.notifier).set(null);
    ref.read(appModeControllerProvider.notifier).set(AppMode.attendee);
    state = AuthState.signedOut(reason: reason);
  }

  /// Sign out the moment the token expires, so a stale session never sits on
  /// screen. Timers cap at ~24 days; longer expiries are re-armed next launch.
  void _armExpiry(DateTime expiresAt) {
    _expiryTimer?.cancel();
    final remaining = expiresAt.difference(ref.read(clockProvider)());
    if (remaining.isNegative || remaining > const Duration(days: 24)) return;
    _expiryTimer = Timer(remaining, () {
      if (state.isSignedIn) signOut(reason: SignOutReason.sessionExpired);
    });
  }
}

/// Days until the session ends, for the "sign in again to extend" hint.
@riverpod
int? sessionDaysLeft(Ref ref) {
  final expiresAt = ref.watch(authControllerProvider.select((s) => s.expiresAt));
  if (expiresAt == null) return null;
  return expiresAt.difference(ref.watch(clockProvider)()).inDays;
}
