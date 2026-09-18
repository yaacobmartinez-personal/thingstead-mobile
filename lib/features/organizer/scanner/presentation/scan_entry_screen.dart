import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/model/enums.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../checkin/presentation/sync_badge.dart';
import '../../events/application/events_controller.dart';
import '../../orgs/application/selected_org_controller.dart';

/// The Scan tab: pick which event to scan for (published first), or scan
/// for any event without the wrong-event check.
class ScanEntryScreen extends ConsumerWidget {
  const ScanEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = ref.watch(selectedOrgProvider);
    if (org == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan check-in')),
        body: const EmptyState(icon: Icons.business_outlined, title: 'No organization'),
      );
    }
    final events = ref.watch(orgEventsProvider(org.slug));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan check-in'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: Spacing.x3),
            child: Center(child: SyncBadge(onDark: true)),
          ),
        ],
      ),
      body: AsyncView(
        value: events,
        onRetry: () => ref.invalidate(orgEventsProvider(org.slug)),
        data: (page) {
          final scannable = page.events
              .where((e) => e.status != EventStatus.draft)
              .toList()
            ..sort((a, b) {
              // Published before closed, then soonest first.
              if (a.status != b.status) {
                return a.status == EventStatus.published ? -1 : 1;
              }
              return a.startsAt.compareTo(b.startsAt);
            });
          return ListView(
            padding: const EdgeInsets.all(Spacing.x4),
            children: [
              const Text(
                'Which event are you checking people in for?',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: Spacing.x3),
              if (scannable.isEmpty)
                const EmptyState(
                  icon: Icons.event_busy_outlined,
                  title: 'No published events',
                  hint: 'Publish an event first, or scan for any event below.',
                ),
              for (final e in scannable)
                Card(
                  margin: const EdgeInsets.only(bottom: Spacing.x2),
                  child: ListTile(
                    leading: const Icon(Icons.qr_code_scanner, color: AppColors.navy),
                    title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${AppTime.formatEventDate(e.startsAt, e.timezone)} · '
                      '${e.checkedIn} of ${e.confirmed} in',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(
                      '${Routes.orgScanLive}?event=${Uri.encodeComponent(e.slug)}',
                    ),
                  ),
                ),
              const SizedBox(height: Spacing.x2),
              OutlinedButton.icon(
                onPressed: () => context.push(Routes.orgScanLive),
                icon: const Icon(Icons.all_inclusive),
                label: const Text('Scan for any event'),
              ),
            ],
          );
        },
      ),
    );
  }
}
