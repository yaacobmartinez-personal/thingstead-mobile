import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/model/enums.dart';
import '../../../auth/application/auth_controller.dart';
import '../../organizer_providers.dart';
import '../domain/team.dart';

part 'team_controller.g.dart';

/// The org's members and pending invitations, with the ADMIN-only actions
/// (API-CONTRACT #28–#32). Every action refetches the page afterwards; the
/// server is the source of truth for the last-admin rule.
@riverpod
class TeamController extends _$TeamController {
  @override
  Future<TeamPage> build(String org) => ref.watch(teamRepositoryProvider).get(org);

  Future<InviteResult> invite({required String email, required Role role}) async {
    final result = await ref.read(teamRepositoryProvider).invite(org, email: email, role: role);
    await _reload();
    return result;
  }

  Future<void> revoke(String invitationId) async {
    await ref.read(teamRepositoryProvider).revoke(org, invitationId);
    await _reload();
  }

  Future<void> changeRole(String membershipId, Role role) async {
    await ref.read(teamRepositoryProvider).changeRole(org, membershipId, role);
    await _reload();
  }

  /// Removing yourself leaves the org; the memberships list is refreshed so
  /// the shell drops it (and organizer mode if it was the last one).
  Future<void> remove(String membershipId, {bool self = false}) async {
    await ref.read(teamRepositoryProvider).remove(org, membershipId);
    if (self) {
      await ref.read(authControllerProvider.notifier).refreshOrgs();
      return;
    }
    await _reload();
  }

  Future<void> _reload() async {
    state = await AsyncValue.guard(() => ref.read(teamRepositoryProvider).get(org));
  }
}
