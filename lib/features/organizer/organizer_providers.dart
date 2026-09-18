import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/config/api_mode.dart';
import '../../core/config/app_config.dart';
import '../../core/connectivity/connectivity_provider.dart';
import '../../core/fake/fake_providers.dart';
import '../../core/network/api_client.dart';
import '../../core/time/clock.dart';
import 'attendees/data/fake_attendees_repository.dart';
import 'attendees/data/real_attendees_repository.dart';
import 'attendees/domain/attendees_repository.dart';
import 'checkin/data/fake_checkin_repository.dart';
import 'checkin/data/real_checkin_repository.dart';
import 'checkin/domain/checkin_repository.dart';
import 'events/data/fake_org_events_repository.dart';
import 'events/data/real_org_events_repository.dart';
import 'events/domain/org_events_repository.dart';
import 'team/data/fake_team_repository.dart';
import 'team/data/real_team_repository.dart';
import 'team/domain/team_repository.dart';

part 'organizer_providers.g.dart';

/// Repository wiring for the organizer side; one switch per feature.

@Riverpod(keepAlive: true)
OrgEventsRepository orgEventsRepository(Ref ref) => switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealOrgEventsRepository(ref.watch(apiClientProvider)),
      ApiMode.fake => FakeOrgEventsRepository(
          ref.watch(fakeStoreProvider),
          ref.watch(fakeLatencyProvider),
          () => ref.read(currentUserIdProvider),
          clock: ref.watch(clockProvider),
          offline: () => !ref.read(isOnlineProvider),
        ),
    };

@Riverpod(keepAlive: true)
AttendeesRepository attendeesRepository(Ref ref) => switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealAttendeesRepository(ref.watch(apiClientProvider)),
      ApiMode.fake => FakeAttendeesRepository(
          ref.watch(fakeStoreProvider),
          ref.watch(fakeLatencyProvider),
          () => ref.read(currentUserIdProvider),
          clock: ref.watch(clockProvider),
          offline: () => !ref.read(isOnlineProvider),
        ),
    };

@Riverpod(keepAlive: true)
CheckinRepository checkinRepository(Ref ref) => switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealCheckinRepository(ref.watch(apiClientProvider)),
      ApiMode.fake => FakeCheckinRepository(
          ref.watch(fakeStoreProvider),
          ref.watch(fakeLatencyProvider),
          ref.watch(clockProvider),
          () => ref.read(currentUserIdProvider),
          offline: () => !ref.read(isOnlineProvider),
        ),
    };

@Riverpod(keepAlive: true)
TeamRepository teamRepository(Ref ref) => switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealTeamRepository(ref.watch(apiClientProvider)),
      ApiMode.fake => FakeTeamRepository(
          ref.watch(fakeStoreProvider),
          ref.watch(fakeLatencyProvider),
          () => ref.read(currentUserIdProvider),
          clock: ref.watch(clockProvider),
          offline: () => !ref.read(isOnlineProvider),
        ),
    };
