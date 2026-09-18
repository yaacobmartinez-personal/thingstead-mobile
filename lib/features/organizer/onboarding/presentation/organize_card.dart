import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../auth/application/auth_controller.dart';

/// The Account-tab invitation to organizer mode, for signed-in people with
/// no organization. Renders nothing otherwise, or when the server cannot
/// create organizations yet.
class OrganizeCard extends ConsumerWidget {
  const OrganizeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    if (!auth.isSignedIn || auth.hasOrganizerAccess) return const SizedBox.shrink();
    if (!isAvailable(Feature.createOrg, ref.watch(apiModeProvider))) {
      return const SizedBox.shrink();
    }
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(top: Spacing.x4),
      child: Container(
        padding: const EdgeInsets.all(Spacing.gutter),
        decoration: BoxDecoration(
          color: p.lime,
          borderRadius: BorderRadius.circular(Radii.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storefront_outlined, color: p.onLime),
                const SizedBox(width: Spacing.x2),
                Expanded(
                  child: Text(
                    'Organize your own events',
                    style: AppType.heading.copyWith(color: p.onLime),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.x2),
            Text(
              'Set up an organization to publish events, take registrations '
              'and check people in at the door.',
              style: AppType.body.copyWith(color: p.onLime.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: Spacing.x4),
            PillButton(
              label: 'Create an organization',
              variant: PillVariant.strong,
              icon: Icons.arrow_forward,
              trailingIcon: true,
              onPressed: () => context.push(Routes.organize),
            ),
          ],
        ),
      ),
    );
  }
}
