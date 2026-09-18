// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the device reports a network. A hint, never a guarantee: the app
/// still tries requests when this says online, and treats a transport
/// failure as offline when this says otherwise. Overridden in tests.

@ProviderFor(connectivity)
final connectivityProvider = ConnectivityProvider._();

/// Whether the device reports a network. A hint, never a guarantee: the app
/// still tries requests when this says online, and treats a transport
/// failure as offline when this says otherwise. Overridden in tests.

final class ConnectivityProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Whether the device reports a network. A hint, never a guarantee: the app
  /// still tries requests when this says online, and treats a transport
  /// failure as offline when this says otherwise. Overridden in tests.
  ConnectivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return connectivity(ref);
  }
}

String _$connectivityHash() => r'39bdb6b500d80255af8801f8b5394105ea9c2aa8';

/// Current best guess; optimistic until the first reading arrives.

@ProviderFor(isOnline)
final isOnlineProvider = IsOnlineProvider._();

/// Current best guess; optimistic until the first reading arrives.

final class IsOnlineProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Current best guess; optimistic until the first reading arrives.
  IsOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOnlineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOnlineHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isOnline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isOnlineHash() => r'e22ac929154991f9614582cdf81ca213ee219dae';
