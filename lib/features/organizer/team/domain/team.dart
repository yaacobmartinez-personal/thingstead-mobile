import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/enums.dart';

part 'team.freezed.dart';
part 'team.g.dart';

/// One membership row (API-CONTRACT #28).
@freezed
abstract class TeamMember with _$TeamMember {
  const factory TeamMember({
    required String id,
    required String userId,
    String? name,
    required String email,
    required Role role,
    @Default(false) bool isSelf,
    required DateTime joinedAt,
  }) = _TeamMember;

  const TeamMember._();

  factory TeamMember.fromJson(Map<String, dynamic> json) => _$TeamMemberFromJson(json);

  bool get isAdmin => role == Role.admin;
  String get displayName => (name ?? '').trim().isEmpty ? email : name!.trim();
}

@freezed
abstract class TeamInvitation with _$TeamInvitation {
  const factory TeamInvitation({
    required String id,
    required String email,
    required Role role,
    required DateTime expiresAt,
    @Default(false) bool expired,
  }) = _TeamInvitation;

  factory TeamInvitation.fromJson(Map<String, dynamic> json) =>
      _$TeamInvitationFromJson(json);
}

@freezed
abstract class TeamPage with _$TeamPage {
  const factory TeamPage({
    @Default(<TeamMember>[]) List<TeamMember> members,
    @Default(<TeamInvitation>[]) List<TeamInvitation> invitations,
    @Default(0) int adminCount,
  }) = _TeamPage;

  const TeamPage._();

  factory TeamPage.fromJson(Map<String, dynamic> json) => _$TeamPageFromJson(json);

  /// The web's rule: an admin may be demoted or removed only if another
  /// admin remains.
  bool canReduceAdmin(TeamMember m) => !m.isAdmin || adminCount > 1;
}

/// Result of an invite (#29): a fresh invitation, or "already a member".
class InviteResult {
  const InviteResult({this.invitation, this.alreadyMember = false});

  final TeamInvitation? invitation;
  final bool alreadyMember;
}

/// Role copy from regista/lib/authz.ts.
abstract final class RoleCopy {
  static String label(Role r) => r == Role.admin ? 'Admin' : 'Staff';
  static String summary(Role r) => r == Role.admin
      ? 'Can manage events, attendees, and the team.'
      : 'Can manage events and attendees, but not the team.';
}
