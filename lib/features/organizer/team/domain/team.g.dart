// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) => _TeamMember(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String?,
  email: json['email'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role']),
  isSelf: json['isSelf'] as bool? ?? false,
  joinedAt: DateTime.parse(json['joinedAt'] as String),
);

Map<String, dynamic> _$TeamMemberToJson(_TeamMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'role': _$RoleEnumMap[instance.role]!,
      'isSelf': instance.isSelf,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

const _$RoleEnumMap = {Role.admin: 'ADMIN', Role.staff: 'STAFF'};

_TeamInvitation _$TeamInvitationFromJson(Map<String, dynamic> json) =>
    _TeamInvitation(
      id: json['id'] as String,
      email: json['email'] as String,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      expired: json['expired'] as bool? ?? false,
    );

Map<String, dynamic> _$TeamInvitationToJson(_TeamInvitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': _$RoleEnumMap[instance.role]!,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'expired': instance.expired,
    };

_TeamPage _$TeamPageFromJson(Map<String, dynamic> json) => _TeamPage(
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TeamMember>[],
  invitations:
      (json['invitations'] as List<dynamic>?)
          ?.map((e) => TeamInvitation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TeamInvitation>[],
  adminCount: (json['adminCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TeamPageToJson(_TeamPage instance) => <String, dynamic>{
  'members': instance.members,
  'invitations': instance.invitations,
  'adminCount': instance.adminCount,
};
