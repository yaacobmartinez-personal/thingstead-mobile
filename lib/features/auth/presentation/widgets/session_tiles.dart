import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/network/server_url.dart';
import '../../../../core/router/guards.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../organizer/checkin/application/sync_controller.dart';
import '../../../organizer/settings/presentation/delete_account_dialog.dart';
import '../../application/auth_controller.dart';
import '../../application/auth_state.dart';

/// Pieces shared by the attendee Account tab and the organizer Settings tab:
/// who is signed in, session expiry, server address, sign out, delete.

/// Name + email, with an inline "edit name" when the endpoint exists.
class SignedInCard extends ConsumerWidget {
  const SignedInCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final user = auth.user;
    if (user == null) return const SizedBox.shrink();
    final canEdit = isAvailable(Feature.attendeeMode, ref.watch(apiModeProvider));
    final daysLeft = ref.watch(sessionDaysLeftProvider);

    return SectionCard(
      heading: 'Signed in',
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.navy,
              foregroundColor: AppColors.onNavy,
              child: Text(user.displayName.substring(0, 1).toUpperCase()),
            ),
            const SizedBox(width: Spacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Text(user.email, style: const TextStyle(color: AppColors.muted)),
                ],
              ),
            ),
            if (canEdit)
              IconButton(
                tooltip: 'Edit name',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _editName(context, ref, user.name ?? ''),
              ),
          ],
        ),
        if (daysLeft != null && daysLeft < 5) ...[
          const SizedBox(height: Spacing.x3),
          Text(
            daysLeft <= 0
                ? 'Your session expires today. Sign in again to extend it.'
                : 'Your session expires in $daysLeft day${daysLeft == 1 ? '' : 's'}. '
                    'Sign in again to extend it.',
            style: const TextStyle(color: AppColors.warn, fontSize: 13),
          ),
        ],
      ],
    );
  }

  Future<void> _editName(BuildContext context, WidgetRef ref, String current) async {
    final controller = TextEditingController(text: current);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || !context.mounted) return;
    try {
      await ref.read(authControllerProvider.notifier).updateName(name);
    } on ApiError catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.fieldErrors['name'] ?? e.message)),
      );
    }
  }
}

/// Where the app points. Shown signed in or out.
class ServerAddressTile extends ConsumerWidget {
  const ServerAddressTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final host = ref.watch(serverUrlProvider.notifier).host;
    return ListTile(
      leading: const Icon(Icons.dns_outlined),
      title: const Text('Server address'),
      subtitle: Text(host),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(Routes.serverAddress),
    );
  }
}

class SignOutTile extends ConsumerWidget {
  const SignOutTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Sign out'),
      onTap: () async {
        // Queued check-ins die with a deliberate sign-out; say so first.
        final pending = ref.read(syncControllerProvider).pending;
        if (pending > 0) {
          final ok = await confirmDialog(
            context,
            title: 'Unsynced check-ins',
            message: 'You have $pending check-in${pending == 1 ? '' : 's'} that '
                "haven't reached the server yet. Signing out discards them. "
                'Sign out anyway?',
            confirmLabel: 'Sign out anyway',
            destructive: true,
          );
          if (!ok) return;
        }
        await ref.read(authControllerProvider.notifier).signOut();
      },
    );
  }
}

class DeleteAccountCard extends ConsumerWidget {
  const DeleteAccountCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      heading: 'Delete account',
      headingColor: AppColors.danger,
      borderColor: AppColors.danger,
      body: 'Permanently delete your Thingstead account. Your name and email '
          "are removed and you're taken off every organization. This can't be "
          'undone.',
      children: [
        OutlinedButton(
          onPressed: () => runDeleteAccount(context, ref),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.danger,
            side: const BorderSide(color: AppColors.danger),
          ),
          child: const Text('Delete account'),
        ),
      ],
    );
  }
}

/// Shown on the Account tab when signed out.
class SignInPromptCard extends ConsumerWidget {
  const SignInPromptCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reason = ref.watch(
      authControllerProvider.select((s) => s is SignedOut ? s.reason : null),
    );
    final canSignUp = isAvailable(Feature.signup, ref.watch(apiModeProvider));
    final notice = switch (reason) {
      SignOutReason.sessionExpired => 'Your session expired. Sign in again.',
      SignOutReason.serverChanged => 'Server changed. Sign in again.',
      SignOutReason.accountDeleted => 'Your account has been deleted.',
      _ => null,
    };

    return SectionCard(
      heading: 'Sign in',
      body: message,
      children: [
        if (notice != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.x3),
            child: Text(notice, style: const TextStyle(color: AppColors.warn)),
          ),
        FilledButton(
          onPressed: () => context.push(loginFor(GoRouterState.of(context).uri)),
          child: const Text('Sign in'),
        ),
        if (canSignUp) ...[
          const SizedBox(height: Spacing.x2),
          OutlinedButton(
            onPressed: () => context.push(Routes.signup),
            child: const Text('Create an account'),
          ),
        ],
      ],
    );
  }
}

/// Version + API mode, at the bottom of settings screens.
class BuildFooter extends ConsumerWidget {
  const BuildFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(apiModeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.x4),
      child: Text(
        '${AppConfig.appName} ${AppConfig.appVersion}'
        '${mode == ApiMode.fake ? ' · fake data' : ''}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.faint, fontSize: 12),
      ),
    );
  }
}
