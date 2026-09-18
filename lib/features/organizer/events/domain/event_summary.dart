import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/enums.dart';

part 'event_summary.freezed.dart';
part 'event_summary.g.dart';

/// One row of `GET /mobile/orgs/{slug}/events` (E3).
@freezed
abstract class EventSummary with _$EventSummary {
  const factory EventSummary({
    required String slug,
    required String title,
    required DateTime startsAt,
    DateTime? endsAt,
    required String timezone,
    int? capacity,
    required EventStatus status,
    @Default(0) int confirmed,
    @Default(0) int checkedIn,
  }) = _EventSummary;

  const EventSummary._();

  factory EventSummary.fromJson(Map<String, dynamic> json) =>
      _$EventSummaryFromJson(json);

  /// "38 / 40" or "38" when uncapped.
  String get headcount =>
      capacity == null ? '$confirmed' : '$confirmed / $capacity';

  bool get isFull => capacity != null && confirmed >= capacity!;
}

/// The whole response: the org header plus its events.
@freezed
abstract class EventsPage with _$EventsPage {
  const factory EventsPage({
    required OrgRef org,
    @Default(<EventSummary>[]) List<EventSummary> events,
  }) = _EventsPage;

  factory EventsPage.fromJson(Map<String, dynamic> json) =>
      _$EventsPageFromJson(json);
}

@freezed
abstract class OrgRef with _$OrgRef {
  const factory OrgRef({required String slug, required String name}) = _OrgRef;

  factory OrgRef.fromJson(Map<String, dynamic> json) => _$OrgRefFromJson(json);
}
