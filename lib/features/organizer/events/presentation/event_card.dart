import 'package:flutter/material.dart';

import '../../../../core/model/enums.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/ui/stats.dart';
import '../domain/event_summary.dart';

/// Organizer event card: date tile, title + status, confirmed count, a
/// check-in progress ring, and a "Scan" pill.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onScan,
  });

  final EventSummary event;
  final VoidCallback onTap;
  final VoidCallback onScan;

  static (String, ChipTone) statusChip(EventStatus s) => switch (s) {
        EventStatus.published => ('Published', ChipTone.success),
        EventStatus.closed => ('Closed', ChipTone.muted),
        EventStatus.draft => ('Draft', ChipTone.warn),
      };

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final (label, tone) = statusChip(event.status);
    final (month, day, weekday, time) = AppTime.dateParts(event.startsAt, event.endsAt, event.timezone);
    final ratio = event.confirmed == 0 ? 0.0 : event.checkedIn / event.confirmed;
    return Material(
      color: p.surface,
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
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
                        Text(month.toUpperCase(),
                            style: AppType.caption.copyWith(color: p.muted, fontSize: 10)),
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
                        const SizedBox(height: Spacing.x2),
                        StatusChip(label, tone: tone),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.x4),
              Row(
                children: [
                  ProgressRing(
                    value: ratio,
                    size: 44,
                    child: Text(
                      '${(ratio * 100).round()}%',
                      style: AppType.caption.copyWith(color: p.ink, fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: Spacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${event.checkedIn} of ${event.confirmed} checked in',
                          style: AppType.bodyStrong.copyWith(color: p.ink, fontSize: 14),
                        ),
                        Text(
                          event.capacity == null
                              ? '${event.confirmed} confirmed · no cap'
                              : '${event.headcount} confirmed',
                          style: AppType.small.copyWith(color: p.muted),
                        ),
                      ],
                    ),
                  ),
                  PillButton(
                    label: 'Scan',
                    icon: Icons.qr_code_scanner,
                    compact: true,
                    expanded: false,
                    onPressed: onScan,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
