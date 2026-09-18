import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/ui/celebration.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/ui/stagger.dart';
import '../../../../core/ui/tiles.dart';
import '../../events/application/event_detail_controller.dart';
import '../../events/domain/event_detail.dart';
import '../../events/presentation/event_card.dart';
import '../../orgs/application/selected_org_controller.dart';

/// The end of organizer setup: a small celebration, the first event (when
/// one was created), and the three things to do next.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key, this.eventSlug});

  final String? eventSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final org = ref.watch(selectedOrgProvider);
    final slug = eventSlug;
    final event = org == null || slug == null
        ? const AsyncValue<EventDetail?>.data(null)
        : ref.watch(eventDetailProvider(org.slug, slug));

    return Scaffold(
      backgroundColor: p.sage,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Spacing.gutter, Spacing.x10, Spacing.gutter, Spacing.x8),
          children: [
            StaggeredColumn(
              children: [
                const Center(child: Celebration(size: 112)),
                const SizedBox(height: Spacing.x6),
                Text(
                  org == null ? "You're set up" : '${org.name} is ready',
                  textAlign: TextAlign.center,
                  style: AppType.display.copyWith(color: p.ink),
                ),
                const SizedBox(height: Spacing.x2),
                Text(
                  slug == null
                      ? 'Create an event whenever you like — it starts as a draft.'
                      : 'Your first event is saved as a draft. Publish it when '
                          "you're ready to take registrations.",
                  textAlign: TextAlign.center,
                  style: AppType.body.copyWith(color: p.muted),
                ),
                if (event.value case final e?) ...[
                  const SizedBox(height: Spacing.x6),
                  _EventSummary(event: e),
                ],
                const SizedBox(height: Spacing.x6),
                Container(
                  padding: const EdgeInsets.all(Spacing.gutter),
                  decoration: BoxDecoration(
                    color: p.surface,
                    borderRadius: BorderRadius.circular(Radii.card),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel('What happens next'),
                      const SizedBox(height: Spacing.x3),
                      const _Tip(
                        icon: Icons.rocket_launch_outlined,
                        title: 'Publish when ready',
                        body: 'Open the event and tap Publish. Its page goes live at your address.',
                      ),
                      const _Tip(
                        icon: Icons.ios_share,
                        title: 'Share the link',
                        body: 'People register from the event page; they get a QR ticket by email and in this app.',
                      ),
                      _Tip(
                        icon: Icons.qr_code_scanner,
                        title: 'Scan at the door',
                        body: 'The Scan tab checks tickets in, even offline. Invite helpers from Team.',
                        last: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.x6),
                if (slug != null) ...[
                  PillButton(
                    label: 'Open the event',
                    icon: Icons.arrow_forward,
                    trailingIcon: true,
                    onPressed: () => context.go(Routes.orgEvent(slug)),
                  ),
                  const SizedBox(height: Spacing.x3),
                  PillButton(
                    label: 'Go to my events',
                    variant: PillVariant.ghost,
                    onPressed: () => context.go(Routes.orgEvents),
                  ),
                ] else
                  PillButton(
                    label: 'Go to my events',
                    icon: Icons.arrow_forward,
                    trailingIcon: true,
                    onPressed: () => context.go(Routes.orgEvents),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EventSummary extends StatelessWidget {
  const _EventSummary({required this.event});

  final EventDetail event;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = EventCard.statusChip(event.status);
    final (month, day, weekday, time) = AppTime.dateParts(event.startsAt, event.endsAt, event.timezone);
    return DateTile(
      month: month,
      day: day,
      weekday: event.title,
      time: '$weekday · $time',
      trailing: Padding(
        padding: const EdgeInsets.only(left: Spacing.x2),
        child: StatusChip(label, tone: tone),
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({
    required this.icon,
    required this.title,
    required this.body,
    this.last = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : Spacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: p.lime, borderRadius: BorderRadius.circular(Radii.md)),
            child: Icon(icon, size: 20, color: p.onLime),
          ),
          const SizedBox(width: Spacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppType.bodyStrong.copyWith(color: p.ink)),
                const SizedBox(height: 2),
                Text(body, style: AppType.small.copyWith(color: p.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
