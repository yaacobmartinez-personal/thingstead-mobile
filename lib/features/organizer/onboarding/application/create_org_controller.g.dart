// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_org_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Organization setup (API-CONTRACT #34–#35). Stateless and kept alive so the
/// membership refresh finishes even if the screen goes away mid-call.

@ProviderFor(CreateOrg)
final createOrgProvider = CreateOrgProvider._();

/// Organization setup (API-CONTRACT #34–#35). Stateless and kept alive so the
/// membership refresh finishes even if the screen goes away mid-call.
final class CreateOrgProvider extends $NotifierProvider<CreateOrg, void> {
  /// Organization setup (API-CONTRACT #34–#35). Stateless and kept alive so the
  /// membership refresh finishes even if the screen goes away mid-call.
  CreateOrgProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createOrgProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createOrgHash();

  @$internal
  @override
  CreateOrg create() => CreateOrg();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$createOrgHash() => r'974cb46cf0ca49e4aba5849bffd858457294dc4e';

/// Organization setup (API-CONTRACT #34–#35). Stateless and kept alive so the
/// membership refresh finishes even if the screen goes away mid-call.

abstract class _$CreateOrg extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
