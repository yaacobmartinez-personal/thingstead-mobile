import 'package:flutter/material.dart';

import '../../../../core/model/enums.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/ui/tiles.dart';
import '../domain/attendee.dart';

/// One attendee: initials avatar, name/email, status chip, "In at 6:04 PM",
/// and a presence check that morphs when toggled. The row flashes green on
/// check-in.
class AttendeeRow extends StatelessWidget {
  const AttendeeRow({
    super.key,
    required this.attendee,
    required this.busy,
    required this.onToggle,
    this.zone,
    this.onTap,
    this.onLongPress,
    this.pending = false,
  });

  final Attendee attendee;
  final bool busy;
  final VoidCallback onToggle;
  final String? zone;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// A queued check-in is waiting to sync for this row.
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final a = attendee;
    final statusChip = switch (a.status) {
      RegistrationStatus.waitlist => const StatusChip(
        'Waitlist',
        tone: ChipTone.warn,
      ),
      RegistrationStatus.cancelled => const StatusChip(
        'Cancelled',
        tone: ChipTone.danger,
      ),
      RegistrationStatus.confirmed => null,
    };

    return AnimatedContainer(
      duration: Motion.slow,
      curve: Motion.enter,
      decoration: BoxDecoration(
        color: a.checkedIn
            ? p.successBg.withValues(alpha: p.isDark ? 0.6 : 0.5)
            : p.surface,
        borderRadius: BorderRadius.circular(Radii.lg),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Radii.lg),
        child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.lg),
          ),
          leading: a.erased
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: p.surfaceTint,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_off_outlined,
                    size: 20,
                    color: p.faint,
                  ),
                )
              : InitialsAvatar(name: a.displayName, size: 40),
          title: Text(
            a.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.bodyStrong.copyWith(
              color: a.erased ? p.faint : p.ink,
              fontStyle: a.erased ? FontStyle.italic : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (a.email != null && !a.erased)
                Text(
                  a.email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.small.copyWith(color: p.muted),
                ),
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
                          style: AppType.caption.copyWith(color: p.success),
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
                Tooltip(
                  message: 'Waiting to sync',
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    size: 18,
                    color: p.warn,
                  ),
                ),
              if (busy)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else if (a.canCheckIn)
                _CheckToggle(checked: a.checkedIn, onTap: onToggle),
            ],
          ),
        ),
      ),
    );
  }
}

/// A round check that fills with the success color and pops.
class _CheckToggle extends StatelessWidget {
  const _CheckToggle({required this.checked, required this.onTap});

  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      checked: checked,
      label: checked ? 'Undo check-in' : 'Check in',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: AnimatedContainer(
            duration: Motion.base,
            curve: Motion.bounce,
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: checked ? p.success : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: checked ? p.success : p.faint,
                width: 1.8,
              ),
            ),
            child: AnimatedScale(
              scale: checked ? 1 : 0,
              duration: Motion.base,
              curve: Motion.bounce,
              child: const Icon(Icons.check, size: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
