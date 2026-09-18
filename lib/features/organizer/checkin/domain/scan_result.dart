import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_result.freezed.dart';
part 'scan_result.g.dart';

/// What the server says about a scanned ticket (E6), plus one client-only
/// outcome for scans queued offline against an unknown token (Phase 3).
enum CheckInOutcome {
  @JsonValue('checked_in')
  checkedIn,
  @JsonValue('already')
  already,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('waitlist')
  waitlist,
  @JsonValue('wrong_event')
  wrongEvent,
  @JsonValue('invalid')
  invalid,
  @JsonValue('queued_unverified')
  queuedUnverified,
}

@freezed
abstract class ScanResult with _$ScanResult {
  const factory ScanResult({
    @JsonKey(unknownEnumValue: CheckInOutcome.invalid)
    required CheckInOutcome outcome,
    String? name,
    DateTime? at,
    String? eventTitle,
    /// True when the result was decided locally while offline.
    @Default(false) bool offline,
  }) = _ScanResult;

  factory ScanResult.fromJson(Map<String, dynamic> json) =>
      _$ScanResultFromJson(json);
}
