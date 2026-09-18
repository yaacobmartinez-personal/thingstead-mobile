import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/section_card.dart';
import '../../attendees/application/attendee_actions.dart';
import '../../orgs/application/selected_org_controller.dart';
import '../application/event_detail_controller.dart';
import '../domain/event_detail.dart';
import 'event_card.dart';

/// One event: counts, public link, publish/close, attendees, export, edit,
/// delete. Port of the web event page header plus the Expo card actions.
class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({super.key, required this.eventSlug});

  final String eventSlug;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _busy = false;

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Runs an action with the busy flag set and surfaces any error.
  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } on ApiError catch (e) {
      _toast(e.message);
    } catch (_) {
      _toast('Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setStatus(String org, EventDetail event, EventStatus status) => _run(() async {
        await ref.read(eventActionsProvider.notifier).setStatus(org, event.slug, status);
        _toast(switch (status) {
          EventStatus.published => 'Event published.',
          EventStatus.closed => 'Registrations closed.',
          EventStatus.draft => 'Event moved back to draft.',
        });
      });

  Future<void> _export(String org, EventDetail event) => _run(() async {
        await ref.read(attendeeActionsProvider.notifier).export(org, event.slug);
      });

  Future<void> _delete(String org, EventDetail event) async {
    final n = event.registrations;
    final ok = await confirmDialog(
      context,
      title: 'Delete this event?',
      message: n == 0
          ? '"${event.title}" will be removed. This cannot be undone.'
          : '"${event.title}" and its $n ${n == 1 ? 'registration' : 'registrations'} '
              'will be removed. This cannot be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok || !mounted) return;
    await _run(() async {
      await ref.read(eventActionsProvider.notifier).delete(org, event.slug);
      if (!mounted) return;
      _toast('Event deleted.');
      context.go(Routes.orgEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    final org = ref.watch(selectedOrgProvider);
    if (org == null) return const Scaffold(body: SizedBox.shrink());
    final mode = ref.watch(apiModeProvider);
    final canEdit = isAvailable(Feature.eventCrud, mode);
    final canExport = isAvailable(Feature.csvExport, mode);
    final provider = eventDetailProvider(org.slug, widget.eventSlug);
    final detail = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(detail.value?.title ?? 'Event'),
        actions: [
          if (canEdit && detail.hasValue)
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: _busy ? null : () => context.push(Routes.orgEventEdit(widget.eventSlug)),
            ),
          if (detail.hasValue && (canExport || (canEdit && org.isAdmin)))
            PopupMenuButton<String>(
              enabled: !_busy,
              onSelected: (value) {
                final event = detail.requireValue;
                switch (value) {
                  case 'export':
                    _export(org.slug, event);
                  case 'delete':
                    _delete(org.slug, event);
                }
              },
              itemBuilder: (context) => [
                if (canExport)
                  const PopupMenuItem(
                    value: 'export',
                    child: ListTile(
                      leading: Icon(Icons.download_outlined),
                      title: Text('Export attendees (CSV)'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                if (canEdit && org.isAdmin)
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, color: AppColors.danger),
                      title: Text('Delete event', style: TextStyle(color: AppColors.danger)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(provider.future),
        child: AsyncView(
          value: detail,
          onRetry: () => ref.invalidate(provider),
          data: (event) => _Body(
            org: org.slug,
            event: event,
            busy: _busy,
            canEdit: canEdit,
            onPublish: () => _setStatus(org.slug, event, EventStatus.published),
            onClose: () => _setStatus(org.slug, event, EventStatus.closed),
            onToast: _toast,
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.org,
    required this.event,
    required this.busy,
    required this.canEdit,
    required this.onPublish,
    required this.onClose,
    required this.onToast,
  });

  final String org;
  final EventDetail event;
  final bool busy;
  final bool canEdit;
  final VoidCallback onPublish;
  final VoidCallback onClose;
  final ValueChanged<String> onToast;

  String get _publicUrl => '${AppConfig.publicOrigin}/$org/${event.slug}';

  @override
  Widget build(BuildContext context) {
    final (label, tone) = EventCard.statusChip(event.status);
    final isPublished = event.status == EventStatus.published;
    return ListView(
      padding: const EdgeInsets.all(Spacing.x4),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                event.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: Spacing.x3),
            StatusChip(label, tone: tone),
          ],
        ),
        const SizedBox(height: Spacing.x2),
        Text(
          AppTime.formatEventWhen(event.startsAt, event.endsAt, event.timezone),
          style: const TextStyle(color: AppColors.muted, height: 1.4),
        ),
        Text(
          event.timezone.replaceAll('_', ' '),
          style: const TextStyle(color: AppColors.faint, fontSize: 12),
        ),
        if ((event.description ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: Spacing.x3),
          Text(event.description!.trim(), style: const TextStyle(height: 1.45)),
        ],
        const SizedBox(height: Spacing.x4),
        Row(
          children: [
            Expanded(
              child: _Stat(label: 'Confirmed', value: event.headcount, warn: event.isFull),
            ),
            Expanded(child: _Stat(label: 'Waitlist', value: '${event.waitlist}')),
            Expanded(
              child: _Stat(label: 'Checked in', value: '${event.checkedIn}', accent: true),
            ),
          ],
        ),
        if (event.isFull)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.x2),
            child: Text(
              event.waitlistEnabled
                  ? 'Full — new sign-ups join the waitlist.'
                  : 'Full — new sign-ups are turned away.',
              style: const TextStyle(color: AppColors.warn, fontSize: 13),
            ),
          ),
        const SizedBox(height: Spacing.x4),
        FilledButton.icon(
          onPressed: busy ? null : () => context.push(Routes.orgEventAttendees(event.slug)),
          icon: const Icon(Icons.people_outline, size: 20),
          label: Text('Attendees (${event.registrations})'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
        const SizedBox(height: Spacing.x2),
        OutlinedButton.icon(
          onPressed: busy
              ? null
              : () => context.push(
                    '${Routes.orgScanLive}?event=${Uri.encodeComponent(event.slug)}',
                  ),
          icon: const Icon(Icons.qr_code_scanner, size: 20),
          label: const Text('Scan check-in'),
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
        if (canEdit) ...[
          const SizedBox(height: Spacing.x2),
          OutlinedButton.icon(
            onPressed: busy ? null : (isPublished ? onClose : onPublish),
            icon: Icon(isPublished ? Icons.lock_outline : Icons.publish_outlined, size: 20),
            label: Text(isPublished ? 'Close registrations' : 'Publish'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
        ],
        const SizedBox(height: Spacing.x4),
        SectionCard(
          heading: 'Public link',
          body: isPublished
              ? 'Share this so people can register.'
              : 'Only published events are visible at this address.',
          children: [
            SelectableText(
              _publicUrl,
              style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: Spacing.x3),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: _publicUrl));
                      onToast('Link copied.');
                    },
                    icon: const Icon(Icons.copy_outlined, size: 18),
                    label: const Text('Copy'),
                  ),
                ),
                const SizedBox(width: Spacing.x2),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => SharePlus.instance.share(
                      ShareParams(uri: Uri.parse(_publicUrl), subject: event.title),
                    ),
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: Spacing.x4),
        Text(
          'Created ${AppTime.formatEventDate(event.createdAt, event.timezone)}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.faint, fontSize: 12),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.accent = false,
    this.warn = false,
  });

  final String label;
  final String value;
  final bool accent;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: accent
                ? AppColors.success
                : warn
                    ? AppColors.warn
                    : AppColors.navy,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 11, color: AppColors.faint, letterSpacing: 0.4),
        ),
      ],
    );
  }
}
