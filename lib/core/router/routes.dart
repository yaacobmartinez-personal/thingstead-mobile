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
  static String attendeeOrg(String org) => '/a/orgs/$org';
  static String attendeeEvent(String org, String event) =>
      '/a/orgs/$org/events/$event';
  static String ticket(String id) => '/a/tickets/$id';
  static const ticketImport = '/a/tickets/import';

  // Organizer shell
  static const orgEvents = '/o/events';
  static const orgScan = '/o/scan';
  static const orgTeam = '/o/team';
  static const orgSettings = '/o/settings';
  static const orgPicker = '/o/orgs';
  static const orgEventNew = '/o/events/new';
  static String orgEvent(String slug) => '/o/events/$slug';
  static String orgEventEdit(String slug) => '/o/events/$slug/edit';
  static String orgEventAttendees(String slug) => '/o/events/$slug/attendees';
  static const orgSyncAttention = '/o/sync/attention';
  static const orgSettingsServer = '/o/settings/server';
}
