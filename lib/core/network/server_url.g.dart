// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_url.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which Thingstead deployment the app talks to. Per-install so one build
/// works against the live site, a staging box, or a laptop on the same Wi-Fi.

@ProviderFor(ServerUrl)
final serverUrlProvider = ServerUrlProvider._();

/// Which Thingstead deployment the app talks to. Per-install so one build
/// works against the live site, a staging box, or a laptop on the same Wi-Fi.
final class ServerUrlProvider extends $NotifierProvider<ServerUrl, String> {
  /// Which Thingstead deployment the app talks to. Per-install so one build
  /// works against the live site, a staging box, or a laptop on the same Wi-Fi.
  ServerUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverUrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverUrlHash();

  @$internal
  @override
  ServerUrl create() => ServerUrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$serverUrlHash() => r'06d5fca7e187b152f41bff03c71002cd55a6acda';

/// Which Thingstead deployment the app talks to. Per-install so one build
/// works against the live site, a staging box, or a laptop on the same Wi-Fi.

abstract class _$ServerUrl extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
