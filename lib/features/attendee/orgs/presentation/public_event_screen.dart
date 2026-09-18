import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/router/guards.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/illustrations.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/ui/hero_scaffold.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/ui/skeleton.dart';
import '../../../../core/ui/slide_to_act.dart';
import '../../../../core/ui/stagger.dart';
import '../../../../core/ui/tiles.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../../auth/application/auth_controller.dart';
import '../../registration/presentation/register_sheet.dart';
import '../application/public_events_controller.dart';
import '../application/recent_orgs_controller.dart';
import '../domain/public_org.dart';
import 'org_events_screen.dart';

/// One event's public page — the reference's third screen: illustration,
/// "By {org}" and the title over it, date tile with Add-to-calendar, who's
/// going, description, and a slide-to-register at the bottom. Public to
/// read; registering asks for a sign-in first.
class PublicEventScreen extends ConsumerWidget {
  const PublicEventScreen({super.key, required this.orgSlug, required this.eventSlug});

  final String orgSlug;
  final String eventSlug;

  Future<void> _register(BuildContext context, WidgetRef ref, PublicEventPage page) async {
    final user = ref.read(authControllerProvider).user;
    if (user == null) {
      unawaited(context.push(loginFor(GoRouterState.of(context).uri)));
      return;
    }
    final result = await showRegisterSheet(
      context,
      org: orgSlug,
      event: page.event,
      email: user.email,
      initialName: user.name,
    );
    final ticket = result?.ticket;
    if (ticket != null && context.mounted) unawaited(context.push(Routes.ticket(ticket.id)));
  }

  /// A Google Calendar template link works everywhere without a plugin.
  static Uri calendarUrl(PublicEvent e, String org) {
    String stamp(DateTime d) =>
        d.toUtc().toIso8601String().replaceAll(RegExp(r'[-:]|\.\d+'), '');
    final end = e.endsAt ?? e.startsAt.add(const Duration(hours: 2));
    return Uri.https('calendar.google.com', '/calendar/render', {
      'action': 'TEMPLATE',
      'text': e.title,
      'dates': '${stamp(e.startsAt)}/${stamp(end)}',
      'details': 'Hosted by $org',
      'ctz': e.timezone,
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final provider = publicEventProvider(orgSlug, eventSlug);
    final page = ref.watch(provider);

    ref.listen(provider, (_, next) {
      final org = next.value?.org;
      if (org != null) ref.read(recentOrgsProvider.notifier).remember(org);
    });

    final notFound = page.hasError && (page.error as ApiError?)?.status == 404;
    final data = page.value;
    final e = data?.event;

    return HeroScaffold(
      image: AssetImage(Illustrations.event(eventSlug)),
      heroFraction: 0.46,
      eyebrow: data == null ? null : 'By ${data.org.name}',
      title: e?.title ?? (notFound ? 'Not open' : ''),
      heroOverlay: e == null ? null : PublicEventCard.availabilityChip(e),
      onRefresh: () => ref.refresh(provider.future),
      bottom: e == null
          ? null
          : BottomActionBar(
              child: SlideToAct(
                label: e.isFull ? 'Swipe to join the waitlist' : 'Swipe to register',
                disabledLabel: 'Full — no places left',
                enabled: e.canRegister,
                onComplete: () => _register(context, ref, data!),
              ),
            ),
      children: [
        if (notFound)
          const EmptyState(
            icon: Icons.event_busy_outlined,
            title: 'This event is not open',
            hint: "It may have been closed, or the link isn't right.",
          )
        else if (page.hasError && data == null)
          ErrorBanner(
            margin: EdgeInsets.zero,
            message: (page.error as ApiError?)?.message ?? 'Something went wrong.',
            onRetry: () => ref.invalidate(provider),
          )
        else if (e == null)
          const Skeleton.cards(rows: 3, height: 80)
        else ...[
          Enter(child: _DateRow(event: e, org: data!.org.name)),
          const SizedBox(height: Spacing.x4),
          Enter(index: 1, child: _Going(event: e)),
          if ((e.description ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: Spacing.x6),
            Enter(
              index: 2,
              child: Container(
                padding: const EdgeInsets.all(Spacing.gutter),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(Radii.card),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description', style: AppType.heading.copyWith(color: p.ink)),
                    const SizedBox(height: Spacing.x2),
                    Text(e.description!.trim(), style: AppType.body.copyWith(color: p.muted)),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: Spacing.x4),
          Enter(
            index: 3,
            child: Text(
              e.timezone.replaceAll('_', ' '),
              textAlign: TextAlign.center,
              style: AppType.captionQuiet.copyWith(color: p.faint),
            ),
          ),
        ],
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.event, required this.org});

  final PublicEvent event;
  final String org;

  @override
  Widget build(BuildContext context) {
    final (month, day, weekday, time) = AppTime.dateParts(event.startsAt, event.endsAt, event.timezone);
    return DateTile(
      month: month,
      day: day,
      weekday: weekday,
      time: time,
      trailing: PillButton(
        label: 'Add',
        icon: Icons.calendar_month_outlined,
        compact: true,
        expanded: false,
        onPressed: () => launchUrl(
          PublicEventScreen.calendarUrl(event, org),
          mode: LaunchMode.externalApplication,
        ),
      ),
    );
  }
}

/// "+N going" from the public counts: confirmed = capacity − remaining.
class _Going extends StatelessWidget {
  const _Going({required this.event});

  final PublicEvent event;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final cap = event.capacity;
    final rem = event.remaining;
    final going = cap != null && rem != null ? cap - rem : null;
    if (going == null || going <= 0) {
      return Text(
        cap == null ? 'Open to everyone — no cap on places.' : 'Be the first to register.',
        style: AppType.small.copyWith(color: p.muted),
      );
    }
    final heads = going.clamp(0, 3);
    return Row(
      children: [
        AvatarStack(placeholders: heads, extra: going - heads),
        const SizedBox(width: Spacing.x2),
        Expanded(
          child: Text(
            '$going going',
            style: AppType.bodyStrong.copyWith(color: p.ink),
          ),
        ),
      ],
    );
  }
}
