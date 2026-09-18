import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error.dart';
import '../domain/team.dart';
import '../domain/team_repository.dart';

class RealTeamRepository implements TeamRepository {
  RealTeamRepository(this._api);

  final ApiClient _api;

  String _base(String org) => '/mobile/orgs/${Uri.encodeComponent(org)}/team';

  void _require() {
    if (!isAvailable(Feature.team, ApiMode.real)) throw ApiError.notAvailable();
  }

  @override
  Future<TeamPage> get(String orgSlug) async {
    _require();
    return TeamPage.fromJson(await _api.get(_base(orgSlug)));
  }

  @override
  Future<InviteResult> invite(String orgSlug, {required String email, required Role role}) async {
    _require();
    final json = await _api.post(
      '${_base(orgSlug)}/invitations',
      body: {'email': email.trim(), 'role': role.wire},
    );
    if (json['alreadyMember'] == true) return const InviteResult(alreadyMember: true);
    return InviteResult(
      invitation: TeamInvitation.fromJson(json['invitation'] as Map<String, dynamic>),
    );
  }

  @override
  Future<void> revoke(String orgSlug, String invitationId) async {
    _require();
    await _api.delete('${_base(orgSlug)}/invitations/${Uri.encodeComponent(invitationId)}');
  }

  @override
  Future<TeamMember> changeRole(String orgSlug, String membershipId, Role role) async {
    _require();
    final json = await _api.patch(
      '${_base(orgSlug)}/members/${Uri.encodeComponent(membershipId)}',
      body: {'role': role.wire},
    );
    return TeamMember.fromJson(json['member'] as Map<String, dynamic>);
  }

  @override
  Future<void> remove(String orgSlug, String membershipId) async {
    _require();
    await _api.delete('${_base(orgSlug)}/members/${Uri.encodeComponent(membershipId)}');
  }
}
