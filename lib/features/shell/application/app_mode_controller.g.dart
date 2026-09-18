// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_mode_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppModeController)
final appModeControllerProvider = AppModeControllerProvider._();

final class AppModeControllerProvider
    extends $NotifierProvider<AppModeController, AppMode> {
  AppModeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appModeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appModeControllerHash();

  @$internal
  @override
  AppModeController create() => AppModeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppMode>(value),
    );
  }
}

String _$appModeControllerHash() => r'41768b85f1f36ad513d83ff05cf0041bd5b25d46';

abstract class _$AppModeController extends $Notifier<AppMode> {
  AppMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppMode, AppMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppMode, AppMode>,
              AppMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
