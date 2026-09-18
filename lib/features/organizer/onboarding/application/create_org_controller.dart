import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/application/auth_controller.dart';
import '../../../auth/data/auth_providers.dart';
import '../../../shell/application/app_mode_controller.dart';
import '../../orgs/application/selected_org_controller.dart';
import '../../orgs/domain/org.dart';
import '../../orgs/domain/orgs_repository.dart';
import 'organize_intent.dart';

part 'create_org_controller.g.dart';

/// Organization setup (API-CONTRACT #34–#35). Stateless and kept alive so the
/// membership refresh finishes even if the screen goes away mid-call.
@Riverpod(keepAlive: true)
class CreateOrg extends _$CreateOrg {
  @override
  void build() {}

  Future<SlugAvailability> check(String slug) =>
      ref.read(orgsRepositoryProvider).availability(slug);

  /// Creates the org, reloads memberships so [AuthState.hasOrganizerAccess]
  /// flips, selects it, and switches to the organizer shell — the same state
  /// a fresh sign-in with a membership lands in.
  Future<Org> submit({required String name, required String slug}) async {
    final org = await ref.read(orgsRepositoryProvider).create(name: name, slug: slug);
    await ref.read(authControllerProvider.notifier).refreshOrgs();
    ref.read(selectedOrgSlugProvider.notifier).set(org.slug);
    ref.read(appModeControllerProvider.notifier).set(AppMode.organizer);
    ref.read(organizeIntentProvider.notifier).set(false);
    return org;
  }
}
