/// Route paths. Kept as constants so screens, guards, and the deep-link
/// handler never disagree about where things live.
abstract final class Routes {
  static const splash = '/splash';

  // Auth stack
  static const login = '/auth/login';
  static const signup = '/auth/signup';
  static const checkEmail = '/auth/check-email';
  static const verify = '/auth/verify';
  static const forgot = '/auth/forgot';
  static const reset = '/auth/reset';

  // Attendee shell
  static const attendeeEvents = '/a/events';
  static const attendeeTickets = '/a/tickets';
  static const attendeeAccount = '/a/account';
  /// Public org pages nest under the Events tab so a declarative `go` (deep
  /// links, the post-login return) builds the full back stack.
  static String attendeeOrg(String org) => '$attendeeEvents/orgs/$org';
  static String attendeeEvent(String org, String event) =>
      '$attendeeEvents/orgs/$org/events/$event';
  static String ticket(String id) => '/a/tickets/$id';
  static const ticketImport = '/a/tickets/import';

  // Organizer shell
  static const orgEvents = '/o/events';
  static const orgScan = '/o/scan';

  /// The live camera, pushed over the shell. Query "event" pins an event;
  /// "code" submits a code on open (QR deep link).
  static const orgScanLive = '/o/scan/live';
  static const orgTeam = '/o/team';
  static const orgSettings = '/o/settings';
  static const orgPicker = '/o/orgs';
  static const orgEventNew = '/o/events/new';
  static String orgEvent(String slug) => '/o/events/$slug';
  static String orgEventEdit(String slug) => '/o/events/$slug/edit';
  static String orgEventAttendees(String slug) => '/o/events/$slug/attendees';
  static const orgSyncAttention = '/o/sync/attention';
  /// Outside both shells so it is reachable from the login screen.
  static const serverAddress = '/settings/server';
}
