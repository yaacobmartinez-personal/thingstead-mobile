import 'package:freezed_annotation/freezed_annotation.dart';

import '../../tickets/domain/ticket.dart';

part 'register_result.freezed.dart';
part 'register_result.g.dart';

/// Outcomes of `POST …/register` (API-CONTRACT #13), same words as the web
/// form's `RegisterState`.
enum RegisterOutcome {
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('waitlisted')
  waitlisted,
  @JsonValue('full')
  full,
  @JsonValue('duplicate')
  duplicate,
  @JsonValue('closed')
  closed,
}

@freezed
abstract class RegisterResult with _$RegisterResult {
  const factory RegisterResult({
    required RegisterOutcome outcome,

    /// Present for confirmed, waitlisted, and duplicate.
    Ticket? ticket,
  }) = _RegisterResult;

  const RegisterResult._();

  factory RegisterResult.fromJson(Map<String, dynamic> json) =>
      _$RegisterResultFromJson(json);

  bool get gotAPlace =>
      outcome == RegisterOutcome.confirmed || outcome == RegisterOutcome.waitlisted;
}

/// Copy from `register-form.tsx`, one line per outcome.
abstract final class RegisterCopy {
  static String title(RegisterOutcome o) => switch (o) {
        RegisterOutcome.confirmed => "You're registered",
        RegisterOutcome.waitlisted => "You're on the waitlist",
        RegisterOutcome.duplicate => "You're already signed up",
        RegisterOutcome.full => 'This event is full',
        RegisterOutcome.closed => 'Registration is closed',
      };

  static String body(RegisterOutcome o) => switch (o) {
        RegisterOutcome.confirmed => 'Your ticket is ready. Show its QR code at the door.',
        RegisterOutcome.waitlisted => "This event is full. We'll email you if a place opens up.",
        RegisterOutcome.duplicate => 'That email address is already registered for this event.',
        RegisterOutcome.full => 'All places have been taken.',
        RegisterOutcome.closed => "This event isn't accepting sign-ups right now.",
      };
}
