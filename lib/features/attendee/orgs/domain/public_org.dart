import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_org.freezed.dart';
part 'public_org.g.dart';

/// An organization as the public sees it (API-CONTRACT #10).
@freezed
abstract class PublicOrg with _$PublicOrg {
  const factory PublicOrg({required String slug, required String name}) = _PublicOrg;

  factory PublicOrg.fromJson(Map<String, dynamic> json) => _$PublicOrgFromJson(json);
}

/// A published event on an org's public page (#11, #12). `description` is
/// only present on the detail endpoint.
@freezed
abstract class PublicEvent with _$PublicEvent {
  const factory PublicEvent({
    required String slug,
    required String title,
    String? description,
    required DateTime startsAt,
    DateTime? endsAt,
    required String timezone,
    int? capacity,

    /// `capacity - confirmed`; null when uncapped.
    int? remaining,
    @Default(false) bool isFull,
    @Default(false) bool waitlistEnabled,
  }) = _PublicEvent;

  const PublicEvent._();

  factory PublicEvent.fromJson(Map<String, dynamic> json) => _$PublicEventFromJson(json);

  /// The public page's availability line: "12 of 40 places left" / "Full".
  String? get placesLabel {
    final r = remaining;
    final c = capacity;
    if (r == null || c == null) return null;
    if (r <= 0) return 'Full';
    return '$r of $c ${r == 1 ? 'place' : 'places'} left';
  }

  /// Whether Register does anything: open, or full with a waitlist.
  bool get canRegister => !isFull || waitlistEnabled;
}

@freezed
abstract class PublicEventsPage with _$PublicEventsPage {
  const factory PublicEventsPage({
    required PublicOrg org,
    @Default(<PublicEvent>[]) List<PublicEvent> events,
  }) = _PublicEventsPage;

  factory PublicEventsPage.fromJson(Map<String, dynamic> json) =>
      _$PublicEventsPageFromJson(json);
}

@freezed
abstract class PublicEventPage with _$PublicEventPage {
  const factory PublicEventPage({
    required PublicOrg org,
    required PublicEvent event,
  }) = _PublicEventPage;

  factory PublicEventPage.fromJson(Map<String, dynamic> json) =>
      _$PublicEventPageFromJson(json);
}
