// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'org.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Org _$OrgFromJson(Map<String, dynamic> json) => _Org(
  slug: json['slug'] as String,
  name: json['name'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role']),
  plan: $enumDecodeNullable(_$PlanTierEnumMap, json['plan']) ?? PlanTier.free,
);

Map<String, dynamic> _$OrgToJson(_Org instance) => <String, dynamic>{
  'slug': instance.slug,
  'name': instance.name,
  'role': _$RoleEnumMap[instance.role]!,
  'plan': _$PlanTierEnumMap[instance.plan]!,
};

const _$RoleEnumMap = {Role.admin: 'ADMIN', Role.staff: 'STAFF'};

const _$PlanTierEnumMap = {
  PlanTier.free: 'FREE',
  PlanTier.premium: 'PREMIUM',
  PlanTier.custom: 'CUSTOM',
};
