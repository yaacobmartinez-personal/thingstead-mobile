import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/enums.dart';

part 'attendee.freezed.dart';
part 'attendee.g.dart';

/// One row of `GET …/attendees` (E4). `name`/`email` are null when erased.
/// `checkInToken` arrives once API-CONTRACT #23 ships; until then null.
@freezed
abstract class Attendee with _$Attendee {
  const factory Attendee({
    required String id,
    String? name,
    String? email,
    required RegistrationStatus status,
    DateTime? checkedInAt,
    @Default(false) bool erased,
    String? checkInToken,
  }) = _Attendee;

  const Attendee._();

  factory Attendee.fromJson(Map<String, dynamic> json) => _$AttendeeFromJson(json);

  bool get checkedIn => checkedInAt != null;

  /// Only confirmed, non-erased people can be marked present by hand.
  bool get canCheckIn => status == RegistrationStatus.confirmed && !erased;

  String get displayName => erased ? 'Removed attendee' : (name ?? '—');

  /// Case-insensitive contains on name or email — the server's `q` semantics.
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return (name ?? '').toLowerCase().contains(q) ||
        (email ?? '').toLowerCase().contains(q);
  }
}

/// The event header the attendees endpoint returns alongside the list.
@freezed
abstract class AttendeeEventRef with _$AttendeeEventRef {
  const factory AttendeeEventRef({
    required String title,
    required String timezone,
    int? capacity,
    int? waitlist,
  }) = _AttendeeEventRef;

  factory AttendeeEventRef.fromJson(Map<String, dynamic> json) =>
      _$AttendeeEventRefFromJson(json);
}

@freezed
abstract class AttendeeList with _$AttendeeList {
  const factory AttendeeList({
    required AttendeeEventRef event,
    @Default(<Attendee>[]) List<Attendee> attendees,
  }) = _AttendeeList;

  factory AttendeeList.fromJson(Map<String, dynamic> json) =>
      _$AttendeeListFromJson(json);
}
