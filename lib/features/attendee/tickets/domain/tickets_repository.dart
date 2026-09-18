import 'ticket.dart';

/// The signed-in person's registrations (API-CONTRACT #14–#17).
abstract class TicketsRepository {
  /// Mine, not erased, newest first.
  Future<List<Ticket>> list();

  /// 404 when not mine or erased.
  Future<Ticket> get(String id);

  /// Attach the registration behind an emailed manage link to this account.
  /// 404 invalid/erased; 403 `email_mismatch` when it was registered with
  /// another address.
  Future<Ticket> import(String manageToken);

  /// Give up a place. No waitlist promotion happens here — that is the
  /// organizer's call.
  Future<CancelOutcome> cancel(String id);
}
