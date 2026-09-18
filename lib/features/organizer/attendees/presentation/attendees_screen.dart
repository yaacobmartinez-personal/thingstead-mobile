import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/ui/round_icon_button.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../checkin/presentation/sync_badge.dart';
import '../../orgs/application/selected_org_controller.dart';
import '../application/attendee_actions.dart';
import '../application/attendees_controller.dart';
import 'attendee_actions_sheet.dart';
import 'attendee_row.dart';

/// Port of the Expo AttendeesScreen: search, list, optimistic check-in
/// toggle, and a Scan action in the app bar, plus the web's per-row actions
/// (tap a row) and CSV export. Search is local over the full list (the
/// server caps at 500 rows).
class AttendeesScreen extends ConsumerStatefulWidget {
  const AttendeesScreen({super.key, required this.eventSlug});

  final String eventSlug;

  @override
  ConsumerState<AttendeesScreen> createState() => _AttendeesScreenState();
}

class _AttendeesScreenState extends ConsumerState<AttendeesScreen> {
  final _query = TextEditingController();
  bool _exporting = false;

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _export(String org) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      await ref.read(attendeeActionsProvider.notifier).export(org, widget.eventSlug);
    } on ApiError catch (e) {
      _toast(e.message);
    } catch (_) {
      _toast("Couldn't export the list. Try again.");
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

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
    final canExport = isAvailable(Feature.csvExport, ref.watch(apiModeProvider));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (canExport)
            RoundIconButton(
              icon: _exporting ? Icons.hourglass_top : Icons.download_outlined,
              tooltip: 'Export CSV',
              onPressed: _exporting || !state.hasValue ? null : () => _export(org.slug),
            ),
          const SizedBox(width: Spacing.x2),
          Padding(
            padding: const EdgeInsets.only(right: Spacing.gutter),
            child: RoundIconButton(
              icon: Icons.qr_code_scanner,
              tooltip: 'Scan',
              dark: true,
              onPressed: () => context.push(
                '${Routes.orgScanLive}?event=${Uri.encodeComponent(widget.eventSlug)}',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.gutter, Spacing.x2, Spacing.gutter, Spacing.x2),
            child: TextField(
              controller: _query,
              onChanged: (_) => setState(() {}),
              autocorrect: false,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search name or email',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: context.palette.surface,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(999)),
                  borderSide: BorderSide(color: context.palette.limeDeep, width: 2),
                ),
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
              padding: const EdgeInsets.symmetric(horizontal: Spacing.gutter),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${state.requireValue.checkedInCount} of '
                      '${state.requireValue.attendees.length} checked in',
                      style: AppType.small.copyWith(color: context.palette.muted),
                    ),
                  ),
                  const SyncBadge(),
                ],
              ),
            ),
          if (state.value?.stale ?? false)
            Container(
              margin: const EdgeInsets.fromLTRB(Spacing.gutter, Spacing.x2, Spacing.gutter, 0),
              padding: const EdgeInsets.symmetric(horizontal: Spacing.x3, vertical: Spacing.x2),
              decoration: BoxDecoration(
                color: context.palette.warnBg,
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: Row(
                children: [
                  Icon(Icons.cloud_off_outlined, size: 16, color: context.palette.warn),
                  const SizedBox(width: Spacing.x2),
                  Expanded(
                    child: Text(
                      'Showing the saved list. Check-ins will sync when the server is reachable.',
                      style: AppType.small.copyWith(color: context.palette.warn, fontWeight: FontWeight.w600),
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
                    padding: const EdgeInsets.fromLTRB(Spacing.gutter, Spacing.x2, Spacing.gutter, Spacing.x8),
                    itemCount: rows.length,
                    separatorBuilder: (_, _) => const SizedBox(height: Spacing.x2),
                    itemBuilder: (context, i) {
                      final a = rows[i];
                      return AttendeeRow(
                        attendee: a,
                        busy: data.busyIds.contains(a.id),
                        pending: data.pendingIds.contains(a.id),
                        zone: data.list.event.timezone,
                        onTap: () => showAttendeeActions(
                          context,
                          ref,
                          org: org.slug,
                          event: widget.eventSlug,
                          attendee: a,
                        ),
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
