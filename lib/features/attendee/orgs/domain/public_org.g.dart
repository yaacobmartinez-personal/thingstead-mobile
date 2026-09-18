// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_org.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublicOrg _$PublicOrgFromJson(Map<String, dynamic> json) =>
    _PublicOrg(slug: json['slug'] as String, name: json['name'] as String);

Map<String, dynamic> _$PublicOrgToJson(_PublicOrg instance) =>
    <String, dynamic>{'slug': instance.slug, 'name': instance.name};

_PublicEvent _$PublicEventFromJson(Map<String, dynamic> json) => _PublicEvent(
  slug: json['slug'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: json['endsAt'] == null
      ? null
      : DateTime.parse(json['endsAt'] as String),
  timezone: json['timezone'] as String,
  capacity: (json['capacity'] as num?)?.toInt(),
  remaining: (json['remaining'] as num?)?.toInt(),
  isFull: json['isFull'] as bool? ?? false,
  waitlistEnabled: json['waitlistEnabled'] as bool? ?? false,
);

Map<String, dynamic> _$PublicEventToJson(_PublicEvent instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'description': instance.description,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt?.toIso8601String(),
      'timezone': instance.timezone,
      'capacity': instance.capacity,
      'remaining': instance.remaining,
      'isFull': instance.isFull,
      'waitlistEnabled': instance.waitlistEnabled,
    };

_PublicEventsPage _$PublicEventsPageFromJson(Map<String, dynamic> json) =>
    _PublicEventsPage(
      org: PublicOrg.fromJson(json['org'] as Map<String, dynamic>),
      events:
          (json['events'] as List<dynamic>?)
              ?.map((e) => PublicEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PublicEvent>[],
    );

Map<String, dynamic> _$PublicEventsPageToJson(_PublicEventsPage instance) =>
    <String, dynamic>{'org': instance.org, 'events': instance.events};

_PublicEventPage _$PublicEventPageFromJson(Map<String, dynamic> json) =>
    _PublicEventPage(
      org: PublicOrg.fromJson(json['org'] as Map<String, dynamic>),
      event: PublicEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PublicEventPageToJson(_PublicEventPage instance) =>
    <String, dynamic>{'org': instance.org, 'event': instance.event};
