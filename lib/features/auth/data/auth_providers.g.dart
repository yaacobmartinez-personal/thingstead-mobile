// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'a796b4087d785e7e913a07d88f592ea51504fa08';

@ProviderFor(orgsRepository)
final orgsRepositoryProvider = OrgsRepositoryProvider._();

final class OrgsRepositoryProvider
    extends $FunctionalProvider<OrgsRepository, OrgsRepository, OrgsRepository>
    with $Provider<OrgsRepository> {
  OrgsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orgsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orgsRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrgsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrgsRepository create(Ref ref) {
    return orgsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrgsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrgsRepository>(value),
    );
  }
}

String _$orgsRepositoryHash() => r'0bcd0506d7f4a132b8a438ee7625ed1b3fda0dd4';

@ProviderFor(googleSignInService)
final googleSignInServiceProvider = GoogleSignInServiceProvider._();

final class GoogleSignInServiceProvider
    extends
        $FunctionalProvider<
          GoogleSignInService,
          GoogleSignInService,
          GoogleSignInService
        >
    with $Provider<GoogleSignInService> {
  GoogleSignInServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleSignInServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleSignInServiceHash();

  @$internal
  @override
  $ProviderElement<GoogleSignInService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleSignInService create(Ref ref) {
    return googleSignInService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleSignInService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleSignInService>(value),
    );
  }
}

String _$googleSignInServiceHash() =>
    r'e64ac3bb585d10037d929be9c50a6f2becb324a0';

@ProviderFor(appleSignInService)
final appleSignInServiceProvider = AppleSignInServiceProvider._();

final class AppleSignInServiceProvider
    extends
        $FunctionalProvider<
          AppleSignInService,
          AppleSignInService,
          AppleSignInService
        >
    with $Provider<AppleSignInService> {
  AppleSignInServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appleSignInServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appleSignInServiceHash();

  @$internal
  @override
  $ProviderElement<AppleSignInService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppleSignInService create(Ref ref) {
    return appleSignInService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppleSignInService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppleSignInService>(value),
    );
  }
}

String _$appleSignInServiceHash() =>
    r'3db4fb5d89b9da096a3e559e537291248cd8569e';
