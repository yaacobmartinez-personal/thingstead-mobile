import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/section_card.dart';
import '../application/tickets_controller.dart';
import '../domain/ticket.dart';

/// One ticket: the QR when it is a confirmed place, the details, and
/// "Cancel my place" until the event starts. Port of the web manage page.
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

class _Body extends StatelessWidget {
  const _Body({required this.ticket, required this.busy, required this.onCancel});

  final Ticket ticket;
  final bool busy;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final t = ticket;
    final e = t.event;
    return ListView(
      padding: const EdgeInsets.all(Spacing.x4),
      children: [
        if (t.hasQr) TicketQr(ticket: t) else _NoQrCard(ticket: t),
        const SizedBox(height: Spacing.x4),
        SectionCard(
          heading: e.title,
          children: [
            Text(
              AppTime.formatEventWhen(e.startsAt, e.endsAt, e.timezone),
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            ),
            const SizedBox(height: Spacing.x3),
            _Row('Organizer', t.org.name),
            _Row('Name', t.name ?? '—'),
            _Row('Email', t.email),
            if (t.checkedIn)
              _Row('Checked in', AppTime.formatTime(t.checkedInAt!, e.timezone)),
            const SizedBox(height: Spacing.x2),
            Align(
              alignment: Alignment.centerLeft,
              child: StatusChip(
                t.statusLabel,
                tone: switch (t.status) {
                  _ when t.isCancelled => ChipTone.muted,
                  _ when t.isConfirmed => ChipTone.success,
                  _ => ChipTone.warn,
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.x3),
        OutlinedButton.icon(
          onPressed: () => context.push(Routes.attendeeEvent(t.org.slug, e.slug)),
          icon: const Icon(Icons.open_in_new, size: 18),
          label: const Text('Event page'),
        ),
        if (t.canCancel) ...[
          const SizedBox(height: Spacing.x6),
          TextButton(
            onPressed: busy ? null : onCancel,
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(busy ? 'Cancelling…' : 'Cancel my place'),
          ),
        ] else if (t.isCancelled)
          const Padding(
            padding: EdgeInsets.only(top: Spacing.x4),
            child: Text(
              'You gave up this place. If you can make it after all, sign up again '
              'on the event page — though the place may have gone to someone else by now.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, height: 1.4),
            ),
          )
        else if (t.started)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.x4),
            child: Text(
              '${e.title} has already started, so it can no longer be cancelled here.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ),
      ],
    );
  }
}

/// The check-in QR, big and on white so a scanner reads it in any light.
class TicketQr extends StatelessWidget {
  const TicketQr({super.key, required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.x4),
        child: Column(
          children: [
            Semantics(
              label: 'Your check-in QR code',
              child: QrImageView(
                data: ticket.qrPayload,
                size: 260,
                backgroundColor: Colors.white,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
                eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.navyDark),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppColors.navyDark,
                ),
              ),
            ),
            const SizedBox(height: Spacing.x2),
            Text(
              ticket.checkedIn ? "You're checked in." : 'Show this at the door.',
              style: TextStyle(
                color: ticket.checkedIn ? AppColors.success : AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoQrCard extends StatelessWidget {
  const _NoQrCard({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final (icon, text) = ticket.isCancelled
        ? (Icons.cancel_outlined, 'This place was cancelled, so there is no ticket to show.')
        : (Icons.hourglass_top, "You're on the waitlist. A ticket appears here if a place opens up.");
    return Container(
      padding: const EdgeInsets.all(Spacing.x5),
      decoration: BoxDecoration(
        color: AppColors.neutralBg,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.faint),
          const SizedBox(height: Spacing.x3),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: Spacing.x1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 96,
              child: Text(label, style: const TextStyle(color: AppColors.faint)),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );
}
