// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The session state machine.
///
/// Sign-in of any kind ends in [_establish], which persists the session,
/// loads org memberships, and — for a fresh sign-in — opens the organizer
/// shell when the person has any. Every sign-out path ends in [signOut],
/// which wipes the session and returns the app to attendee mode.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// The session state machine.
///
/// Sign-in of any kind ends in [_establish], which persists the session,
/// loads org memberships, and — for a fresh sign-in — opens the organizer
/// shell when the person has any. Every sign-out path ends in [signOut],
/// which wipes the session and returns the app to attendee mode.
final class AuthControllerProvider
    extends $NotifierProvider<AuthController, AuthState> {
  /// The session state machine.
  ///
  /// Sign-in of any kind ends in [_establish], which persists the session,
  /// loads org memberships, and — for a fresh sign-in — opens the organizer
  /// shell when the person has any. Every sign-out path ends in [signOut],
  /// which wipes the session and returns the app to attendee mode.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authControllerHash() => r'38d91e3c51851df8b8efb828df7d13ac20987c1c';

/// The session state machine.
///
/// Sign-in of any kind ends in [_establish], which persists the session,
/// loads org memberships, and — for a fresh sign-in — opens the organizer
/// shell when the person has any. Every sign-out path ends in [signOut],
/// which wipes the session and returns the app to attendee mode.

abstract class _$AuthController extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Days until the session ends, for the "sign in again to extend" hint.

@ProviderFor(sessionDaysLeft)
final sessionDaysLeftProvider = SessionDaysLeftProvider._();

/// Days until the session ends, for the "sign in again to extend" hint.

final class SessionDaysLeftProvider
    extends $FunctionalProvider<int?, int?, int?>
    with $Provider<int?> {
  /// Days until the session ends, for the "sign in again to extend" hint.
  SessionDaysLeftProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionDaysLeftProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionDaysLeftHash();

  @$internal
  @override
  $ProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    return sessionDaysLeft(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$sessionDaysLeftHash() => r'a99267fc03aebe004b5497c8c4b54606d0e876c6';
