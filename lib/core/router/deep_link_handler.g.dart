// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deep_link_handler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Wired to `app_links`; watched once from the app widget so it starts with
/// the router and is rebuilt only if the router is.

@ProviderFor(deepLinkHandler)
final deepLinkHandlerProvider = DeepLinkHandlerProvider._();

/// Wired to `app_links`; watched once from the app widget so it starts with
/// the router and is rebuilt only if the router is.

final class DeepLinkHandlerProvider
    extends
        $FunctionalProvider<DeepLinkHandler, DeepLinkHandler, DeepLinkHandler>
    with $Provider<DeepLinkHandler> {
  /// Wired to `app_links`; watched once from the app widget so it starts with
  /// the router and is rebuilt only if the router is.
  DeepLinkHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deepLinkHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deepLinkHandlerHash();

  @$internal
  @override
  $ProviderElement<DeepLinkHandler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeepLinkHandler create(Ref ref) {
    return deepLinkHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeepLinkHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeepLinkHandler>(value),
    );
  }
}

String _$deepLinkHandlerHash() => r'20809d73e2801cd32f6005edde3d4980bc6c4d95';
