import 'package:flutter/material.dart';

import '../../../../core/model/enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/time/app_time.dart';
import '../domain/attendee.dart';

/// Port of the Expo AttendeeRow: name/email, status chip, "In at 6:04 PM",
/// and a presence toggle for confirmed, non-erased people.
class AttendeeRow extends StatelessWidget {
  const AttendeeRow({
    super.key,
    required this.attendee,
    required this.busy,
    required this.onToggle,
    this.zone,
    this.onLongPress,
    this.pending = false,
  });

  final Attendee attendee;
  final bool busy;
  final VoidCallback onToggle;
  final String? zone;
  final VoidCallback? onLongPress;

  /// A queued check-in is waiting to sync for this row.
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final a = attendee;
    final statusChip = switch (a.status) {
      RegistrationStatus.waitlist => const StatusChip('Waitlist', tone: ChipTone.warn),
      RegistrationStatus.cancelled => const StatusChip('Cancelled', tone: ChipTone.danger),
      RegistrationStatus.confirmed => null,
    };

    return ListTile(
      onLongPress: onLongPress,
      title: Text(
        a.displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: a.erased ? AppColors.faint : AppColors.text,
          fontStyle: a.erased ? FontStyle.italic : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (a.email != null && !a.erased)
            Text(a.email!, maxLines: 1, overflow: TextOverflow.ellipsis),
          if (statusChip != null || a.checkedIn)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.x1),
              child: Wrap(
                spacing: Spacing.x2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ?statusChip,
                  if (a.checkedIn)
                    Text(
                      'In at ${AppTime.formatTime(a.checkedInAt!, zone)}',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pending)
            const Tooltip(
              message: 'Waiting to sync',
              child: Icon(Icons.cloud_upload_outlined, size: 18, color: AppColors.warn),
            ),
          if (busy)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (a.canCheckIn)
            Checkbox(
              value: a.checkedIn,
              activeColor: AppColors.success,
              onChanged: (_) => onToggle(),
            ),
        ],
      ),
    );
  }
}
