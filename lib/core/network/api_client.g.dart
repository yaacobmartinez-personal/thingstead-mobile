// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'039b47fbb87aa6624ae946fbec373bb0db19ae1e';

/// The bearer token to send, or null. Seeded from persisted boot data (when
/// unexpired), then owned by the auth controller. Kept as its own tiny
/// provider so the API client does not depend on auth state.

@ProviderFor(CurrentToken)
final currentTokenProvider = CurrentTokenProvider._();

/// The bearer token to send, or null. Seeded from persisted boot data (when
/// unexpired), then owned by the auth controller. Kept as its own tiny
/// provider so the API client does not depend on auth state.
final class CurrentTokenProvider
    extends $NotifierProvider<CurrentToken, String?> {
  /// The bearer token to send, or null. Seeded from persisted boot data (when
  /// unexpired), then owned by the auth controller. Kept as its own tiny
  /// provider so the API client does not depend on auth state.
  CurrentTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentTokenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTokenHash();

  @$internal
  @override
  CurrentToken create() => CurrentToken();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentTokenHash() => r'950a2eb5226c4fc42b275cabc93f0586b3c24493';

/// The bearer token to send, or null. Seeded from persisted boot data (when
/// unexpired), then owned by the auth controller. Kept as its own tiny
/// provider so the API client does not depend on auth state.

abstract class _$CurrentToken extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The signed-in user's id, decoded from the current token (null when signed
/// out). Fake repositories use it to scope their answers the way the server
/// scopes by `sub`.

@ProviderFor(currentUserId)
final currentUserIdProvider = CurrentUserIdProvider._();

/// The signed-in user's id, decoded from the current token (null when signed
/// out). Fake repositories use it to scope their answers the way the server
/// scopes by `sub`.

final class CurrentUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// The signed-in user's id, decoded from the current token (null when signed
  /// out). Fake repositories use it to scope their answers the way the server
  /// scopes by `sub`.
  CurrentUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentUserIdHash() => r'e5bb2392aa19249a6924e2484593281cacd01c38';
