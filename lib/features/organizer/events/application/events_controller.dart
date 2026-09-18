import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../organizer_providers.dart';
import '../domain/event_summary.dart';

part 'events_controller.g.dart';

/// The org's events with counts. Invalidated by check-in controllers after
/// a successful mutation so the numbers on the cards stay current (the Expo
/// app refetched on focus for the same reason).
@riverpod
Future<EventsPage> orgEvents(Ref ref, String org) =>
    ref.watch(orgEventsRepositoryProvider).list(org);
