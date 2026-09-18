import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../attendee_providers.dart';
import '../../orgs/application/public_events_controller.dart';
import '../../tickets/application/tickets_controller.dart';
import '../domain/register_result.dart';

part 'register_controller.g.dart';

/// Registers the signed-in person (API-CONTRACT #13) and refreshes the
/// public event (places left) and the ticket list afterwards.
@Riverpod(keepAlive: true)
class RegisterController extends _$RegisterController {
  @override
  void build() {}

  Future<RegisterResult> register(String org, String event, {required String name}) async {
    final result =
        await ref.read(registrationRepositoryProvider).register(org, event, name: name);
    ref.invalidate(publicEventProvider(org, event));
    ref.invalidate(publicEventsProvider(org));
    if (result.ticket != null) ref.invalidate(ticketsControllerProvider);
    return result;
  }
}
