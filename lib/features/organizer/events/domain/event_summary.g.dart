// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventSummary _$EventSummaryFromJson(Map<String, dynamic> json) =>
    _EventSummary(
      slug: json['slug'] as String,
      title: json['title'] as String,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: json['endsAt'] == null
          ? null
          : DateTime.parse(json['endsAt'] as String),
      timezone: json['timezone'] as String,
      capacity: (json['capacity'] as num?)?.toInt(),
      status: $enumDecode(_$EventStatusEnumMap, json['status']),
      confirmed: (json['confirmed'] as num?)?.toInt() ?? 0,
      checkedIn: (json['checkedIn'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$EventSummaryToJson(_EventSummary instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt?.toIso8601String(),
      'timezone': instance.timezone,
      'capacity': instance.capacity,
      'status': _$EventStatusEnumMap[instance.status]!,
      'confirmed': instance.confirmed,
      'checkedIn': instance.checkedIn,
    };

const _$EventStatusEnumMap = {
  EventStatus.draft: 'DRAFT',
  EventStatus.published: 'PUBLISHED',
  EventStatus.closed: 'CLOSED',
};

_EventsPage _$EventsPageFromJson(Map<String, dynamic> json) => _EventsPage(
  org: OrgRef.fromJson(json['org'] as Map<String, dynamic>),
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EventSummary>[],
);

Map<String, dynamic> _$EventsPageToJson(_EventsPage instance) =>
    <String, dynamic>{'org': instance.org, 'events': instance.events};

_OrgRef _$OrgRefFromJson(Map<String, dynamic> json) =>
    _OrgRef(slug: json['slug'] as String, name: json['name'] as String);

Map<String, dynamic> _$OrgRefToJson(_OrgRef instance) => <String, dynamic>{
  'slug': instance.slug,
  'name': instance.name,
};
