import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(page.value?.org.name ?? orgSlug)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(provider.future),
        child: page.hasError && (page.error as ApiError?)?.status == 404
            ? ListView(
                children: const [
                  SizedBox(height: Spacing.x10),
                  EmptyState(
                    icon: Icons.search_off,
                    title: 'Organization not found',
                    hint: "Check the code — it's the last part of their link.",
                  ),
                ],
              )
            : AsyncView(
                value: page,
                onRetry: () => ref.invalidate(provider),
                data: (data) {
                  if (data.events.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: Spacing.x10),
                        EmptyState(
                          icon: Icons.event_busy_outlined,
                          title: 'No upcoming events',
                          hint: '${data.org.name} has nothing open for registration '
                              'right now.',
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(Spacing.x4),
                    itemCount: data.events.length,
                    separatorBuilder: (_, _) => const SizedBox(height: Spacing.x3),
                    itemBuilder: (context, i) {
                      final e = data.events[i];
                      return PublicEventCard(
                        event: e,
                        onTap: () => context.push(Routes.attendeeEvent(orgSlug, e.slug)),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

/// Title, when, and availability — the public list's card.
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
    return StatusChip(label, tone: ChipTone.success);
  }

  @override
  Widget build(BuildContext context) {
    final chip = availabilityChip(event);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: Spacing.x1),
              Text(
                AppTime.formatEventWhen(event.startsAt, event.endsAt, event.timezone),
                style: const TextStyle(color: AppColors.muted, height: 1.4),
              ),
              if (chip != null) ...[const SizedBox(height: Spacing.x3), chip],
            ],
          ),
        ),
      ),
    );
  }
}
