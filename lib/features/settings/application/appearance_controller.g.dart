// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appearance_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Light, dark, or follow the system. Read at boot so the first frame is
/// already the right theme.

@ProviderFor(AppearanceController)
final appearanceControllerProvider = AppearanceControllerProvider._();

/// Light, dark, or follow the system. Read at boot so the first frame is
/// already the right theme.
final class AppearanceControllerProvider
    extends $NotifierProvider<AppearanceController, ThemeMode> {
  /// Light, dark, or follow the system. Read at boot so the first frame is
  /// already the right theme.
  AppearanceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appearanceControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appearanceControllerHash();

  @$internal
  @override
  AppearanceController create() => AppearanceController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$appearanceControllerHash() =>
    r'cb0191591af57eb69fe97a2ea9198d097343209f';

/// Light, dark, or follow the system. Read at boot so the first frame is
/// already the right theme.

abstract class _$AppearanceController extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
