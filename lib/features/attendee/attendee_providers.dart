import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/config/api_mode.dart';
import '../../core/config/app_config.dart';
import '../../core/connectivity/connectivity_provider.dart';
import '../../core/fake/fake_providers.dart';
import '../../core/network/api_client.dart';
import '../../core/time/clock.dart';
import 'orgs/data/fake_public_events_repository.dart';
import 'orgs/data/real_public_events_repository.dart';
import 'orgs/domain/public_events_repository.dart';
import 'registration/data/fake_registration_repository.dart';
import 'registration/data/real_registration_repository.dart';
import 'registration/domain/registration_repository.dart';
import 'tickets/data/fake_tickets_repository.dart';
import 'tickets/data/real_tickets_repository.dart';
import 'tickets/domain/tickets_repository.dart';

part 'attendee_providers.g.dart';

/// Repository wiring for the attendee side; one switch per feature.

@Riverpod(keepAlive: true)
PublicEventsRepository publicEventsRepository(Ref ref) => switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealPublicEventsRepository(ref.watch(apiClientProvider)),
      ApiMode.fake => FakePublicEventsRepository(
          ref.watch(fakeStoreProvider),
          ref.watch(fakeLatencyProvider),
          offline: () => !ref.read(isOnlineProvider),
        ),
    };

@Riverpod(keepAlive: true)
RegistrationRepository registrationRepository(Ref ref) => switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealRegistrationRepository(ref.watch(apiClientProvider)),
      ApiMode.fake => FakeRegistrationRepository(
          ref.watch(fakeStoreProvider),
          ref.watch(fakeLatencyProvider),
          () => ref.read(currentUserIdProvider),
          clock: ref.watch(clockProvider),
          offline: () => !ref.read(isOnlineProvider),
        ),
    };

@Riverpod(keepAlive: true)
TicketsRepository ticketsRepository(Ref ref) => switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealTicketsRepository(ref.watch(apiClientProvider)),
      ApiMode.fake => FakeTicketsRepository(
          ref.watch(fakeStoreProvider),
          ref.watch(fakeLatencyProvider),
          () => ref.read(currentUserIdProvider),
          clock: ref.watch(clockProvider),
          offline: () => !ref.read(isOnlineProvider),
        ),
    };
