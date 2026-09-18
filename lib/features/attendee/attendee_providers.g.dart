// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendee_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository wiring for the attendee side; one switch per feature.

@ProviderFor(publicEventsRepository)
final publicEventsRepositoryProvider = PublicEventsRepositoryProvider._();

/// Repository wiring for the attendee side; one switch per feature.

final class PublicEventsRepositoryProvider
    extends
        $FunctionalProvider<
          PublicEventsRepository,
          PublicEventsRepository,
          PublicEventsRepository
        >
    with $Provider<PublicEventsRepository> {
  /// Repository wiring for the attendee side; one switch per feature.
  PublicEventsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicEventsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicEventsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PublicEventsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PublicEventsRepository create(Ref ref) {
    return publicEventsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PublicEventsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PublicEventsRepository>(value),
    );
  }
}

String _$publicEventsRepositoryHash() =>
    r'ed5dce8f4152d9f445300908bef6c465354ea88c';

@ProviderFor(registrationRepository)
final registrationRepositoryProvider = RegistrationRepositoryProvider._();

final class RegistrationRepositoryProvider
    extends
        $FunctionalProvider<
          RegistrationRepository,
          RegistrationRepository,
          RegistrationRepository
        >
    with $Provider<RegistrationRepository> {
  RegistrationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registrationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registrationRepositoryHash();

  @$internal
  @override
  $ProviderElement<RegistrationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegistrationRepository create(Ref ref) {
    return registrationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegistrationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegistrationRepository>(value),
    );
  }
}

String _$registrationRepositoryHash() =>
    r'10219e6b8a83c34aa9c3cab7481b08bf6a16f3bc';

@ProviderFor(ticketsRepository)
final ticketsRepositoryProvider = TicketsRepositoryProvider._();

final class TicketsRepositoryProvider
    extends
        $FunctionalProvider<
          TicketsRepository,
          TicketsRepository,
          TicketsRepository
        >
    with $Provider<TicketsRepository> {
  TicketsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketsRepositoryHash();

  @$internal
  @override
  $ProviderElement<TicketsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TicketsRepository create(Ref ref) {
    return ticketsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TicketsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TicketsRepository>(value),
    );
  }
}

String _$ticketsRepositoryHash() => r'547879caf45cec55a9ce22cdbc286336683b1286';
