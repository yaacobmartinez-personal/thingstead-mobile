// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_tools.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether developer affordances (the server address) are visible. On in
/// debug and profile builds; hidden in release until the version line in
/// Account/Settings is long-pressed, so support can still reach it without
/// it cluttering the app for everyone else.

@ProviderFor(DevTools)
final devToolsProvider = DevToolsProvider._();

/// Whether developer affordances (the server address) are visible. On in
/// debug and profile builds; hidden in release until the version line in
/// Account/Settings is long-pressed, so support can still reach it without
/// it cluttering the app for everyone else.
final class DevToolsProvider extends $NotifierProvider<DevTools, bool> {
  /// Whether developer affordances (the server address) are visible. On in
  /// debug and profile builds; hidden in release until the version line in
  /// Account/Settings is long-pressed, so support can still reach it without
  /// it cluttering the app for everyone else.
  DevToolsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devToolsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devToolsHash();

  @$internal
  @override
  DevTools create() => DevTools();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$devToolsHash() => r'ce3b157acb511d94bd5d8c8fe4a83e34e4bd38ff';

/// Whether developer affordances (the server address) are visible. On in
/// debug and profile builds; hidden in release until the version line in
/// Account/Settings is long-pressed, so support can still reach it without
/// it cluttering the app for everyone else.

abstract class _$DevTools extends $Notifier<bool> {
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
