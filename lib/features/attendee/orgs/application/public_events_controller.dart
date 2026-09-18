import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../attendee_providers.dart';
import '../domain/public_org.dart';

part 'public_events_controller.g.dart';

/// An org's published events (API-CONTRACT #11). Public: no session needed.
@riverpod
Future<PublicEventsPage> publicEvents(Ref ref, String org) =>
    ref.watch(publicEventsRepositoryProvider).listEvents(org);

/// One public event with its description and availability (#12).
/// Invalidated after a registration so the places-left line is current.
@riverpod
Future<PublicEventPage> publicEvent(Ref ref, String org, String event) =>
    ref.watch(publicEventsRepositoryProvider).getEvent(org, event);
