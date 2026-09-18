import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/time/app_time.dart';
import '../application/sync_controller.dart';

/// A compact chip for the queue: pending count, spinner while syncing, red
/// when something needs attention, "Synced 2 min ago" when clean. Tapping
/// opens the attention list.
class SyncBadge extends ConsumerWidget {
  const SyncBadge({super.key, this.onDark = false});

  /// On a navy app bar the text is light.
  final bool onDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(syncControllerProvider);

    final (String label, Color fg, Color bg, IconData icon) = switch (s) {
      _ when s.attention > 0 => (
          '${s.attention} need attention',
          Colors.white,
          context.palette.danger,
          Icons.error_outline,
        ),
      _ when s.blocked == 'membership' => (
          'Sync blocked',
          Colors.white,
          context.palette.danger,
          Icons.block,
        ),
      _ when s.syncing => (
          'Syncing…',
          context.palette.ink,
          context.palette.lime,
          Icons.sync,
        ),
      _ when s.pending > 0 => (
          '${s.pending} pending',
          context.palette.ink,
          context.palette.lime,
          Icons.cloud_upload_outlined,
        ),
      _ when s.lastSyncedAt != null => (
          'Synced ${_ago(s.lastSyncedAt!)}',
          onDark ? Colors.white : context.palette.muted,
          onDark ? Colors.white12 : context.palette.surfaceTint,
          Icons.cloud_done_outlined,
        ),
      _ => ('', Colors.transparent, Colors.transparent, Icons.cloud_done_outlined),
    };
    if (label.isEmpty) return const SizedBox.shrink();

    return InkWell(
      borderRadius: BorderRadius.circular(Radii.pill),
      onTap: () => context.push(Routes.orgSyncAttention),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.x3, vertical: Spacing.x1),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Radii.pill)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (s.syncing && s.attention == 0)
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              )
            else
              Icon(icon, size: 14, color: fg),
            const SizedBox(width: Spacing.x1),
            Text(
              label,
              style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  static String _ago(DateTime at) {
    final d = DateTime.now().toUtc().difference(at.toUtc());
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes} min ago';
    if (d.inHours < 24) return '${d.inHours} h ago';
    return 'at ${AppTime.formatTime(at)}';
  }
}
