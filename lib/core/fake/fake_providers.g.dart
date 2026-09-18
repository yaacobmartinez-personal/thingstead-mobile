// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The one shared fake world. Seeded once per app run; tests override this
/// with a store of their own.

@ProviderFor(fakeStore)
final fakeStoreProvider = FakeStoreProvider._();

/// The one shared fake world. Seeded once per app run; tests override this
/// with a store of their own.

final class FakeStoreProvider
    extends $FunctionalProvider<FakeStore, FakeStore, FakeStore>
    with $Provider<FakeStore> {
  /// The one shared fake world. Seeded once per app run; tests override this
  /// with a store of their own.
  FakeStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fakeStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fakeStoreHash();

  @$internal
  @override
  $ProviderElement<FakeStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FakeStore create(Ref ref) {
    return fakeStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FakeStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FakeStore>(value),
    );
  }
}

String _$fakeStoreHash() => r'fc4739e5d3cc5e04187d5ce8490f2dd3af218dc8';

@ProviderFor(fakeLatency)
final fakeLatencyProvider = FakeLatencyProvider._();

final class FakeLatencyProvider
    extends $FunctionalProvider<FakeLatency, FakeLatency, FakeLatency>
    with $Provider<FakeLatency> {
  FakeLatencyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fakeLatencyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fakeLatencyHash();

  @$internal
  @override
  $ProviderElement<FakeLatency> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FakeLatency create(Ref ref) {
    return fakeLatency(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FakeLatency value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FakeLatency>(value),
    );
  }
}

String _$fakeLatencyHash() => r'ab8c18ad25f877174a63b2400db927670096414c';
