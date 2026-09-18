// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendees_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the list and applies manual check-in toggles optimistically, rolling
/// back on failure — port of `toggle` in the Expo AttendeesScreen.

@ProviderFor(AttendeesController)
final attendeesControllerProvider = AttendeesControllerFamily._();

/// Loads the list and applies manual check-in toggles optimistically, rolling
/// back on failure — port of `toggle` in the Expo AttendeesScreen.
final class AttendeesControllerProvider
    extends $AsyncNotifierProvider<AttendeesController, AttendeesState> {
  /// Loads the list and applies manual check-in toggles optimistically, rolling
  /// back on failure — port of `toggle` in the Expo AttendeesScreen.
  AttendeesControllerProvider._({
    required AttendeesControllerFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'attendeesControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$attendeesControllerHash();

  @override
  String toString() {
    return r'attendeesControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  AttendeesController create() => AttendeesController();

  @override
  bool operator ==(Object other) {
    return other is AttendeesControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$attendeesControllerHash() =>
    r'430d9f0bfe9ed550a486730759247afcad39d07b';

/// Loads the list and applies manual check-in toggles optimistically, rolling
/// back on failure — port of `toggle` in the Expo AttendeesScreen.

final class AttendeesControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AttendeesController,
          AsyncValue<AttendeesState>,
          AttendeesState,
          FutureOr<AttendeesState>,
          (String, String)
        > {
  AttendeesControllerFamily._()
    : super(
        retry: null,
        name: r'attendeesControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads the list and applies manual check-in toggles optimistically, rolling
  /// back on failure — port of `toggle` in the Expo AttendeesScreen.

  AttendeesControllerProvider call(String org, String event) =>
      AttendeesControllerProvider._(argument: (org, event), from: this);

  @override
  String toString() => r'attendeesControllerProvider';
}

/// Loads the list and applies manual check-in toggles optimistically, rolling
/// back on failure — port of `toggle` in the Expo AttendeesScreen.

abstract class _$AttendeesController extends $AsyncNotifier<AttendeesState> {
  late final _$args = ref.$arg as (String, String);
  String get org => _$args.$1;
  String get event => _$args.$2;

  FutureOr<AttendeesState> build(String org, String event);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AttendeesState>, AttendeesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AttendeesState>, AttendeesState>,
              AsyncValue<AttendeesState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
