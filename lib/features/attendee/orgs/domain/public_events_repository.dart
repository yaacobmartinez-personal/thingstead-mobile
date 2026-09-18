import 'public_org.dart';

/// Unauthenticated reads of an org's public pages (API-CONTRACT #10–#12).
abstract class PublicEventsRepository {
  /// 404 when the org is missing or not ACTIVE.
  Future<PublicOrg> getOrg(String orgSlug);

  /// PUBLISHED events, soonest first.
  Future<PublicEventsPage> listEvents(String orgSlug);

  /// 404 for missing, DRAFT, and CLOSED events alike.
  Future<PublicEventPage> getEvent(String orgSlug, String eventSlug);
}
