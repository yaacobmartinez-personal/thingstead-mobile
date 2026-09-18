import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/stagger.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/presentation/widgets/session_tiles.dart';
import '../../../settings/presentation/appearance_tile.dart';
import '../../../shell/application/app_mode_controller.dart';
import '../../../shell/presentation/mode_switch_tile.dart';

/// Attendee "Account" tab. Public: signed out it invites sign-in; signed in
/// it shows the profile, the organizer switch when eligible, appearance, and
/// the session/server controls shared with organizer Settings.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Spacing.gutter, Spacing.x2, Spacing.gutter, Spacing.x8),
        children: [
          StaggeredColumn(
            children: [
              if (!auth.isSignedIn)
                const SignInPromptCard(
                  message: 'Keep your tickets on this phone and register for '
                      'events in a tap.',
                )
              else ...[
                const SignedInCard(),
                if (auth.hasOrganizerAccess) ...[
                  const SizedBox(height: Spacing.x4),
                  const Card(child: ModeSwitchTile(target: AppMode.organizer)),
                ],
              ],
              const SizedBox(height: Spacing.x4),
              const AppearanceCard(),
              const SizedBox(height: Spacing.x4),
              Card(
                child: Column(
                  children: [
                    const ServerAddressTile(),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.auto_awesome_outlined),
                      title: const Text('Show the intro again'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(Routes.onboarding),
                    ),
                    if (auth.isSignedIn) ...[const Divider(), const SignOutTile()],
                  ],
                ),
              ),
              if (auth.isSignedIn) ...[
                const SizedBox(height: Spacing.x4),
                const DeleteAccountCard(),
              ],
              const BuildFooter(),
            ],
          ),
        ],
      ),
    );
  }
}
