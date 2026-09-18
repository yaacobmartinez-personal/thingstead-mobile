import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/presentation/widgets/session_tiles.dart';
import '../application/tickets_controller.dart';
import '../domain/ticket.dart';

/// Attendee "Tickets" tab: upcoming and past registrations. Public route
/// that invites sign-in when there is no session.
class TicketsScreen extends ConsumerWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = isAvailable(Feature.attendeeMode, ref.watch(apiModeProvider));
    final signedIn = ref.watch(authControllerProvider.select((s) => s.isSignedIn));

    if (!available || !signedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('My tickets')),
        body: !available
            ? const EmptyState(
                icon: Icons.confirmation_number_outlined,
                title: 'Coming to the app soon',
                hint: 'Your tickets stay in your email for now — this server does '
                    'not support attendee accounts in the app yet.',
              )
            : ListView(
                padding: const EdgeInsets.all(Spacing.x4),
                children: const [
                  SignInPromptCard(
                    message: 'Sign in to keep your tickets on this phone and show '
                        'their QR codes at the door.',
                  ),
                ],
              ),
      );
    }

    final tickets = ref.watch(ticketsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My tickets'),
        actions: [
          IconButton(
            tooltip: 'Add from a link',
            icon: const Icon(Icons.add_link),
            onPressed: () => context.push(Routes.ticketImport),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(ticketsControllerProvider.notifier).refresh(),
        child: AsyncView(
          value: tickets,
          onRetry: () => ref.invalidate(ticketsControllerProvider),
          data: (state) {
            if (state.all.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: Spacing.x10),
                  EmptyState(
                    icon: Icons.confirmation_number_outlined,
                    title: 'No tickets yet',
                    hint: 'Register for an event and it will show up here. Got a '
                        'confirmation email? Add the ticket from its link.',
                    action: OutlinedButton(
                      onPressed: () => context.push(Routes.ticketImport),
                      child: const Text('Add from a link'),
                    ),
                  ),
                ],
              );
            }
            final upcoming = state.upcoming;
            final past = state.past;
            return ListView(
              padding: const EdgeInsets.all(Spacing.x4),
              children: [
                if (upcoming.isNotEmpty) ...[
                  const _Heading('Upcoming'),
                  for (final t in upcoming) _TicketTile(ticket: t),
                ],
                if (past.isNotEmpty) ...[
                  const SizedBox(height: Spacing.x3),
                  const _Heading('Past'),
                  for (final t in past) _TicketTile(ticket: t, dim: true),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: Spacing.x2),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.faint,
            letterSpacing: 0.6,
          ),
        ),
      );
}

class _TicketTile extends StatelessWidget {
  const _TicketTile({required this.ticket, this.dim = false});

  final Ticket ticket;
  final bool dim;

  static StatusChip chip(Ticket t) => switch (t.status) {
        RegistrationStatus.confirmed => t.checkedIn
            ? const StatusChip('Checked in', tone: ChipTone.success)
            : const StatusChip('Registered', tone: ChipTone.success),
        RegistrationStatus.waitlist => const StatusChip('Waitlist', tone: ChipTone.warn),
        RegistrationStatus.cancelled => const StatusChip('Cancelled', tone: ChipTone.muted),
      };

  @override
  Widget build(BuildContext context) {
    final t = ticket;
    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.x2),
      child: ListTile(
        onTap: () => context.push(Routes.ticket(t.id)),
        leading: Icon(
          t.hasQr ? Icons.qr_code_2 : Icons.confirmation_number_outlined,
          color: dim ? AppColors.faint : AppColors.navy,
          size: 32,
        ),
        title: Text(
          t.event.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: dim ? AppColors.muted : AppColors.text,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppTime.formatEventDate(t.event.startsAt, t.event.timezone)),
            Text(t.org.name, style: const TextStyle(color: AppColors.faint, fontSize: 12)),
          ],
        ),
        isThreeLine: true,
        trailing: chip(t),
      ),
    );
  }
}
