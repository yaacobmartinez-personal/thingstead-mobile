// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the offline queue: counts for the badge, and drains whenever
/// something suggests the server is reachable again — connectivity comes
/// back, the app resumes, an op is enqueued, or a minute passes with work
/// still pending. Also wipes local data when the session ends.

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

/// Drives the offline queue: counts for the badge, and drains whenever
/// something suggests the server is reachable again — connectivity comes
/// back, the app resumes, an op is enqueued, or a minute passes with work
/// still pending. Also wipes local data when the session ends.
final class SyncControllerProvider
    extends $NotifierProvider<SyncController, SyncStatus> {
  /// Drives the offline queue: counts for the badge, and drains whenever
  /// something suggests the server is reachable again — connectivity comes
  /// back, the app resumes, an op is enqueued, or a minute passes with work
  /// still pending. Also wipes local data when the session ends.
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncStatus>(value),
    );
  }
}

String _$syncControllerHash() => r'8563a3ca6c2cf80b83ce32075b0f4d87e35ef265';

/// Drives the offline queue: counts for the badge, and drains whenever
/// something suggests the server is reachable again — connectivity comes
/// back, the app resumes, an op is enqueued, or a minute passes with work
/// still pending. Also wipes local data when the session ends.

abstract class _$SyncController extends $Notifier<SyncStatus> {
  SyncStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncStatus, SyncStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncStatus, SyncStatus>,
              SyncStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
