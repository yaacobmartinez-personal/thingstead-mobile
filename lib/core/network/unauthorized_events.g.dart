// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unauthorized_events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(unauthorizedEvents)
final unauthorizedEventsProvider = UnauthorizedEventsProvider._();

final class UnauthorizedEventsProvider
    extends
        $FunctionalProvider<
          UnauthorizedEvents,
          UnauthorizedEvents,
          UnauthorizedEvents
        >
    with $Provider<UnauthorizedEvents> {
  UnauthorizedEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unauthorizedEventsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unauthorizedEventsHash();

  @$internal
  @override
  $ProviderElement<UnauthorizedEvents> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UnauthorizedEvents create(Ref ref) {
    return unauthorizedEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnauthorizedEvents value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnauthorizedEvents>(value),
    );
  }
}

String _$unauthorizedEventsHash() =>
    r'e40bfaf1c43b1c294007570ca7ae7ab8b8d1e9e6';

/// True while a request is being retried because the server looks asleep
/// (Render's free tier cold-starts in 30–60 s). Screens show "Waking the
/// server…" instead of a raw timeout.

@ProviderFor(ServerWaking)
final serverWakingProvider = ServerWakingProvider._();

/// True while a request is being retried because the server looks asleep
/// (Render's free tier cold-starts in 30–60 s). Screens show "Waking the
/// server…" instead of a raw timeout.
final class ServerWakingProvider extends $NotifierProvider<ServerWaking, bool> {
  /// True while a request is being retried because the server looks asleep
  /// (Render's free tier cold-starts in 30–60 s). Screens show "Waking the
  /// server…" instead of a raw timeout.
  ServerWakingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverWakingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverWakingHash();

  @$internal
  @override
  ServerWaking create() => ServerWaking();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$serverWakingHash() => r'8fe2422c44a5d59e5e77816419760b6f6293a567';

/// True while a request is being retried because the server looks asleep
/// (Render's free tier cold-starts in 30–60 s). Screens show "Waking the
/// server…" instead of a raw timeout.

abstract class _$ServerWaking extends $Notifier<bool> {
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
