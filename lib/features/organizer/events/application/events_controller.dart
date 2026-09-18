import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../../../auth/application/auth_controller.dart';
import '../../local_cache.dart';
import '../../organizer_providers.dart';
import '../domain/event_summary.dart';

part 'events_controller.g.dart';

/// The org's events with counts, cached on every successful fetch so the
/// Events and Scan tabs open offline (`stale: true`). Invalidated by the
/// check-in paths after a successful mutation so the numbers on the cards
/// stay current (the Expo app refetched on focus for the same reason).
@riverpod
Future<EventsPage> orgEvents(Ref ref, String org) async {
  final cache = ref.watch(localCacheProvider);
  try {
    final page = await ref.watch(orgEventsRepositoryProvider).list(org);
    await cache.storeEvents(org, page, ref.read(clockProvider)());
    return page;
  } on ApiError catch (e) {
    if (!e.isNetwork && e.status < 500) rethrow;
    final cached = await cache.readEvents(org);
    if (cached == null) rethrow;
    final name = ref
            .read(authControllerProvider)
            .orgs
            .where((o) => o.slug == org)
            .firstOrNull
            ?.name ??
        org;
    return EventsPage(org: OrgRef(slug: org, name: name), events: cached, stale: true);
  }
}
