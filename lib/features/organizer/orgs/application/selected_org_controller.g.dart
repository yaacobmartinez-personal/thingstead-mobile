// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_org_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The org the organizer shell is showing. Stored as a slug, persisted, and
/// resolved against the signed-in user's memberships so a revoked membership
/// simply falls back to the first org.

@ProviderFor(SelectedOrgSlug)
final selectedOrgSlugProvider = SelectedOrgSlugProvider._();

/// The org the organizer shell is showing. Stored as a slug, persisted, and
/// resolved against the signed-in user's memberships so a revoked membership
/// simply falls back to the first org.
final class SelectedOrgSlugProvider
    extends $NotifierProvider<SelectedOrgSlug, String?> {
  /// The org the organizer shell is showing. Stored as a slug, persisted, and
  /// resolved against the signed-in user's memberships so a revoked membership
  /// simply falls back to the first org.
  SelectedOrgSlugProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedOrgSlugProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedOrgSlugHash();

  @$internal
  @override
  SelectedOrgSlug create() => SelectedOrgSlug();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedOrgSlugHash() => r'cfb5b57cc103b0519800d5a76f1e90932d71157a';

/// The org the organizer shell is showing. Stored as a slug, persisted, and
/// resolved against the signed-in user's memberships so a revoked membership
/// simply falls back to the first org.

abstract class _$SelectedOrgSlug extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The resolved [Org], or null when the user has no memberships.

@ProviderFor(selectedOrg)
final selectedOrgProvider = SelectedOrgProvider._();

/// The resolved [Org], or null when the user has no memberships.

final class SelectedOrgProvider extends $FunctionalProvider<Org?, Org?, Org?>
    with $Provider<Org?> {
  /// The resolved [Org], or null when the user has no memberships.
  SelectedOrgProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedOrgProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedOrgHash();

  @$internal
  @override
  $ProviderElement<Org?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Org? create(Ref ref) {
    return selectedOrg(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Org? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Org?>(value),
    );
  }
}

String _$selectedOrgHash() => r'08e4640368ea1ef3a4a01bba653b2af841547b33';
