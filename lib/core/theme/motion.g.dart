// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motion.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether looping and decorative animation should run. Off when the OS
/// asks for reduced motion (or animations are disabled), and forced off in
/// tests so `pumpAndSettle` never waits on a pulse.

@ProviderFor(MotionSettings)
final motionSettingsProvider = MotionSettingsProvider._();

/// Whether looping and decorative animation should run. Off when the OS
/// asks for reduced motion (or animations are disabled), and forced off in
/// tests so `pumpAndSettle` never waits on a pulse.
final class MotionSettingsProvider
    extends $NotifierProvider<MotionSettings, bool> {
  /// Whether looping and decorative animation should run. Off when the OS
  /// asks for reduced motion (or animations are disabled), and forced off in
  /// tests so `pumpAndSettle` never waits on a pulse.
  MotionSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'motionSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$motionSettingsHash();

  @$internal
  @override
  MotionSettings create() => MotionSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$motionSettingsHash() => r'03fc1371c130011e87264a5e202381b924a7febf';

/// Whether looping and decorative animation should run. Off when the OS
/// asks for reduced motion (or animations are disabled), and forced off in
/// tests so `pumpAndSettle` never waits on a pulse.

abstract class _$MotionSettings extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
