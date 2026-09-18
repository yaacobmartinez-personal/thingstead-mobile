// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One event with its counts (API-CONTRACT #18). Re-fetched after every
/// mutation below so the detail screen never shows a stale status or count.

@ProviderFor(eventDetail)
final eventDetailProvider = EventDetailFamily._();

/// One event with its counts (API-CONTRACT #18). Re-fetched after every
/// mutation below so the detail screen never shows a stale status or count.

final class EventDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<EventDetail>,
          EventDetail,
          FutureOr<EventDetail>
        >
    with $FutureModifier<EventDetail>, $FutureProvider<EventDetail> {
  /// One event with its counts (API-CONTRACT #18). Re-fetched after every
  /// mutation below so the detail screen never shows a stale status or count.
  EventDetailProvider._({
    required EventDetailFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'eventDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventDetailHash();

  @override
  String toString() {
    return r'eventDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<EventDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EventDetail> create(Ref ref) {
    final argument = this.argument as (String, String);
    return eventDetail(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is EventDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventDetailHash() => r'6ddf38ffa0dc8dfd28c10ba5c67dddc4fc87d611';

/// One event with its counts (API-CONTRACT #18). Re-fetched after every
/// mutation below so the detail screen never shows a stale status or count.

final class EventDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EventDetail>, (String, String)> {
  EventDetailFamily._()
    : super(
        retry: null,
        name: r'eventDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One event with its counts (API-CONTRACT #18). Re-fetched after every
  /// mutation below so the detail screen never shows a stale status or count.

  EventDetailProvider call(String org, String slug) =>
      EventDetailProvider._(argument: (org, slug), from: this);

  @override
  String toString() => r'eventDetailProvider';
}

/// Event mutations (#19–#22). Stateless; kept alive so an in-flight call is
/// never cut short by the caller's screen going away. Every method
/// invalidates the list and the detail so the UI refetches on return.

@ProviderFor(EventActions)
final eventActionsProvider = EventActionsProvider._();

/// Event mutations (#19–#22). Stateless; kept alive so an in-flight call is
/// never cut short by the caller's screen going away. Every method
/// invalidates the list and the detail so the UI refetches on return.
final class EventActionsProvider extends $NotifierProvider<EventActions, void> {
  /// Event mutations (#19–#22). Stateless; kept alive so an in-flight call is
  /// never cut short by the caller's screen going away. Every method
  /// invalidates the list and the detail so the UI refetches on return.
  EventActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventActionsHash();

  @$internal
  @override
  EventActions create() => EventActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$eventActionsHash() => r'85445a651f96f19c1183b1115b3596e232be58ca';

/// Event mutations (#19–#22). Stateless; kept alive so an in-flight call is
/// never cut short by the caller's screen going away. Every method
/// invalidates the list and the detail so the UI refetches on return.

abstract class _$EventActions extends $Notifier<void> {
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
