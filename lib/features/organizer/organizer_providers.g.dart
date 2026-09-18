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
    r'8929c46f98ecf0f47f9900bf108901bffb035a80';

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
    r'2fbf7b7a449b6b7f1613134bd61c3afacf232dbf';

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

String _$checkinRepositoryHash() => r'9037879dcba254ffef84acc5937a5db89e09fa4c';

@ProviderFor(teamRepository)
final teamRepositoryProvider = TeamRepositoryProvider._();

final class TeamRepositoryProvider
    extends $FunctionalProvider<TeamRepository, TeamRepository, TeamRepository>
    with $Provider<TeamRepository> {
  TeamRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamRepositoryHash();

  @$internal
  @override
  $ProviderElement<TeamRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TeamRepository create(Ref ref) {
    return teamRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TeamRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TeamRepository>(value),
    );
  }
}

String _$teamRepositoryHash() => r'2fe5f98b3c8b0910da00e58b4c58d19f91612683';
