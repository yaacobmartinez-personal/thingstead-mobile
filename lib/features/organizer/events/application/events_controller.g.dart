// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The org's events with counts. Invalidated by check-in controllers after
/// a successful mutation so the numbers on the cards stay current (the Expo
/// app refetched on focus for the same reason).

@ProviderFor(orgEvents)
final orgEventsProvider = OrgEventsFamily._();

/// The org's events with counts. Invalidated by check-in controllers after
/// a successful mutation so the numbers on the cards stay current (the Expo
/// app refetched on focus for the same reason).

final class OrgEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<EventsPage>,
          EventsPage,
          FutureOr<EventsPage>
        >
    with $FutureModifier<EventsPage>, $FutureProvider<EventsPage> {
  /// The org's events with counts. Invalidated by check-in controllers after
  /// a successful mutation so the numbers on the cards stay current (the Expo
  /// app refetched on focus for the same reason).
  OrgEventsProvider._({
    required OrgEventsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orgEventsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orgEventsHash();

  @override
  String toString() {
    return r'orgEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EventsPage> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<EventsPage> create(Ref ref) {
    final argument = this.argument as String;
    return orgEvents(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrgEventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orgEventsHash() => r'5cce109c0a5e29586afd6d90f9341a374976b93e';

/// The org's events with counts. Invalidated by check-in controllers after
/// a successful mutation so the numbers on the cards stay current (the Expo
/// app refetched on focus for the same reason).

final class OrgEventsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EventsPage>, String> {
  OrgEventsFamily._()
    : super(
        retry: null,
        name: r'orgEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The org's events with counts. Invalidated by check-in controllers after
  /// a successful mutation so the numbers on the cards stay current (the Expo
  /// app refetched on focus for the same reason).

  OrgEventsProvider call(String org) =>
      OrgEventsProvider._(argument: org, from: this);

  @override
  String toString() => r'orgEventsProvider';
}
