import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/api_mode.dart';
import '../../../core/config/app_config.dart';
import '../../../core/fake/fake_providers.dart';
import '../../../core/network/api_client.dart';
import '../../../core/time/clock.dart';
import '../../organizer/orgs/data/fake_orgs_repository.dart';
import '../../organizer/orgs/data/real_orgs_repository.dart';
import '../../organizer/orgs/domain/orgs_repository.dart';
import '../domain/auth_repository.dart';
import 'apple_sign_in_service.dart';
import 'fake_auth_repository.dart';
import 'google_sign_in_service.dart';
import 'real_auth_repository.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealAuthRepository(ref.watch(apiClientProvider)),
      ApiMode.fake => FakeAuthRepository(
          ref.watch(fakeStoreProvider),
          ref.watch(fakeLatencyProvider),
          ref.watch(clockProvider),
          () => ref.read(currentUserIdProvider),
        ),
    };

@Riverpod(keepAlive: true)
OrgsRepository orgsRepository(Ref ref) => switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealOrgsRepository(ref.watch(apiClientProvider)),
      ApiMode.fake => FakeOrgsRepository(
          ref.watch(fakeStoreProvider),
          ref.watch(fakeLatencyProvider),
          () => ref.read(currentUserIdProvider),
        ),
    };

@Riverpod(keepAlive: true)
GoogleSignInService googleSignInService(Ref ref) =>
    switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealGoogleSignInService(
          serverClientId: AppConfig.googleWebClientId.isEmpty
              ? null
              : AppConfig.googleWebClientId,
          clientId: AppConfig.googleIosClientId.isEmpty
              ? null
              : AppConfig.googleIosClientId,
        ),
      ApiMode.fake => FakeGoogleSignInService(),
    };

@Riverpod(keepAlive: true)
AppleSignInService appleSignInService(Ref ref) =>
    switch (ref.watch(apiModeProvider)) {
      ApiMode.real => RealAppleSignInService(),
      ApiMode.fake => FakeAppleSignInService(),
    };
