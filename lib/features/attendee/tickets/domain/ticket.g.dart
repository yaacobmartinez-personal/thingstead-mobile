// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ticket _$TicketFromJson(Map<String, dynamic> json) => _Ticket(
  id: json['id'] as String,
  status: $enumDecode(_$RegistrationStatusEnumMap, json['status']),
  name: json['name'] as String?,
  email: json['email'] as String,
  checkedInAt: json['checkedInAt'] == null
      ? null
      : DateTime.parse(json['checkedInAt'] as String),
  checkInToken: json['checkInToken'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  started: json['started'] as bool? ?? false,
  org: TicketOrg.fromJson(json['org'] as Map<String, dynamic>),
  event: TicketEvent.fromJson(json['event'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TicketToJson(_Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'status': _$RegistrationStatusEnumMap[instance.status]!,
  'name': instance.name,
  'email': instance.email,
  'checkedInAt': instance.checkedInAt?.toIso8601String(),
  'checkInToken': instance.checkInToken,
  'createdAt': instance.createdAt.toIso8601String(),
  'started': instance.started,
  'org': instance.org,
  'event': instance.event,
};

const _$RegistrationStatusEnumMap = {
  RegistrationStatus.confirmed: 'CONFIRMED',
  RegistrationStatus.waitlist: 'WAITLIST',
  RegistrationStatus.cancelled: 'CANCELLED',
};

_TicketOrg _$TicketOrgFromJson(Map<String, dynamic> json) =>
    _TicketOrg(slug: json['slug'] as String, name: json['name'] as String);

Map<String, dynamic> _$TicketOrgToJson(_TicketOrg instance) =>
    <String, dynamic>{'slug': instance.slug, 'name': instance.name};

_TicketEvent _$TicketEventFromJson(Map<String, dynamic> json) => _TicketEvent(
  slug: json['slug'] as String,
  title: json['title'] as String,
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: json['endsAt'] == null
      ? null
      : DateTime.parse(json['endsAt'] as String),
  timezone: json['timezone'] as String,
);

Map<String, dynamic> _$TicketEventToJson(_TicketEvent instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt?.toIso8601String(),
      'timezone': instance.timezone,
    };
