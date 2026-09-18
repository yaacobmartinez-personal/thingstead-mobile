// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_mode.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The build-time [ApiMode], exposed as a provider so tests can override it.

@ProviderFor(apiMode)
final apiModeProvider = ApiModeProvider._();

/// The build-time [ApiMode], exposed as a provider so tests can override it.

final class ApiModeProvider
    extends $FunctionalProvider<ApiMode, ApiMode, ApiMode>
    with $Provider<ApiMode> {
  /// The build-time [ApiMode], exposed as a provider so tests can override it.
  ApiModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiModeHash();

  @$internal
  @override
  $ProviderElement<ApiMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiMode create(Ref ref) {
    return apiMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiMode>(value),
    );
  }
}

String _$apiModeHash() => r'54a392618742b7daa2fcd0273572ba494985fe63';
