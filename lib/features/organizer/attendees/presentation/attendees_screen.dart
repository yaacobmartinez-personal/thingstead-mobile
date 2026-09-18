import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../checkin/presentation/sync_badge.dart';
import '../../orgs/application/selected_org_controller.dart';
import '../application/attendees_controller.dart';
import 'attendee_row.dart';

/// Port of the Expo AttendeesScreen: search, list, optimistic check-in
/// toggle, and a Scan action in the app bar. Search is local over the full
/// list (the server caps at 500 rows).
class AttendeesScreen extends ConsumerStatefulWidget {
  const AttendeesScreen({super.key, required this.eventSlug});

  final String eventSlug;

  @override
  ConsumerState<AttendeesScreen> createState() => _AttendeesScreenState();
}

class _AttendeesScreenState extends ConsumerState<AttendeesScreen> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final org = ref.watch(selectedOrgProvider);
    if (org == null) return const Scaffold(body: SizedBox.shrink());
    final provider = attendeesControllerProvider(org.slug, widget.eventSlug);
    final state = ref.watch(provider);
    final title = state.value?.list.event.title ?? 'Attendees';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(
              '${Routes.orgScanLive}?event=${Uri.encodeComponent(widget.eventSlug)}',
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.onNavy),
            icon: const Icon(Icons.qr_code_scanner, size: 20),
            label: const Text('Scan'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.x4, Spacing.x3, Spacing.x4, Spacing.x2),
            child: TextField(
              controller: _query,
              onChanged: (_) => setState(() {}),
              autocorrect: false,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search name or email',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(_query.clear),
                      ),
                isDense: true,
              ),
            ),
          ),
          if (state.hasValue)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.x4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${state.requireValue.checkedInCount} of '
                      '${state.requireValue.attendees.length} checked in',
                      style: const TextStyle(color: AppColors.muted, fontSize: 13),
                    ),
                  ),
                  const SyncBadge(),
                ],
              ),
            ),
          if (state.value?.stale ?? false)
            Container(
              margin: const EdgeInsets.fromLTRB(Spacing.x4, Spacing.x2, Spacing.x4, 0),
              padding: const EdgeInsets.symmetric(horizontal: Spacing.x3, vertical: Spacing.x2),
              decoration: BoxDecoration(
                color: AppColors.warnBg,
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 16, color: AppColors.warn),
                  const SizedBox(width: Spacing.x2),
                  Expanded(
                    child: Text(
                      'Showing the saved list. Check-ins will sync when the server is reachable.',
                      style: const TextStyle(color: AppColors.warn, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(provider.notifier).refresh(),
              child: AsyncView(
                value: state,
                onRetry: () => ref.invalidate(provider),
                data: (data) {
                  final rows = data.filtered(_query.text);
                  if (rows.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: Spacing.x10),
                        EmptyState(
                          icon: Icons.people_outline,
                          title: _query.text.trim().isEmpty
                              ? 'No registrations yet.'
                              : 'No one matches that search.',
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: rows.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final a = rows[i];
                      return AttendeeRow(
                        attendee: a,
                        busy: data.busyIds.contains(a.id),
                        pending: data.pendingIds.contains(a.id),
                        zone: data.list.event.timezone,
                        onToggle: () async {
                          final error = await ref.read(provider.notifier).toggle(a);
                          if (error != null && context.mounted) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(content: Text(error)));
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
