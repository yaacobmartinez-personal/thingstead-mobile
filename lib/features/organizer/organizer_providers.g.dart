// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository wiring for the organizer side; one switch per feature.

@ProviderFor(orgEventsRepository)
final orgEventsRepositoryProvider = OrgEventsRepositoryProvider._();

/// Repository wiring for the organizer side; one switch per feature.

final class OrgEventsRepositoryProvider
    extends
        $FunctionalProvider<
          OrgEventsRepository,
          OrgEventsRepository,
          OrgEventsRepository
        >
    with $Provider<OrgEventsRepository> {
  /// Repository wiring for the organizer side; one switch per feature.
  OrgEventsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orgEventsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orgEventsRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrgEventsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrgEventsRepository create(Ref ref) {
    return orgEventsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrgEventsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrgEventsRepository>(value),
    );
  }
}

String _$orgEventsRepositoryHash() =>
    r'1660ce312b5bae457d409bb61201e636458353c6';

@ProviderFor(attendeesRepository)
final attendeesRepositoryProvider = AttendeesRepositoryProvider._();

final class AttendeesRepositoryProvider
    extends
        $FunctionalProvider<
          AttendeesRepository,
          AttendeesRepository,
          AttendeesRepository
        >
    with $Provider<AttendeesRepository> {
  AttendeesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendeesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendeesRepositoryHash();

  @$internal
  @override
  $ProviderElement<AttendeesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendeesRepository create(Ref ref) {
    return attendeesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendeesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendeesRepository>(value),
    );
  }
}

String _$attendeesRepositoryHash() =>
    r'bb46054e214ed1e50d75c5e38a1ff3180e649853';

@ProviderFor(checkinRepository)
final checkinRepositoryProvider = CheckinRepositoryProvider._();

final class CheckinRepositoryProvider
    extends
        $FunctionalProvider<
          CheckinRepository,
          CheckinRepository,
          CheckinRepository
        >
    with $Provider<CheckinRepository> {
  CheckinRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkinRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkinRepositoryHash();

  @$internal
  @override
  $ProviderElement<CheckinRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CheckinRepository create(Ref ref) {
    return checkinRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckinRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckinRepository>(value),
    );
  }
}

String _$checkinRepositoryHash() => r'9b8eb33b2a3a0097066db363fef83aed9a594866';
