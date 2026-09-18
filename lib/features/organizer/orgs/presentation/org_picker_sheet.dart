import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/model/enums.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/status_chip.dart';
import '../../../../core/ui/round_icon_button.dart';
import '../../../../core/ui/tiles.dart';
import '../../../auth/application/auth_controller.dart';
import '../application/selected_org_controller.dart';
import '../domain/org.dart';

/// The org list with role/plan chips — port of the Expo OrgsScreen rows.
/// Used both as a bottom sheet (switcher) and as the full-screen picker.
class OrgList extends ConsumerWidget {
  const OrgList({super.key, this.onPicked});

  final void Function(Org org)? onPicked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgs = ref.watch(authControllerProvider.select((s) => s.orgs));
    final selected = ref.watch(selectedOrgProvider);

    if (orgs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Spacing.x6),
        child: Text(
          'No organizations yet. Create one on the web, or ask an admin to invite you.',
          textAlign: TextAlign.center,
          style: TextStyle(color: context.palette.muted),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: Spacing.x2),
      itemCount: orgs.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final org = orgs[i];
        final isCurrent = org.slug == selected?.slug;
        return ListTile(
          leading: InitialsAvatar(name: org.name, size: 40),
          title: Text(org.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: Spacing.x1),
            child: Wrap(
              spacing: Spacing.x2,
              children: [
                StatusChip(
                  org.isAdmin ? 'Admin' : 'Staff',
                  tone: org.isAdmin ? ChipTone.lime : ChipTone.muted,
                ),
                if (org.plan != PlanTier.free)
                  StatusChip(
                    org.plan == PlanTier.premium ? 'Premium' : 'Custom',
                    tone: ChipTone.warn,
                  ),
              ],
            ),
          ),
          trailing: isCurrent ? Icon(Icons.check_circle, color: context.palette.limeDeep) : null,
          onTap: () {
            ref.read(selectedOrgSlugProvider.notifier).set(org.slug);
            onPicked?.call(org);
          },
        );
      },
    );
  }
}

/// Opens the switcher sheet.
Future<void> showOrgSwitcher(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.x4),
              child: Text(
                'Switch organization',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            Flexible(child: OrgList(onPicked: (_) => Navigator.of(context).pop())),
          ],
        ),
      ),
    );

/// App-bar action showing the current org's initial; taps open the switcher.
class OrgSwitcherButton extends ConsumerWidget {
  const OrgSwitcherButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgs = ref.watch(authControllerProvider.select((s) => s.orgs));
    if (orgs.length < 2) return const SizedBox.shrink();
    return RoundIconButton(
      icon: Icons.swap_horiz,
      tooltip: 'Switch organization',
      onPressed: () => showOrgSwitcher(context),
    );
  }
}
