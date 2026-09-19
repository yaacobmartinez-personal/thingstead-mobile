import 'package:freezed_annotation/freezed_annotation.dart';

import '../../organizer/orgs/domain/org.dart';
import '../domain/user.dart';

part 'auth_state.freezed.dart';

enum SignOutReason { user, sessionExpired, accountDeleted }

/// The app's session. There is no "booting" state: persisted data is read
/// before the first frame (see BootData), so the initial state is known.
@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.signedOut({SignOutReason? reason}) = SignedOut;

  const factory AuthState.signedIn({
    required User user,
    required String token,
    required DateTime expiresAt,

    /// Org memberships. Restored from the last session at boot, then
    /// refreshed from the server; [orgsFresh] says which.
    @Default(<Org>[]) List<Org> orgs,
    @Default(false) bool orgsFresh,
  }) = SignedIn;

  bool get isSignedIn => this is SignedIn;

  User? get user => switch (this) { SignedIn s => s.user, _ => null };

  String? get token => switch (this) { SignedIn s => s.token, _ => null };

  List<Org> get orgs => switch (this) { SignedIn s => s.orgs, _ => const [] };

  DateTime? get expiresAt =>
      switch (this) { SignedIn s => s.expiresAt, _ => null };

  /// Any org membership unlocks the organizer shell.
  bool get hasOrganizerAccess => orgs.isNotEmpty;
}
