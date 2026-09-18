import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/ui/stagger.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../orgs/application/selected_org_controller.dart';
import '../../orgs/presentation/org_picker_sheet.dart';
import '../application/events_controller.dart';
import 'event_card.dart';

/// Organizer "Events" tab for the selected org: greeting header with the
/// org switcher, staggered cards, and a floating "New event" pill.
class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final org = ref.watch(selectedOrgProvider);
    if (org == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Events')),
        body: const EmptyState(
          icon: Icons.business_outlined,
          title: 'No organization',
          hint: 'Create one on the web, or ask an admin to invite you.',
        ),
      );
    }

    final events = ref.watch(orgEventsProvider(org.slug));
    final canCreate = isAvailable(Feature.eventCrud, ref.watch(apiModeProvider));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your events', style: AppType.captionQuiet.copyWith(color: p.muted)),
            Text(org.name, style: AppType.title.copyWith(color: p.ink, fontSize: 22)),
          ],
        ),
        actions: const [Padding(padding: EdgeInsets.only(right: Spacing.x2), child: OrgSwitcherButton())],
      ),
      floatingActionButton: canCreate
          ? FloatingActionButton.extended(
              onPressed: () => context.push(Routes.orgEventNew),
              icon: const Icon(Icons.add),
              label: const Text('New event'),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(orgEventsProvider(org.slug).future),
        child: AsyncView(
          value: events,
          onRetry: () => ref.invalidate(orgEventsProvider(org.slug)),
          data: (page) {
            if (page.events.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: Spacing.x8),
                  EmptyState(
                    icon: Icons.event_busy_outlined,
                    title: 'No events yet',
                    hint: canCreate
                        ? 'Tap "New event" to create your first one.'
                        : 'Events created on the web will appear here.',
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(Spacing.gutter, Spacing.x2, Spacing.gutter, 100),
              itemCount: page.events.length + (page.stale ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.x3),
              itemBuilder: (context, i) {
                if (page.stale && i == 0) return const _StaleBanner();
                final index = i - (page.stale ? 1 : 0);
                final e = page.events[index];
                return Enter(
                  index: index,
                  child: EventCard(
                    event: e,
                    onTap: () => context.push(Routes.orgEvent(e.slug)),
                    onScan: () =>
                        context.push('${Routes.orgScanLive}?event=${Uri.encodeComponent(e.slug)}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _StaleBanner extends StatelessWidget {
  const _StaleBanner();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.x3, vertical: Spacing.x2),
      decoration: BoxDecoration(color: p.warnBg, borderRadius: BorderRadius.circular(Radii.md)),
      child: Row(
        children: [
          Icon(Icons.cloud_off_outlined, size: 16, color: p.warn),
          const SizedBox(width: Spacing.x2),
          Expanded(
            child: Text(
              'Offline: showing saved events. Pull down to retry.',
              style: AppType.small.copyWith(color: p.warn, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
