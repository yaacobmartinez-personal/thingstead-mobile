// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendee_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Promote, erase, and export (API-CONTRACT #25–#27). After a change the
/// list is refetched into the cache (which is what the screen renders) and
/// the event counts are invalidated.

@ProviderFor(AttendeeActions)
final attendeeActionsProvider = AttendeeActionsProvider._();

/// Promote, erase, and export (API-CONTRACT #25–#27). After a change the
/// list is refetched into the cache (which is what the screen renders) and
/// the event counts are invalidated.
final class AttendeeActionsProvider
    extends $NotifierProvider<AttendeeActions, void> {
  /// Promote, erase, and export (API-CONTRACT #25–#27). After a change the
  /// list is refetched into the cache (which is what the screen renders) and
  /// the event counts are invalidated.
  AttendeeActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendeeActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendeeActionsHash();

  @$internal
  @override
  AttendeeActions create() => AttendeeActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$attendeeActionsHash() => r'27120d8bd8dad987bdce555614be7f977749799c';

/// Promote, erase, and export (API-CONTRACT #25–#27). After a change the
/// list is refetched into the cache (which is what the screen renders) and
/// the event counts are invalidated.

abstract class _$AttendeeActions extends $Notifier<void> {
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
