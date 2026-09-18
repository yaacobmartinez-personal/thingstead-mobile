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
import '../../../../core/theme/illustrations.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/ui/hero_scaffold.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/ui/round_icon_button.dart';
import '../../../../core/ui/skeleton.dart';
import '../../../../core/ui/stagger.dart';
import '../../../../core/ui/stats.dart';
import '../../../../core/ui/tiles.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../attendees/application/attendee_actions.dart';
import '../../orgs/application/selected_org_controller.dart';
import '../application/event_detail_controller.dart';
import '../domain/event_detail.dart';
import 'event_card.dart';

/// One event for its organizer: hero, counters, date, public link, and the
/// actions (Attendees, Scan, Publish/Close, Edit, Export, Delete).
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

  Future<void> _menu(String org, EventDetail event, {required bool canExport, required bool canDelete}) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      builder: (context) {
        final p = context.palette;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canExport)
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: const Text('Export attendees (CSV)'),
                  onTap: () => Navigator.of(context).pop('export'),
                ),
              if (canDelete)
                ListTile(
                  leading: Icon(Icons.delete_outline, color: p.danger),
                  title: Text('Delete event', style: TextStyle(color: p.danger)),
                  onTap: () => Navigator.of(context).pop('delete'),
                ),
              const SizedBox(height: Spacing.x2),
            ],
          ),
        );
      },
    );
    if (!mounted) return;
    switch (choice) {
      case 'export':
        await _export(org, event);
      case 'delete':
        await _delete(org, event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final org = ref.watch(selectedOrgProvider);
    if (org == null) return const Scaffold(body: SizedBox.shrink());
    final mode = ref.watch(apiModeProvider);
    final canEdit = isAvailable(Feature.eventCrud, mode);
    final canExport = isAvailable(Feature.csvExport, mode);
    final canDelete = canEdit && org.isAdmin;
    final provider = eventDetailProvider(org.slug, widget.eventSlug);
    final detail = ref.watch(provider);
    final event = detail.value;
    final notFound = detail.hasError && (detail.error as ApiError?)?.status == 404;

    return HeroScaffold(
      image: AssetImage(Illustrations.event(widget.eventSlug)),
      heroFraction: 0.40,
      eyebrow: org.name,
      title: event?.title ?? (notFound ? 'Not found' : ''),
      heroOverlay: event == null
          ? null
          : Builder(builder: (context) {
              final (label, tone) = EventCard.statusChip(event.status);
              return StatusChip(label, tone: tone);
            }),
      actions: [
        if (canEdit && event != null)
          RoundIconButton(
            icon: Icons.edit_outlined,
            tooltip: 'Edit',
            onPressed: _busy ? null : () => context.push(Routes.orgEventEdit(widget.eventSlug)),
          ),
        if (event != null && (canExport || canDelete))
          RoundIconButton(
            icon: Icons.more_horiz,
            tooltip: 'More',
            onPressed: _busy
                ? null
                : () => _menu(org.slug, event, canExport: canExport, canDelete: canDelete),
          ),
      ],
      onRefresh: () => ref.refresh(provider.future),
      bottom: event == null
          ? null
          : BottomActionBar(
              child: Row(
                children: [
                  Expanded(
                    child: PillButton(
                      label: 'Attendees (${event.registrations})',
                      icon: Icons.people_outline,
                      onPressed: _busy ? null : () => context.push(Routes.orgEventAttendees(event.slug)),
                    ),
                  ),
                  const SizedBox(width: Spacing.x2),
                  PillButton(
                    label: 'Scan',
                    icon: Icons.qr_code_scanner,
                    variant: PillVariant.strong,
                    expanded: false,
                    onPressed: _busy
                        ? null
                        : () => context.push(
                              '${Routes.orgScanLive}?event=${Uri.encodeComponent(event.slug)}',
                            ),
                  ),
                ],
              ),
            ),
      children: [
        if (notFound)
          const EmptyState(icon: Icons.event_busy_outlined, title: 'Event not found')
        else if (detail.hasError && event == null)
          ErrorBanner(
            margin: EdgeInsets.zero,
            message: (detail.error as ApiError?)?.message ?? 'Something went wrong.',
            onRetry: () => ref.invalidate(provider),
          )
        else if (event == null)
          const Skeleton.cards(rows: 3, height: 90)
        else ...[
          Enter(
            child: Container(
              padding: const EdgeInsets.all(Spacing.gutter),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(Radii.card)),
              child: Row(
                children: [
                  Expanded(
                    child: StatCounter(
                      value: event.confirmed,
                      suffix: event.capacity == null ? null : ' / ${event.capacity}',
                      label: 'Confirmed',
                      color: event.isFull ? p.warn : null,
                    ),
                  ),
                  Expanded(child: StatCounter(value: event.waitlist, label: 'Waitlist')),
                  Expanded(child: StatCounter(value: event.checkedIn, label: 'Checked in', color: p.success)),
                ],
              ),
            ),
          ),
          if (event.isFull)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.x2),
              child: Text(
                event.waitlistEnabled
                    ? 'Full — new sign-ups join the waitlist.'
                    : 'Full — new sign-ups are turned away.',
                style: AppType.small.copyWith(color: p.warn, fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(height: Spacing.x4),
          Enter(index: 1, child: _DateRow(event: event)),
          if (canEdit) ...[
            const SizedBox(height: Spacing.x4),
            Enter(
              index: 2,
              child: PillButton(
                label: event.status == EventStatus.published ? 'Close registrations' : 'Publish',
                icon: event.status == EventStatus.published ? Icons.lock_outline : Icons.publish_outlined,
                variant: PillVariant.ghost,
                loading: _busy,
                onPressed: _busy
                    ? null
                    : () => _setStatus(
                          org.slug,
                          event,
                          event.status == EventStatus.published ? EventStatus.closed : EventStatus.published,
                        ),
              ),
            ),
          ],
          if ((event.description ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: Spacing.x4),
            Enter(
              index: 3,
              child: Container(
                padding: const EdgeInsets.all(Spacing.gutter),
                decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(Radii.card)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description', style: AppType.heading.copyWith(color: p.ink)),
                    const SizedBox(height: Spacing.x2),
                    Text(event.description!.trim(), style: AppType.body.copyWith(color: p.muted)),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: Spacing.x4),
          Enter(index: 4, child: _PublicLink(org: org.slug, event: event, onToast: _toast)),
          const SizedBox(height: Spacing.x4),
          Text(
            'Created ${AppTime.formatEventDate(event.createdAt, event.timezone)} · ${event.timezone.replaceAll('_', ' ')}',
            textAlign: TextAlign.center,
            style: AppType.captionQuiet.copyWith(color: p.faint),
          ),
        ],
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.event});

  final EventDetail event;

  @override
  Widget build(BuildContext context) {
    final (month, day, weekday, time) = AppTime.dateParts(event.startsAt, event.endsAt, event.timezone);
    return DateTile(month: month, day: day, weekday: weekday, time: time);
  }
}

class _PublicLink extends StatelessWidget {
  const _PublicLink({required this.org, required this.event, required this.onToast});

  final String org;
  final EventDetail event;
  final ValueChanged<String> onToast;

  String get _url => '${AppConfig.publicOrigin}/$org/${event.slug}';

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final published = event.status == EventStatus.published;
    return Container(
      padding: const EdgeInsets.all(Spacing.gutter),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(Radii.card)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Public link', style: AppType.heading.copyWith(color: p.ink)),
          const SizedBox(height: Spacing.x1),
          Text(
            published
                ? 'Share this so people can register.'
                : 'Only published events are visible at this address.',
            style: AppType.small.copyWith(color: p.muted),
          ),
          const SizedBox(height: Spacing.x3),
          SelectableText(_url, style: AppType.bodyStrong.copyWith(color: p.moss)),
          const SizedBox(height: Spacing.x3),
          Row(
            children: [
              Expanded(
                child: PillButton(
                  label: 'Copy',
                  icon: Icons.copy_outlined,
                  variant: PillVariant.subtle,
                  compact: true,
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: _url));
                    onToast('Link copied.');
                  },
                ),
              ),
              const SizedBox(width: Spacing.x2),
              Expanded(
                child: PillButton(
                  label: 'Share',
                  icon: Icons.share_outlined,
                  variant: PillVariant.subtle,
                  compact: true,
                  onPressed: () => SharePlus.instance.share(
                    ShareParams(uri: Uri.parse(_url), subject: event.title),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
