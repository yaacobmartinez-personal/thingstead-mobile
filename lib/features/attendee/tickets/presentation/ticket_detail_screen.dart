import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/ui/stagger.dart';
import '../../../../core/ui/ticket_card.dart';
import '../../../../core/ui/tiles.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../application/tickets_controller.dart';
import '../domain/ticket.dart';

/// One ticket as a ticket: event on the top half, the QR on the stub when it
/// is a confirmed place, and "Cancel my place" until the event starts.
class TicketDetailScreen extends ConsumerStatefulWidget {
  const TicketDetailScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  ConsumerState<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  bool _busy = false;

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _cancel(Ticket t) async {
    final ok = await confirmDialog(
      context,
      title: 'Cancel your place?',
      message: 'This frees your place at ${t.event.title} for someone else. There is '
          "no undo — if you change your mind you'll need to register again, and the "
          'place may have gone by then.',
      confirmLabel: 'Yes, cancel my place',
      cancelLabel: 'Keep my place',
      destructive: true,
    );
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      final outcome = await ref.read(ticketActionsProvider.notifier).cancel(t.id);
      _toast(switch (outcome) {
        CancelOutcome.cancelled => 'Your place has been given up.',
        CancelOutcome.already => 'This place was already cancelled.',
        CancelOutcome.started =>
          '${t.event.title} has already started, so it can no longer be cancelled here.',
      });
    } on ApiError catch (e) {
      _toast(e.message);
    } catch (_) {
      _toast('Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ticketProvider(widget.ticketId);
    final ticket = ref.watch(provider);
    final notFound = ticket.hasError && (ticket.error as ApiError?)?.status == 404;

    return Scaffold(
      appBar: AppBar(title: Text(ticket.value?.event.title ?? 'Ticket')),
      body: notFound
          ? const EmptyState(
              icon: Icons.confirmation_number_outlined,
              title: "This ticket isn't available",
              hint: 'It may have been erased, or it belongs to another account.',
            )
          : RefreshIndicator(
              onRefresh: () => ref.refresh(provider.future),
              child: AsyncView(
                value: ticket,
                onRetry: () => ref.invalidate(provider),
                data: (t) => _Body(ticket: t, busy: _busy, onCancel: () => _cancel(t)),
              ),
            ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.ticket, required this.busy, required this.onCancel});

  final Ticket ticket;
  final bool busy;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final t = ticket;
    final e = t.event;
    final (month, day, weekday, time) = AppTime.dateParts(e.startsAt, e.endsAt, e.timezone);
    final tone = t.isCancelled
        ? ChipTone.muted
        : t.isConfirmed
            ? ChipTone.success
            : ChipTone.warn;

    return ListView(
      padding: const EdgeInsets.fromLTRB(Spacing.gutter, Spacing.x2, Spacing.gutter, Spacing.x8),
      children: [
        Enter(
          child: TicketCard(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(t.org.name.toUpperCase(),
                          style: AppType.caption.copyWith(color: p.faint)),
                    ),
                    StatusChip(t.statusLabel, tone: tone, dot: t.checkedIn),
                  ],
                ),
                const SizedBox(height: Spacing.x2),
                Text(e.title, style: AppType.title.copyWith(color: p.ink)),
                const SizedBox(height: Spacing.x4),
                DateTile(month: month, day: day, weekday: weekday, time: time, compact: true),
                const SizedBox(height: Spacing.x4),
                _Row('Name', t.name ?? '—'),
                _Row('Email', t.email),
                if (t.checkedIn) _Row('Checked in', AppTime.formatTime(t.checkedInAt!, e.timezone)),
              ],
            ),
            stub: t.hasQr ? _Qr(ticket: t) : _NoQr(ticket: t),
          ),
        ),
        const SizedBox(height: Spacing.x4),
        Enter(
          index: 1,
          child: PillButton(
            label: 'Event page',
            icon: Icons.open_in_new,
            variant: PillVariant.ghost,
            onPressed: () => context.push(Routes.attendeeEvent(t.org.slug, e.slug)),
          ),
        ),
        if (t.canCancel) ...[
          const SizedBox(height: Spacing.x3),
          Enter(
            index: 2,
            child: PillButton(
              label: busy ? 'Cancelling…' : 'Cancel my place',
              variant: PillVariant.danger,
              loading: busy,
              onPressed: busy ? null : onCancel,
            ),
          ),
        ] else if (t.isCancelled)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.x4),
            child: Text(
              'You gave up this place. If you can make it after all, sign up again '
              'on the event page — though the place may have gone to someone else by now.',
              textAlign: TextAlign.center,
              style: AppType.small.copyWith(color: p.muted),
            ),
          )
        else if (t.started)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.x4),
            child: Text(
              '${e.title} has already started, so it can no longer be cancelled here.',
              textAlign: TextAlign.center,
              style: AppType.small.copyWith(color: p.muted),
            ),
          ),
      ],
    );
  }
}

/// The QR, big and on white so a scanner reads it in any light, breathing
/// very slightly so it reads as live.
class _Qr extends ConsumerWidget {
  const _Qr({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final animate = ref.watch(motionSettingsProvider);
    Widget qr = Container(
      padding: const EdgeInsets.all(Spacing.x3),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Radii.md)),
      child: Semantics(
        label: 'Your check-in QR code',
        child: QrImageView(
          data: ticket.qrPayload,
          size: 220,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          errorCorrectionLevel: QrErrorCorrectLevel.M,
          eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF171C14)),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: Color(0xFF171C14),
          ),
        ),
      ),
    );
    if (animate) {
      qr = qr
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 1800.ms);
    }
    return Column(
      children: [
        Center(child: qr),
        const SizedBox(height: Spacing.x3),
        Text(
          ticket.checkedIn ? "You're checked in." : 'Show this at the door.',
          style: AppType.bodyStrong.copyWith(color: ticket.checkedIn ? p.success : p.muted),
        ),
      ],
    );
  }
}

class _NoQr extends StatelessWidget {
  const _NoQr({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final (icon, text) = ticket.isCancelled
        ? (Icons.cancel_outlined, 'This place was cancelled, so there is no ticket to show.')
        : (Icons.hourglass_top, "You're on the waitlist. A ticket appears here if a place opens up.");
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: p.surfaceTint, shape: BoxShape.circle),
          child: Icon(icon, color: p.faint),
        ),
        const SizedBox(width: Spacing.x3),
        Expanded(child: Text(text, style: AppType.small.copyWith(color: p.muted))),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.x1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 96, child: Text(label, style: AppType.small.copyWith(color: p.faint))),
          Expanded(child: Text(value, style: AppType.small.copyWith(color: p.ink, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
