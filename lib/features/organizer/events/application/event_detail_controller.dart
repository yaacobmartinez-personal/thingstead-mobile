import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/model/enums.dart';
import '../../organizer_providers.dart';
import '../domain/event_detail.dart';
import '../domain/event_input.dart';
import 'events_controller.dart';

part 'event_detail_controller.g.dart';

/// One event with its counts (API-CONTRACT #18). Re-fetched after every
/// mutation below so the detail screen never shows a stale status or count.
@riverpod
Future<EventDetail> eventDetail(Ref ref, String org, String slug) =>
    ref.watch(orgEventsRepositoryProvider).get(org, slug);

/// Event mutations (#19–#22). Stateless; kept alive so an in-flight call is
/// never cut short by the caller's screen going away. Every method
/// invalidates the list and the detail so the UI refetches on return.
@Riverpod(keepAlive: true)
class EventActions extends _$EventActions {
  @override
  void build() {}

  Future<EventDetail> create(String org, EventInput input) async {
    final event = await ref.read(orgEventsRepositoryProvider).create(org, input);
    ref.invalidate(orgEventsProvider(org));
    return event;
  }

  Future<EventDetail> update(String org, String slug, EventInput input) async {
    final event = await ref.read(orgEventsRepositoryProvider).update(org, slug, input);
    _refresh(org, slug);
    // The slug may have changed; make sure the new address is fresh too.
    if (event.slug != slug) ref.invalidate(eventDetailProvider(org, event.slug));
    return event;
  }

  Future<EventStatus> setStatus(String org, String slug, EventStatus status) async {
    final result = await ref.read(orgEventsRepositoryProvider).setStatus(org, slug, status);
    _refresh(org, slug);
    return result;
  }

  /// Returns how many registrations went with the event.
  Future<int> delete(String org, String slug) async {
    final gone = await ref.read(orgEventsRepositoryProvider).delete(org, slug);
    _refresh(org, slug);
    return gone;
  }

  void _refresh(String org, String slug) {
    ref.invalidate(orgEventsProvider(org));
    ref.invalidate(eventDetailProvider(org, slug));
  }
}
