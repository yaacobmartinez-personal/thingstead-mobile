import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../orgs/application/selected_org_controller.dart';
import '../../orgs/presentation/org_picker_sheet.dart';
import '../application/team_controller.dart';
import '../domain/team.dart';
import 'invite_sheet.dart';

/// Organizer "Team" tab (ADMIN only): members with role changes and removal,
/// pending invitations with revoke, and an Invite action. Port of the web
/// team page including the last-admin rule.
class TeamScreen extends ConsumerStatefulWidget {
  const TeamScreen({super.key});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  bool _busy = false;

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } on ApiError catch (e) {
      _toast(e.message);
    } catch (_) {
      _toast('Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _invite(String org) async {
    final result = await showInviteSheet(
      context,
      onInvite: ({required email, required role}) =>
          ref.read(teamControllerProvider(org).notifier).invite(email: email, role: role),
    );
    if (result == null) return;
    _toast(result.alreadyMember
        ? 'Already a member of this organization.'
        : 'Invitation sent to ${result.invitation!.email}.');
  }

  Future<void> _changeRole(String org, TeamMember m, Role role) => _run(() async {
        await ref.read(teamControllerProvider(org).notifier).changeRole(m.id, role);
        _toast('${m.displayName} is now ${RoleCopy.label(role).toLowerCase()}.');
      });

  Future<void> _remove(String org, TeamMember m) async {
    final ok = await confirmDialog(
      context,
      title: m.isSelf ? 'Leave this organization?' : 'Remove ${m.displayName}?',
      message: m.isSelf
          ? "You'll lose access to its events and attendees until someone invites you back."
          : "They'll lose access to this organization's events and attendees right away.",
      confirmLabel: m.isSelf ? 'Leave' : 'Remove',
      destructive: true,
    );
    if (!ok || !mounted) return;
    await _run(() async {
      await ref.read(teamControllerProvider(org).notifier).remove(m.id, self: m.isSelf);
      _toast(m.isSelf ? 'You left the organization.' : '${m.displayName} was removed.');
    });
  }

  Future<void> _revoke(String org, TeamInvitation i) => _run(() async {
        await ref.read(teamControllerProvider(org).notifier).revoke(i.id);
        _toast('Invitation to ${i.email} revoked.');
      });

  @override
  Widget build(BuildContext context) {
    final org = ref.watch(selectedOrgProvider);
    final available = isAvailable(Feature.team, ref.watch(apiModeProvider));

    if (org == null || !org.isAdmin || !available) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Team'),
          actions: const [OrgSwitcherButton()],
        ),
        body: EmptyState(
          icon: Icons.group_outlined,
          title: org == null
              ? 'No organization'
              : !available
                  ? 'Team management is on the web for now'
                  : 'Admins only',
          hint: org == null
              ? 'Create one on the web, or ask an admin to invite you.'
              : !available
                  ? 'Invite and manage teammates from the dashboard until this '
                      'server supports it in the app.'
                  : 'Only admins of ${org.name} can manage its team.',
        ),
      );
    }

    final provider = teamControllerProvider(org.slug);
    final team = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team'),
        actions: const [OrgSwitcherButton()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy ? null : () => _invite(org.slug),
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Invite'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(provider.future),
        child: AsyncView(
          value: team,
          onRetry: () => ref.invalidate(provider),
          data: (page) => ListView(
            padding: const EdgeInsets.fromLTRB(Spacing.x4, Spacing.x4, Spacing.x4, 96),
            children: [
              _Heading('Members (${page.members.length})'),
              for (final m in page.members)
                _MemberTile(
                  member: m,
                  page: page,
                  busy: _busy,
                  onChangeRole: (role) => _changeRole(org.slug, m, role),
                  onRemove: () => _remove(org.slug, m),
                ),
              const SizedBox(height: Spacing.x4),
              _Heading('Pending invitations (${page.invitations.length})'),
              if (page.invitations.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Spacing.x2),
                  child: Text(
                    'No one is waiting to join.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              for (final i in page.invitations)
                _InvitationTile(
                  invitation: i,
                  busy: _busy,
                  onRevoke: () => _revoke(org.slug, i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: Spacing.x2),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.faint,
            letterSpacing: 0.6,
          ),
        ),
      );
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.page,
    required this.busy,
    required this.onChangeRole,
    required this.onRemove,
  });

  final TeamMember member;
  final TeamPage page;
  final bool busy;
  final ValueChanged<Role> onChangeRole;
  final VoidCallback onRemove;

  static const lastAdminHint = 'This is the only admin. Make someone else an admin first.';

  @override
  Widget build(BuildContext context) {
    final m = member;
    final canReduce = page.canReduceAdmin(m);
    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.x2),
      child: ListTile(
        title: Row(
          children: [
            Flexible(
              child: Text(
                m.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (m.isSelf)
              const Padding(
                padding: EdgeInsets.only(left: Spacing.x2),
                child: Text('(you)', style: TextStyle(color: AppColors.muted)),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((m.name ?? '').trim().isNotEmpty)
              Text(m.email, maxLines: 1, overflow: TextOverflow.ellipsis),
            Padding(
              padding: const EdgeInsets.only(top: Spacing.x1),
              child: StatusChip(
                RoleCopy.label(m.role),
                tone: m.isAdmin ? ChipTone.navy : ChipTone.muted,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          enabled: !busy,
          tooltip: 'Member actions',
          onSelected: (value) {
            switch (value) {
              case 'admin':
                onChangeRole(Role.admin);
              case 'staff':
                onChangeRole(Role.staff);
              case 'remove':
                onRemove();
            }
          },
          itemBuilder: (context) => [
            if (!m.isAdmin)
              const PopupMenuItem(value: 'admin', child: Text('Make admin')),
            if (m.isAdmin)
              PopupMenuItem(
                value: 'staff',
                enabled: canReduce,
                child: _MenuLabel('Make staff', hint: canReduce ? null : lastAdminHint),
              ),
            PopupMenuItem(
              value: 'remove',
              enabled: canReduce,
              child: _MenuLabel(
                m.isSelf ? 'Leave organization' : 'Remove',
                danger: true,
                hint: canReduce ? null : lastAdminHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuLabel extends StatelessWidget {
  const _MenuLabel(this.text, {this.hint, this.danger = false});

  final String text;
  final String? hint;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final enabled = hint == null;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: enabled ? 0 : Spacing.x2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(color: danger && enabled ? AppColors.danger : null),
          ),
          if (hint != null)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.x1),
              child: Text(
                hint!,
                style: const TextStyle(fontSize: 11, color: AppColors.faint, height: 1.3),
              ),
            ),
        ],
      ),
    );
  }
}

class _InvitationTile extends StatelessWidget {
  const _InvitationTile({
    required this.invitation,
    required this.busy,
    required this.onRevoke,
  });

  final TeamInvitation invitation;
  final bool busy;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final i = invitation;
    final when = DateFormat('d MMM').format(i.expiresAt.toLocal());
    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.x2),
      child: ListTile(
        title: Text(i.email, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Wrap(
          spacing: Spacing.x2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            StatusChip(RoleCopy.label(i.role), tone: ChipTone.muted),
            Text(
              i.expired ? 'Expired $when' : 'Expires $when',
              style: TextStyle(
                fontSize: 12,
                color: i.expired ? AppColors.danger : AppColors.muted,
              ),
            ),
          ],
        ),
        trailing: TextButton(
          onPressed: busy ? null : onRevoke,
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          child: const Text('Revoke'),
        ),
      ),
    );
  }
}
