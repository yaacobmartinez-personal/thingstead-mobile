import '../../../../core/model/enums.dart';
import 'team.dart';

/// All ADMIN-only (API-CONTRACT #28–#32).
abstract class TeamRepository {
  Future<TeamPage> get(String orgSlug);
  Future<InviteResult> invite(String orgSlug, {required String email, required Role role});
  Future<void> revoke(String orgSlug, String invitationId);

  /// 409 `last_admin` when demoting the only admin.
  Future<TeamMember> changeRole(String orgSlug, String membershipId, Role role);

  /// 409 `last_admin` when removing the only admin. Self = leave.
  Future<void> remove(String orgSlug, String membershipId);
}
