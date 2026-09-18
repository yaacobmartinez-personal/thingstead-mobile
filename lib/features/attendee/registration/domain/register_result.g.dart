// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterResult _$RegisterResultFromJson(Map<String, dynamic> json) =>
    _RegisterResult(
      outcome: $enumDecode(_$RegisterOutcomeEnumMap, json['outcome']),
      ticket: json['ticket'] == null
          ? null
          : Ticket.fromJson(json['ticket'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterResultToJson(_RegisterResult instance) =>
    <String, dynamic>{
      'outcome': _$RegisterOutcomeEnumMap[instance.outcome]!,
      'ticket': instance.ticket,
    };

const _$RegisterOutcomeEnumMap = {
  RegisterOutcome.confirmed: 'confirmed',
  RegisterOutcome.waitlisted: 'waitlisted',
  RegisterOutcome.full: 'full',
  RegisterOutcome.duplicate: 'duplicate',
  RegisterOutcome.closed: 'closed',
};
