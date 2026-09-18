import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../events/domain/event_detail.dart';
import '../application/attendee_actions.dart';
import '../domain/attendee.dart';

/// Per-attendee actions (promote from the waitlist, copy email, erase
/// personal data). Opens from a row tap; returns a message to show, if any.
Future<void> showAttendeeActions(
  BuildContext context,
  WidgetRef ref, {
  required String org,
  required String event,
  required Attendee attendee,
}) async {
  final mode = ref.read(apiModeProvider);
  final canManage = isAvailable(Feature.promoteErase, mode);
  final action = await showModalBottomSheet<_Action>(
    context: context,
    useSafeArea: true,
    builder: (context) => _ActionsSheet(attendee: attendee, canManage: canManage),
  );
  if (action == null || !context.mounted) return;

  void toast(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  final actions = ref.read(attendeeActionsProvider.notifier);
  try {
    switch (action) {
      case _Action.copyEmail:
        await Clipboard.setData(ClipboardData(text: attendee.email ?? ''));
        toast('Email copied.');
      case _Action.promote:
        final outcome = await actions.promote(org, event, attendee.id);
        toast(switch (outcome) {
          PromoteOutcome.promoted => '${attendee.displayName} now has a place.',
          PromoteOutcome.full => 'Event is full.',
          PromoteOutcome.gone => 'No longer waitlisted.',
        });
      case _Action.erase:
        final ok = await confirmDialog(
          context,
          title: 'Erase details?',
          message: "${attendee.displayName}'s name, email, and check-in will be "
              'permanently removed. The registration stays counted. This cannot be undone.',
          confirmLabel: 'Erase details',
          destructive: true,
        );
        if (!ok) return;
        await actions.erase(org, event, attendee.id);
        toast('Details erased.');
    }
  } on ApiError catch (e) {
    toast(e.message);
  } catch (_) {
    toast('Something went wrong. Try again.');
  }
}

enum _Action { copyEmail, promote, erase }

class _ActionsSheet extends StatelessWidget {
  const _ActionsSheet({required this.attendee, required this.canManage});

  final Attendee attendee;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    final a = attendee;
    final canPromote = canManage && a.status == RegistrationStatus.waitlist && !a.erased;
    final canErase = canManage && !a.erased;
    final canCopy = !a.erased && (a.email ?? '').isNotEmpty;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.x4, Spacing.x4, Spacing.x4, Spacing.x2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  a.displayName,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                if (canCopy)
                  Text(a.email!, style: TextStyle(color: context.palette.muted)),
              ],
            ),
          ),
          if (canPromote)
            ListTile(
              leading: Icon(Icons.arrow_upward, color: context.palette.success),
              title: const Text('Promote to confirmed'),
              subtitle: const Text('Give this person a place from the waitlist.'),
              onTap: () => Navigator.of(context).pop(_Action.promote),
            ),
          if (canCopy)
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('Copy email'),
              onTap: () => Navigator.of(context).pop(_Action.copyEmail),
            ),
          if (canErase)
            ListTile(
              leading: Icon(Icons.delete_forever_outlined, color: context.palette.danger),
              title: Text('Erase details', style: TextStyle(color: context.palette.danger)),
              subtitle: const Text('Remove their personal data for good.'),
              onTap: () => Navigator.of(context).pop(_Action.erase),
            ),
          if (!canPromote && !canCopy && !canErase)
            Padding(
              padding: EdgeInsets.all(Spacing.x4),
              child: Text(
                'Nothing to do for this registration.',
                style: TextStyle(color: context.palette.muted),
              ),
            ),
          const SizedBox(height: Spacing.x2),
        ],
      ),
    );
  }
}
