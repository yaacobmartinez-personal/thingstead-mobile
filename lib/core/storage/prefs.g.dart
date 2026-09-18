// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prefs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(prefs)
final prefsProvider = PrefsProvider._();

final class PrefsProvider extends $FunctionalProvider<Prefs, Prefs, Prefs>
    with $Provider<Prefs> {
  PrefsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefsHash();

  @$internal
  @override
  $ProviderElement<Prefs> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Prefs create(Ref ref) {
    return prefs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Prefs value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Prefs>(value),
    );
  }
}

String _$prefsHash() => r'561ad2a67c46873c49b3c22fc23daaf49e087099';
