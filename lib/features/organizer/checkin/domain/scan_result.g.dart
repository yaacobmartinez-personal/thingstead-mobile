// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanResult _$ScanResultFromJson(Map<String, dynamic> json) => _ScanResult(
  outcome: $enumDecode(
    _$CheckInOutcomeEnumMap,
    json['outcome'],
    unknownValue: CheckInOutcome.invalid,
  ),
  name: json['name'] as String?,
  at: json['at'] == null ? null : DateTime.parse(json['at'] as String),
  eventTitle: json['eventTitle'] as String?,
  offline: json['offline'] as bool? ?? false,
);

Map<String, dynamic> _$ScanResultToJson(_ScanResult instance) =>
    <String, dynamic>{
      'outcome': _$CheckInOutcomeEnumMap[instance.outcome]!,
      'name': instance.name,
      'at': instance.at?.toIso8601String(),
      'eventTitle': instance.eventTitle,
      'offline': instance.offline,
    };

const _$CheckInOutcomeEnumMap = {
  CheckInOutcome.checkedIn: 'checked_in',
  CheckInOutcome.already: 'already',
  CheckInOutcome.cancelled: 'cancelled',
  CheckInOutcome.waitlist: 'waitlist',
  CheckInOutcome.wrongEvent: 'wrong_event',
  CheckInOutcome.invalid: 'invalid',
  CheckInOutcome.queuedUnverified: 'queued_unverified',
};
