// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organize_intent.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "I'm here to organize events", chosen at signup. Persisted because the
/// verification step may come back through an emailed link (or a relaunch),
/// so nothing in memory survives to the point where it is needed.

@ProviderFor(OrganizeIntent)
final organizeIntentProvider = OrganizeIntentProvider._();

/// "I'm here to organize events", chosen at signup. Persisted because the
/// verification step may come back through an emailed link (or a relaunch),
/// so nothing in memory survives to the point where it is needed.
final class OrganizeIntentProvider
    extends $NotifierProvider<OrganizeIntent, bool> {
  /// "I'm here to organize events", chosen at signup. Persisted because the
  /// verification step may come back through an emailed link (or a relaunch),
  /// so nothing in memory survives to the point where it is needed.
  OrganizeIntentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizeIntentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizeIntentHash();

  @$internal
  @override
  OrganizeIntent create() => OrganizeIntent();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$organizeIntentHash() => r'0456baacfd0dbdcb184e2416a77a01039b824930';

/// "I'm here to organize events", chosen at signup. Persisted because the
/// verification step may come back through an emailed link (or a relaunch),
/// so nothing in memory survives to the point where it is needed.

abstract class _$OrganizeIntent extends $Notifier<bool> {
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
