import 'package:flutter/material.dart';

import '../../../../core/model/enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/time/app_time.dart';
import '../domain/event_summary.dart';

/// Port of the Expo EventsScreen card: title + status, date in the event's
/// zone, Confirmed x/cap, Checked in, and a "Scan check-in" button.
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
    final (label, tone) = statusChip(event.status);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: Spacing.x3),
                  StatusChip(label, tone: tone),
                ],
              ),
              const SizedBox(height: Spacing.x2),
              Text(
                AppTime.formatEventDate(event.startsAt, event.timezone),
                style: const TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: Spacing.x3),
              Row(
                children: [
                  _Stat(label: 'Confirmed', value: event.headcount),
                  const SizedBox(width: Spacing.x6),
                  _Stat(label: 'Checked in', value: '${event.checkedIn}', accent: true),
                ],
              ),
              const SizedBox(height: Spacing.x3),
              FilledButton.icon(
                onPressed: onScan,
                icon: const Icon(Icons.qr_code_scanner, size: 20),
                label: const Text('Scan check-in'),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(44)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.accent = false});

  final String label;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: accent ? AppColors.success : AppColors.navy,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.faint,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
