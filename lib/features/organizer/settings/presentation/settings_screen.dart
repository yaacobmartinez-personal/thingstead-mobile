import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/model/enums.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../auth/presentation/widgets/session_tiles.dart';
import '../../../settings/presentation/appearance_tile.dart';
import '../../../shell/application/app_mode_controller.dart';
import '../../../shell/presentation/mode_switch_tile.dart';
import '../../orgs/application/selected_org_controller.dart';

/// Organizer "Settings" tab: who, which org, switch to attendee, server,
/// sign out, delete.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = ref.watch(selectedOrgProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Spacing.gutter, Spacing.x2, Spacing.gutter, Spacing.x8),
        children: [
          const SignedInCard(),
          if (org != null) ...[
            const SizedBox(height: Spacing.x4),
            SectionCard(
              heading: 'Organization',
              children: [
                Text(
                  org.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: Spacing.x1),
                Text(
                  'thingstead.pro/${org.slug}',
                  style: TextStyle(color: context.palette.muted),
                ),
                const SizedBox(height: Spacing.x3),
                Wrap(
                  spacing: Spacing.x2,
                  children: [
                    StatusChip(
                      org.isAdmin ? 'Admin' : 'Staff',
                      tone: org.isAdmin ? ChipTone.lime : ChipTone.muted,
                    ),
                    StatusChip(
                      switch (org.plan) {
                        PlanTier.free => 'Free plan',
                        PlanTier.premium => 'Premium',
                        PlanTier.custom => 'Custom plan',
                      },
                      tone: org.plan == PlanTier.free ? ChipTone.muted : ChipTone.warn,
                    ),
                  ],
                ),
              ],
            ),
          ],
          const SizedBox(height: Spacing.x4),
          const Card(child: ModeSwitchTile(target: AppMode.attendee)),
          const SizedBox(height: Spacing.x4),
          const AppearanceCard(),
          const SizedBox(height: Spacing.x4),
          const Card(
            child: Column(
              children: [ServerAddressTile(), Divider(), SignOutTile()],
            ),
          ),
          const SizedBox(height: Spacing.x4),
          const DeleteAccountCard(),
          const BuildFooter(),
        ],
      ),
    );
  }
}
