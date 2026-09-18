import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../orgs/application/selected_org_controller.dart';
import '../../orgs/presentation/org_picker_sheet.dart';
import '../application/events_controller.dart';
import 'event_card.dart';

/// Organizer "Events" tab for the selected org. Port of the Expo
/// EventsScreen, with the org switcher in the app bar.
class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(org.name),
        actions: const [OrgSwitcherButton()],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(orgEventsProvider(org.slug).future),
        child: AsyncView(
          value: events,
          onRetry: () => ref.invalidate(orgEventsProvider(org.slug)),
          data: (page) {
            if (page.events.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: Spacing.x10),
                  EmptyState(
                    icon: Icons.event_busy_outlined,
                    title: 'No events yet',
                    hint: 'Events created on the web will appear here.',
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(Spacing.x4),
              itemCount: page.events.length,
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.x3),
              itemBuilder: (context, i) {
                final e = page.events[i];
                return EventCard(
                  event: e,
                  onTap: () => context.push(Routes.orgEventAttendees(e.slug)),
                  onScan: () => context.push('${Routes.orgScanLive}?event=${Uri.encodeComponent(e.slug)}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
