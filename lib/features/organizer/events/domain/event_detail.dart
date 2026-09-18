import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/enums.dart';

part 'event_detail.freezed.dart';
part 'event_detail.g.dart';

/// `EventDetail` from API-CONTRACT (#18): everything the organizer needs to
/// show and edit one event. `startsAtLocal`/`endsAtLocal` are wall-clock
/// strings in [timezone] for the edit form.
@freezed
abstract class EventDetail with _$EventDetail {
  const factory EventDetail({
    required String id,
    required String slug,
    required String title,
    String? description,
    required DateTime startsAt,
    DateTime? endsAt,
    required String timezone,
    required String startsAtLocal,
    String? endsAtLocal,
    int? capacity,
    @Default(false) bool waitlistEnabled,
    required EventStatus status,
    @Default(0) int confirmed,
    @Default(0) int waitlist,
    @Default(0) int checkedIn,
    required DateTime createdAt,
  }) = _EventDetail;

  const EventDetail._();

  factory EventDetail.fromJson(Map<String, dynamic> json) => _$EventDetailFromJson(json);

  String get headcount => capacity == null ? '$confirmed' : '$confirmed / $capacity';
  bool get isFull => capacity != null && confirmed >= capacity!;
  int get registrations => confirmed + waitlist;
}

enum PromoteOutcome {
  @JsonValue('promoted')
  promoted,
  @JsonValue('full')
  full,
  @JsonValue('gone')
  gone,
}
