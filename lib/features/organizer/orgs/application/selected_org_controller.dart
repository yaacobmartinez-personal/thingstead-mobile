import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/boot_data.dart';
import '../../../../core/storage/prefs.dart';
import '../../../auth/application/auth_controller.dart';
import '../domain/org.dart';

part 'selected_org_controller.g.dart';

/// The org the organizer shell is showing. Stored as a slug, persisted, and
/// resolved against the signed-in user's memberships so a revoked membership
/// simply falls back to the first org.
@Riverpod(keepAlive: true)
class SelectedOrgSlug extends _$SelectedOrgSlug {
  @override
  String? build() => ref.watch(bootDataProvider).selectedOrgSlug;

  void set(String? slug) {
    if (state == slug) return;
    state = slug;
    ref.read(prefsProvider).setString(Prefs.keySelectedOrg, slug);
  }
}

/// The resolved [Org], or null when the user has no memberships.
@Riverpod(keepAlive: true)
Org? selectedOrg(Ref ref) {
  final orgs = ref.watch(authControllerProvider.select((s) => s.orgs));
  if (orgs.isEmpty) return null;
  final slug = ref.watch(selectedOrgSlugProvider);
  return orgs.where((o) => o.slug == slug).firstOrNull ?? orgs.first;
}
