// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanner_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One scanning session for an org (optionally pinned to one event).
/// Guards against the camera reporting the same QR many times while a
/// request is in flight — port of the `lock` ref in the Expo ScannerScreen.
///
/// Offline (or when the server cannot be reached) the scan is decided
/// against the local cache and queued for replay; see [OfflineResolver].

@ProviderFor(ScannerController)
final scannerControllerProvider = ScannerControllerFamily._();

/// One scanning session for an org (optionally pinned to one event).
/// Guards against the camera reporting the same QR many times while a
/// request is in flight — port of the `lock` ref in the Expo ScannerScreen.
///
/// Offline (or when the server cannot be reached) the scan is decided
/// against the local cache and queued for replay; see [OfflineResolver].
final class ScannerControllerProvider
    extends $NotifierProvider<ScannerController, ScannerState> {
  /// One scanning session for an org (optionally pinned to one event).
  /// Guards against the camera reporting the same QR many times while a
  /// request is in flight — port of the `lock` ref in the Expo ScannerScreen.
  ///
  /// Offline (or when the server cannot be reached) the scan is decided
  /// against the local cache and queued for replay; see [OfflineResolver].
  ScannerControllerProvider._({
    required ScannerControllerFamily super.from,
    required (String, String?) super.argument,
  }) : super(
         retry: null,
         name: r'scannerControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scannerControllerHash();

  @override
  String toString() {
    return r'scannerControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ScannerController create() => ScannerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScannerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScannerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ScannerControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scannerControllerHash() => r'37ec89b6cd650a912941d3a7a54f96aaca260f82';

/// One scanning session for an org (optionally pinned to one event).
/// Guards against the camera reporting the same QR many times while a
/// request is in flight — port of the `lock` ref in the Expo ScannerScreen.
///
/// Offline (or when the server cannot be reached) the scan is decided
/// against the local cache and queued for replay; see [OfflineResolver].

final class ScannerControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ScannerController,
          ScannerState,
          ScannerState,
          ScannerState,
          (String, String?)
        > {
  ScannerControllerFamily._()
    : super(
        retry: null,
        name: r'scannerControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One scanning session for an org (optionally pinned to one event).
  /// Guards against the camera reporting the same QR many times while a
  /// request is in flight — port of the `lock` ref in the Expo ScannerScreen.
  ///
  /// Offline (or when the server cannot be reached) the scan is decided
  /// against the local cache and queued for replay; see [OfflineResolver].

  ScannerControllerProvider call(String org, String? eventSlug) =>
      ScannerControllerProvider._(argument: (org, eventSlug), from: this);

  @override
  String toString() => r'scannerControllerProvider';
}

/// One scanning session for an org (optionally pinned to one event).
/// Guards against the camera reporting the same QR many times while a
/// request is in flight — port of the `lock` ref in the Expo ScannerScreen.
///
/// Offline (or when the server cannot be reached) the scan is decided
/// against the local cache and queued for replay; see [OfflineResolver].

abstract class _$ScannerController extends $Notifier<ScannerState> {
  late final _$args = ref.$arg as (String, String?);
  String get org => _$args.$1;
  String? get eventSlug => _$args.$2;

  ScannerState build(String org, String? eventSlug);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ScannerState, ScannerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScannerState, ScannerState>,
              ScannerState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
