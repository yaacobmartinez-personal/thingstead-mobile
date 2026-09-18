// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_events_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// An org's published events (API-CONTRACT #11). Public: no session needed.

@ProviderFor(publicEvents)
final publicEventsProvider = PublicEventsFamily._();

/// An org's published events (API-CONTRACT #11). Public: no session needed.

final class PublicEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PublicEventsPage>,
          PublicEventsPage,
          FutureOr<PublicEventsPage>
        >
    with $FutureModifier<PublicEventsPage>, $FutureProvider<PublicEventsPage> {
  /// An org's published events (API-CONTRACT #11). Public: no session needed.
  PublicEventsProvider._({
    required PublicEventsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'publicEventsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$publicEventsHash();

  @override
  String toString() {
    return r'publicEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PublicEventsPage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PublicEventsPage> create(Ref ref) {
    final argument = this.argument as String;
    return publicEvents(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicEventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publicEventsHash() => r'c0877078ca703bdfc0dba186e19c3539585f3603';

/// An org's published events (API-CONTRACT #11). Public: no session needed.

final class PublicEventsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PublicEventsPage>, String> {
  PublicEventsFamily._()
    : super(
        retry: null,
        name: r'publicEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// An org's published events (API-CONTRACT #11). Public: no session needed.

  PublicEventsProvider call(String org) =>
      PublicEventsProvider._(argument: org, from: this);

  @override
  String toString() => r'publicEventsProvider';
}

/// One public event with its description and availability (#12).
/// Invalidated after a registration so the places-left line is current.

@ProviderFor(publicEvent)
final publicEventProvider = PublicEventFamily._();

/// One public event with its description and availability (#12).
/// Invalidated after a registration so the places-left line is current.

final class PublicEventProvider
    extends
        $FunctionalProvider<
          AsyncValue<PublicEventPage>,
          PublicEventPage,
          FutureOr<PublicEventPage>
        >
    with $FutureModifier<PublicEventPage>, $FutureProvider<PublicEventPage> {
  /// One public event with its description and availability (#12).
  /// Invalidated after a registration so the places-left line is current.
  PublicEventProvider._({
    required PublicEventFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'publicEventProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$publicEventHash();

  @override
  String toString() {
    return r'publicEventProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PublicEventPage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PublicEventPage> create(Ref ref) {
    final argument = this.argument as (String, String);
    return publicEvent(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicEventProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publicEventHash() => r'c17a7b9b2f76d735eb7e63b89fd59e6492d1b91b';

/// One public event with its description and availability (#12).
/// Invalidated after a registration so the places-left line is current.

final class PublicEventFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<PublicEventPage>, (String, String)> {
  PublicEventFamily._()
    : super(
        retry: null,
        name: r'publicEventProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One public event with its description and availability (#12).
  /// Invalidated after a registration so the places-left line is current.

  PublicEventProvider call(String org, String event) =>
      PublicEventProvider._(argument: (org, event), from: this);

  @override
  String toString() => r'publicEventProvider';
}
