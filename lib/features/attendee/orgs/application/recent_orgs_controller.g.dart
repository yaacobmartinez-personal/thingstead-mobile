// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_orgs_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Orgs the person has opened, newest first, so the Find tab offers them
/// back without a directory (discovery is links and codes only). Persisted
/// as JSON strings in prefs; capped so the list stays a shortcut.

@ProviderFor(RecentOrgs)
final recentOrgsProvider = RecentOrgsProvider._();

/// Orgs the person has opened, newest first, so the Find tab offers them
/// back without a directory (discovery is links and codes only). Persisted
/// as JSON strings in prefs; capped so the list stays a shortcut.
final class RecentOrgsProvider
    extends $AsyncNotifierProvider<RecentOrgs, List<PublicOrg>> {
  /// Orgs the person has opened, newest first, so the Find tab offers them
  /// back without a directory (discovery is links and codes only). Persisted
  /// as JSON strings in prefs; capped so the list stays a shortcut.
  RecentOrgsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentOrgsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentOrgsHash();

  @$internal
  @override
  RecentOrgs create() => RecentOrgs();
}

String _$recentOrgsHash() => r'a2dd1cdcc8ae72060f00a44b708169e88ce1a735';

/// Orgs the person has opened, newest first, so the Find tab offers them
/// back without a directory (discovery is links and codes only). Persisted
/// as JSON strings in prefs; capped so the list stays a shortcut.

abstract class _$RecentOrgs extends $AsyncNotifier<List<PublicOrg>> {
  FutureOr<List<PublicOrg>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<PublicOrg>>, List<PublicOrg>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PublicOrg>>, List<PublicOrg>>,
              AsyncValue<List<PublicOrg>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
