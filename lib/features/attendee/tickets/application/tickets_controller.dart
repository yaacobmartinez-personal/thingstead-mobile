import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/time/clock.dart';
import '../../../auth/application/auth_controller.dart';
import '../../attendee_providers.dart';
import '../domain/ticket.dart';

part 'tickets_controller.g.dart';

/// The signed-in person's tickets (API-CONTRACT #14), split for the list.
class TicketsState {
  const TicketsState(this.all, {required this.now});

  final List<Ticket> all;
  final DateTime now;

  List<Ticket> get upcoming => all.where((t) => !t.isPast(now)).toList()
    ..sort((a, b) => a.event.startsAt.compareTo(b.event.startsAt));

  List<Ticket> get past => all.where((t) => t.isPast(now)).toList()
    ..sort((a, b) => b.event.startsAt.compareTo(a.event.startsAt));
}

/// Rebuilds on sign-in/out so another account never sees a stale list.
@riverpod
class TicketsController extends _$TicketsController {
  @override
  Future<TicketsState> build() async {
    ref.watch(authControllerProvider.select((s) => s.user?.id));
    final tickets = await ref.watch(ticketsRepositoryProvider).list();
    return TicketsState(tickets, now: ref.read(clockProvider)());
  }

  Future<void> refresh() async {
    final tickets = await ref.read(ticketsRepositoryProvider).list();
    state = AsyncData(TicketsState(tickets, now: ref.read(clockProvider)()));
  }
}

/// One ticket (#15); the list is the usual source, the fetch covers deep
/// links and a fresh registration.
@riverpod
Future<Ticket> ticket(Ref ref, String id) => ref.watch(ticketsRepositoryProvider).get(id);

/// Import and cancel (#16, #17). Both refresh what they touched.
@Riverpod(keepAlive: true)
class TicketActions extends _$TicketActions {
  @override
  void build() {}

  Future<Ticket> import(String manageToken) async {
    final ticket = await ref.read(ticketsRepositoryProvider).import(manageToken);
    _changed(ticket.id);
    return ticket;
  }

  Future<CancelOutcome> cancel(String id) async {
    final outcome = await ref.read(ticketsRepositoryProvider).cancel(id);
    _changed(id);
    return outcome;
  }

  void _changed(String id) {
    ref.invalidate(ticketProvider(id));
    ref.invalidate(ticketsControllerProvider);
  }
}
