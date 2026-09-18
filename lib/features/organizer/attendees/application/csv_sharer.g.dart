// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_sharer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(csvSharer)
final csvSharerProvider = CsvSharerProvider._();

final class CsvSharerProvider
    extends $FunctionalProvider<CsvSharer, CsvSharer, CsvSharer>
    with $Provider<CsvSharer> {
  CsvSharerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'csvSharerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$csvSharerHash();

  @$internal
  @override
  $ProviderElement<CsvSharer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CsvSharer create(Ref ref) {
    return csvSharer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CsvSharer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CsvSharer>(value),
    );
  }
}

String _$csvSharerHash() => r'b66796093a0d8f36b9f5ae4d16f3e7e744ad3036';
