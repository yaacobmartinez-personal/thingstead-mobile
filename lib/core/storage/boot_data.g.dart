// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boot_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in `main()` with the loaded snapshot; tests override it with
/// whatever starting state they need.

@ProviderFor(bootData)
final bootDataProvider = BootDataProvider._();

/// Overridden in `main()` with the loaded snapshot; tests override it with
/// whatever starting state they need.

final class BootDataProvider
    extends $FunctionalProvider<BootData, BootData, BootData>
    with $Provider<BootData> {
  /// Overridden in `main()` with the loaded snapshot; tests override it with
  /// whatever starting state they need.
  BootDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bootDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bootDataHash();

  @$internal
  @override
  $ProviderElement<BootData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BootData create(Ref ref) {
    return bootData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BootData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BootData>(value),
    );
  }
}

String _$bootDataHash() => r'5f8011175ef2dc9059341b281818a4a39bef328f';
