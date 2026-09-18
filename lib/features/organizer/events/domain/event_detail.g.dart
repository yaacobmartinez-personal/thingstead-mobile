// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventDetail _$EventDetailFromJson(Map<String, dynamic> json) => _EventDetail(
  id: json['id'] as String,
  slug: json['slug'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: json['endsAt'] == null
      ? null
      : DateTime.parse(json['endsAt'] as String),
  timezone: json['timezone'] as String,
  startsAtLocal: json['startsAtLocal'] as String,
  endsAtLocal: json['endsAtLocal'] as String?,
  capacity: (json['capacity'] as num?)?.toInt(),
  waitlistEnabled: json['waitlistEnabled'] as bool? ?? false,
  status: $enumDecode(_$EventStatusEnumMap, json['status']),
  confirmed: (json['confirmed'] as num?)?.toInt() ?? 0,
  waitlist: (json['waitlist'] as num?)?.toInt() ?? 0,
  checkedIn: (json['checkedIn'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$EventDetailToJson(_EventDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'description': instance.description,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt?.toIso8601String(),
      'timezone': instance.timezone,
      'startsAtLocal': instance.startsAtLocal,
      'endsAtLocal': instance.endsAtLocal,
      'capacity': instance.capacity,
      'waitlistEnabled': instance.waitlistEnabled,
      'status': _$EventStatusEnumMap[instance.status]!,
      'confirmed': instance.confirmed,
      'waitlist': instance.waitlist,
      'checkedIn': instance.checkedIn,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$EventStatusEnumMap = {
  EventStatus.draft: 'DRAFT',
  EventStatus.published: 'PUBLISHED',
  EventStatus.closed: 'CLOSED',
};
