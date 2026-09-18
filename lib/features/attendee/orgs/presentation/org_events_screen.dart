import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/illustrations.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/ui/hero_scaffold.dart';
import '../../../../core/ui/skeleton.dart';
import '../../../../core/ui/stagger.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_banner.dart';
import '../application/public_events_controller.dart';
import '../application/recent_orgs_controller.dart';
import '../domain/public_org.dart';

/// An organization's public page: its published events, soonest first.
/// Public — no session needed — so shared links open straight here.
class OrgEventsScreen extends ConsumerWidget {
  const OrgEventsScreen({super.key, required this.orgSlug});

  final String orgSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = publicEventsProvider(orgSlug);
    final page = ref.watch(provider);

    // Remember the org once it resolves, so the Find tab offers it back.
    ref.listen(provider, (_, next) {
      final org = next.value?.org;
      if (org != null) ref.read(recentOrgsProvider.notifier).remember(org);
    });

    final notFound = page.hasError && (page.error as ApiError?)?.status == 404;
    final data = page.value;
    final count = data?.events.length;

    return HeroScaffold(
      image: const AssetImage(Illustrations.org),
      heroFraction: 0.38,
      imageAlignment: Alignment.bottomCenter,
      eyebrow: 'Organization',
      title: data?.org.name ?? (notFound ? 'Not found' : orgSlug),
      subtitle: count == null
          ? null
          : count == 0
              ? 'Nothing open right now'
              : '$count upcoming ${count == 1 ? 'event' : 'events'}',
      onRefresh: () => ref.refresh(provider.future),
      children: [
        if (notFound)
          const EmptyState(
            icon: Icons.search_off,
            title: 'Organization not found',
            hint: "Check the code — it's the last part of their link.",
          )
        else if (page.hasError && data == null)
          ErrorBanner(
            margin: EdgeInsets.zero,
            message: (page.error as ApiError?)?.message ?? 'Something went wrong.',
            onRetry: () => ref.invalidate(provider),
          )
        else if (data == null)
          const Skeleton.cards(rows: 3, height: 120)
        else if (data.events.isEmpty)
          EmptyState(
            icon: Icons.event_busy_outlined,
            title: 'No upcoming events',
            hint: '${data.org.name} has nothing open for registration right now.',
          )
        else
          for (final (i, e) in data.events.indexed)
            Enter(
              index: i,
              child: Padding(
                padding: const EdgeInsets.only(bottom: Spacing.x3),
                child: PublicEventCard(
                  event: e,
                  onTap: () => context.push(Routes.attendeeEvent(orgSlug, e.slug)),
                ),
              ),
            ),
      ],
    );
  }
}

/// Date tile, title, when, and availability — the public list's card.
class PublicEventCard extends StatelessWidget {
  const PublicEventCard({super.key, required this.event, required this.onTap});

  final PublicEvent event;
  final VoidCallback onTap;

  static Widget? availabilityChip(PublicEvent e) {
    if (e.isFull) {
      return StatusChip(
        e.waitlistEnabled ? 'Full · waitlist open' : 'Full',
        tone: e.waitlistEnabled ? ChipTone.warn : ChipTone.muted,
      );
    }
    final label = e.placesLabel;
    if (label == null) return null;
    return StatusChip(label, tone: ChipTone.success, dot: true);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final chip = availabilityChip(event);
    final (month, day, weekday, time) = AppTime.dateParts(event.startsAt, event.endsAt, event.timezone);
    return Material(
      color: p.surface,
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                padding: const EdgeInsets.symmetric(vertical: Spacing.x2),
                decoration: BoxDecoration(
                  color: p.surfaceTint,
                  borderRadius: BorderRadius.circular(Radii.md),
                ),
                child: Column(
                  children: [
                    Text(month.toUpperCase(), style: AppType.caption.copyWith(color: p.muted, fontSize: 10)),
                    Text(day, style: AppType.numeralSmall.copyWith(color: p.ink, height: 1.1)),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.heading.copyWith(color: p.ink, fontSize: 17),
                    ),
                    const SizedBox(height: 2),
                    Text('$weekday · $time', style: AppType.small.copyWith(color: p.muted)),
                    if (chip != null) ...[const SizedBox(height: Spacing.x2), chip],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
