import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/widgets/empty_state.dart';
import '../application/sync_controller.dart';
import '../data/checkin_queue.dart';
import '../domain/pending_op.dart';
import '../domain/sync_status.dart';

/// Queued check-ins the server refused, plus a summary of what is still
/// waiting. Staff can retry, dismiss, or jump to the person.
class NeedsAttentionScreen extends ConsumerWidget {
  const NeedsAttentionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncControllerProvider);
    final ops = ref.watch(attentionOpsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync'),
        actions: [
          IconButton(
            tooltip: 'Sync now',
            icon: const Icon(Icons.sync),
            onPressed: status.syncing
                ? null
                : () => ref.read(syncControllerProvider.notifier).kick(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.x4),
        children: [
          _StatusCard(status: status),
          const SizedBox(height: Spacing.x4),
          const Text(
            'Needs attention',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: Spacing.x2),
          ...ops.when(
            loading: () => const [Center(child: CircularProgressIndicator())],
            error: (e, _) => [Text('$e')],
            data: (items) => items.isEmpty
                ? const [
                    EmptyState(
                      icon: Icons.check_circle_outline,
                      title: 'Nothing to look at',
                      hint: 'Check-ins the server refused will show up here.',
                    ),
                  ]
                : [for (final op in items) _AttentionTile(op: op)],
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final lines = <String>[
      if (status.syncing) 'Syncing now…',
      if (status.pending > 0)
        '${status.pending} check-in${status.pending == 1 ? '' : 's'} waiting to sync.',
      if (status.blocked == 'membership')
        'Sync is blocked: you no longer have access to this organization.',
      if (status.blocked == 'signedOut') 'Sign in again to finish syncing.',
      if (status.lastSyncedAt != null)
        'Last synced at ${AppTime.formatTime(status.lastSyncedAt!)}.',
      if (status.isClean && status.lastSyncedAt == null) 'Everything is up to date.',
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final l in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.x1),
                child: Text(l, style: TextStyle(color: context.palette.muted)),
              ),
          ],
        ),
      ),
    );
  }
}

class _AttentionTile extends ConsumerWidget {
  const _AttentionTile({required this.op});

  final PendingOp op;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.read(checkinQueueProvider);
    final title = op.attendeeName ??
        (op.kind == PendingKind.scan ? 'Scanned ticket' : 'Manual check-in');
    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.x2),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  op.kind == PendingKind.scan ? Icons.qr_code : Icons.touch_app_outlined,
                  size: 18,
                  color: context.palette.danger,
                ),
                const SizedBox(width: Spacing.x2),
                Expanded(
                  child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Text(
                  AppTime.formatTime(op.clientAt),
                  style: TextStyle(color: context.palette.faint, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: Spacing.x1),
            Text(op.whatHappened, style: TextStyle(color: context.palette.muted)),
            if (op.code != null && op.attendeeName == null) ...[
              const SizedBox(height: Spacing.x1),
              Text(
                op.code!,
                style: TextStyle(color: context.palette.faint, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: Spacing.x2),
            Row(
              children: [
                if (op.event != null && op.registrationId != null)
                  TextButton(
                    onPressed: () => context.push(Routes.orgEventAttendees(op.event!)),
                    child: const Text('Open attendees'),
                  ),
                TextButton(
                  onPressed: () => queue.retry(op.id),
                  child: const Text('Retry'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => queue.dismiss(op.id),
                  style: TextButton.styleFrom(foregroundColor: context.palette.danger),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
