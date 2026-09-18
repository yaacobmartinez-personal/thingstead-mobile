import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/ui/round_icon_button.dart';
import '../../../../core/ui/stagger.dart';
import '../../../../core/ui/ticket_card.dart';
import '../../../../core/ui/tiles.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/presentation/widgets/session_tiles.dart';
import '../application/tickets_controller.dart';
import '../domain/ticket.dart';

/// Attendee "Tickets" tab: ticket-shaped cards, upcoming then past. Public
/// route that invites sign-in when there is no session.
class TicketsScreen extends ConsumerWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
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
                padding: const EdgeInsets.all(Spacing.gutter),
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
          Padding(
            padding: const EdgeInsets.only(right: Spacing.gutter),
            child: RoundIconButton(
              icon: Icons.add_link,
              tooltip: 'Add from a link',
              onPressed: () => context.push(Routes.ticketImport),
            ),
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
                  const SizedBox(height: Spacing.x8),
                  EmptyState(
                    icon: Icons.confirmation_number_outlined,
                    title: 'No tickets yet',
                    hint: 'Register for an event and it will show up here. Got a '
                        'confirmation email? Add the ticket from its link.',
                    action: PillButton(
                      label: 'Add from a link',
                      variant: PillVariant.ghost,
                      expanded: false,
                      onPressed: () => context.push(Routes.ticketImport),
                    ),
                  ),
                ],
              );
            }
            final upcoming = state.upcoming;
            final past = state.past;
            var i = 0;
            return ListView(
              padding: const EdgeInsets.fromLTRB(Spacing.gutter, Spacing.x2, Spacing.gutter, Spacing.x8),
              children: [
                if (upcoming.isNotEmpty) ...[
                  const SectionLabel('Upcoming'),
                  for (final t in upcoming)
                    Enter(index: i++, child: _TicketTile(ticket: t)),
                ],
                if (past.isNotEmpty) ...[
                  const SizedBox(height: Spacing.x3),
                  const SectionLabel('Past'),
                  for (final t in past)
                    Enter(index: i++, child: _TicketTile(ticket: t, dim: true)),
                ],
                Text(
                  'Show a ticket\'s QR at the door.',
                  textAlign: TextAlign.center,
                  style: AppType.captionQuiet.copyWith(color: p.faint),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TicketTile extends StatelessWidget {
  const _TicketTile({required this.ticket, this.dim = false});

  final Ticket ticket;
  final bool dim;

  static StatusChip chip(Ticket t) => switch (t.status) {
        RegistrationStatus.confirmed => t.checkedIn
            ? const StatusChip('Checked in', tone: ChipTone.success, dot: true)
            : const StatusChip('Registered', tone: ChipTone.success),
        RegistrationStatus.waitlist => const StatusChip('Waitlist', tone: ChipTone.warn),
        RegistrationStatus.cancelled => const StatusChip('Cancelled', tone: ChipTone.muted),
      };

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = ticket;
    final (month, day, weekday, time) = AppTime.dateParts(t.event.startsAt, t.event.endsAt, t.event.timezone);
    final ink = dim ? p.muted : p.ink;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.x4),
      child: TicketCard(
        onTap: () => context.push(Routes.ticket(t.id)),
        body: Row(
          children: [
            Container(
              width: 52,
              padding: const EdgeInsets.symmetric(vertical: Spacing.x2),
              decoration: BoxDecoration(
                color: p.surfaceTint,
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: Column(
                children: [
                  Text(month.toUpperCase(), style: AppType.caption.copyWith(color: p.muted, fontSize: 10)),
                  Text(day, style: AppType.numeralSmall.copyWith(color: ink, height: 1.1)),
                ],
              ),
            ),
            const SizedBox(width: Spacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.heading.copyWith(color: ink, fontSize: 17),
                  ),
                  Text('$weekday · $time', style: AppType.small.copyWith(color: p.muted)),
                  Text(t.org.name, style: AppType.captionQuiet.copyWith(color: p.faint)),
                ],
              ),
            ),
            const SizedBox(width: Spacing.x2),
            chip(t),
          ],
        ),
        stub: t.hasQr
            ? Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: QrImageView(
                      data: t.qrPayload,
                      padding: EdgeInsets.zero,
                      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: ink),
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.x3),
                  Expanded(
                    child: Text(
                      t.checkedIn ? "You're in." : 'Tap to show your QR code',
                      style: AppType.small.copyWith(color: p.muted, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: p.faint),
                ],
              )
            : null,
      ),
    );
  }
}
