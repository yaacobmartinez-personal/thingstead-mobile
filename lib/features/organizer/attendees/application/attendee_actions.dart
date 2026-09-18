import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../events/application/event_detail_controller.dart';
import '../../events/application/events_controller.dart';
import '../../events/domain/event_detail.dart';
import '../../organizer_providers.dart';
import 'attendees_controller.dart';
import 'csv_sharer.dart';

part 'attendee_actions.g.dart';

/// Promote, erase, and export (API-CONTRACT #25–#27). After a change the
/// list is refetched into the cache (which is what the screen renders) and
/// the event counts are invalidated.
@Riverpod(keepAlive: true)
class AttendeeActions extends _$AttendeeActions {
  @override
  void build() {}

  Future<PromoteOutcome> promote(String org, String event, String registrationId) async {
    final outcome =
        await ref.read(attendeesRepositoryProvider).promote(org, event, registrationId);
    if (outcome == PromoteOutcome.promoted) await _changed(org, event);
    return outcome;
  }

  Future<void> erase(String org, String event, String registrationId) async {
    await ref.read(attendeesRepositoryProvider).erase(org, event, registrationId);
    await _changed(org, event);
  }

  /// Fetches the CSV and opens the share sheet. Returns the filename.
  Future<String> export(String org, String event) async {
    final (bytes, filename) =
        await ref.read(attendeesRepositoryProvider).exportCsv(org, event);
    await ref.read(csvSharerProvider).share(bytes, filename);
    return filename;
  }

  Future<void> _changed(String org, String event) async {
    ref.invalidate(orgEventsProvider(org));
    ref.invalidate(eventDetailProvider(org, event));
    final list = attendeesControllerProvider(org, event);
    if (ref.exists(list)) await ref.read(list.notifier).refresh();
  }
}
