// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Attendee _$AttendeeFromJson(Map<String, dynamic> json) => _Attendee(
  id: json['id'] as String,
  name: json['name'] as String?,
  email: json['email'] as String?,
  status: $enumDecode(_$RegistrationStatusEnumMap, json['status']),
  checkedInAt: json['checkedInAt'] == null
      ? null
      : DateTime.parse(json['checkedInAt'] as String),
  erased: json['erased'] as bool? ?? false,
  checkInToken: json['checkInToken'] as String?,
);

Map<String, dynamic> _$AttendeeToJson(_Attendee instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'status': _$RegistrationStatusEnumMap[instance.status]!,
  'checkedInAt': instance.checkedInAt?.toIso8601String(),
  'erased': instance.erased,
  'checkInToken': instance.checkInToken,
};

const _$RegistrationStatusEnumMap = {
  RegistrationStatus.confirmed: 'CONFIRMED',
  RegistrationStatus.waitlist: 'WAITLIST',
  RegistrationStatus.cancelled: 'CANCELLED',
};

_AttendeeEventRef _$AttendeeEventRefFromJson(Map<String, dynamic> json) =>
    _AttendeeEventRef(
      title: json['title'] as String,
      timezone: json['timezone'] as String,
      capacity: (json['capacity'] as num?)?.toInt(),
      waitlist: (json['waitlist'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AttendeeEventRefToJson(_AttendeeEventRef instance) =>
    <String, dynamic>{
      'title': instance.title,
      'timezone': instance.timezone,
      'capacity': instance.capacity,
      'waitlist': instance.waitlist,
    };

_AttendeeList _$AttendeeListFromJson(Map<String, dynamic> json) =>
    _AttendeeList(
      event: AttendeeEventRef.fromJson(json['event'] as Map<String, dynamic>),
      attendees:
          (json['attendees'] as List<dynamic>?)
              ?.map((e) => Attendee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Attendee>[],
    );

Map<String, dynamic> _$AttendeeListToJson(_AttendeeList instance) =>
    <String, dynamic>{'event': instance.event, 'attendees': instance.attendees};
