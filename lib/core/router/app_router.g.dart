// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Two independent bottom-nav shells (attendee `/a`, organizer `/o`) plus the
/// auth stack. Each shell keeps its own tab state via `indexedStack`.
///
/// Guards (auth, organizer access, role, feature gates) are added to
/// [_redirect] in Phase 1; Phase 0 only needs the skeleton to render.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Two independent bottom-nav shells (attendee `/a`, organizer `/o`) plus the
/// auth stack. Each shell keeps its own tab state via `indexedStack`.
///
/// Guards (auth, organizer access, role, feature gates) are added to
/// [_redirect] in Phase 1; Phase 0 only needs the skeleton to render.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Two independent bottom-nav shells (attendee `/a`, organizer `/o`) plus the
  /// auth stack. Each shell keeps its own tab state via `indexedStack`.
  ///
  /// Guards (auth, organizer access, role, feature gates) are added to
  /// [_redirect] in Phase 1; Phase 0 only needs the skeleton to render.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'158e2f700f6e2873f5a92ed6c00724ec5ce3f839';
