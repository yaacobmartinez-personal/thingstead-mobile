// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_cache.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localCache)
final localCacheProvider = LocalCacheProvider._();

final class LocalCacheProvider
    extends $FunctionalProvider<LocalCache, LocalCache, LocalCache>
    with $Provider<LocalCache> {
  LocalCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localCacheHash();

  @$internal
  @override
  $ProviderElement<LocalCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalCache create(Ref ref) {
    return localCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalCache>(value),
    );
  }
}

String _$localCacheHash() => r'3b301ffa81b1b1c5a3920ebc5e22a476c415cb98';
