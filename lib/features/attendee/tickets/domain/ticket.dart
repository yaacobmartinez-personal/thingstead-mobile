import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/model/enums.dart';

part 'ticket.freezed.dart';
part 'ticket.g.dart';

/// A registration as its owner sees it (API-CONTRACT `Ticket`).
@freezed
abstract class Ticket with _$Ticket {
  const factory Ticket({
    required String id,
    required RegistrationStatus status,
    String? name,
    required String email,
    DateTime? checkedInAt,

    /// Null once erased; the QR encodes it.
    String? checkInToken,
    required DateTime createdAt,

    /// True once the event has begun — cancelling changes nothing real then.
    @Default(false) bool started,
    required TicketOrg org,
    required TicketEvent event,
  }) = _Ticket;

  const Ticket._();

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  bool get isConfirmed => status == RegistrationStatus.confirmed;
  bool get isCancelled => status == RegistrationStatus.cancelled;
  bool get checkedIn => checkedInAt != null;

  /// A ticket only makes sense for a confirmed place that hasn't been given
  /// up (the manage page shows the QR under the same rule).
  bool get hasQr => isConfirmed && checkInToken != null;

  /// What the QR holds — the same URL the web ticket encodes
  /// (`regista/lib/urls.ts` `checkInUrl`).
  String get qrPayload => '${AppConfig.appOrigin}/checkin?c=$checkInToken';

  /// Cancelling is offered until the event starts.
  bool get canCancel => !isCancelled && !started;

  /// Past once it has started and, if it has an end, ended.
  bool isPast(DateTime now) => (event.endsAt ?? event.startsAt).isBefore(now);

  String get statusLabel => switch (status) {
        RegistrationStatus.confirmed => 'Registered',
        RegistrationStatus.waitlist => 'On the waitlist',
        RegistrationStatus.cancelled => 'Cancelled',
      };
}

@freezed
abstract class TicketOrg with _$TicketOrg {
  const factory TicketOrg({required String slug, required String name}) = _TicketOrg;

  factory TicketOrg.fromJson(Map<String, dynamic> json) => _$TicketOrgFromJson(json);
}

@freezed
abstract class TicketEvent with _$TicketEvent {
  const factory TicketEvent({
    required String slug,
    required String title,
    required DateTime startsAt,
    DateTime? endsAt,
    required String timezone,
  }) = _TicketEvent;

  factory TicketEvent.fromJson(Map<String, dynamic> json) => _$TicketEventFromJson(json);
}

/// `POST /mobile/tickets/{id}/cancel` (#17).
enum CancelOutcome {
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('already')
  already,
  @JsonValue('started')
  started,
}
