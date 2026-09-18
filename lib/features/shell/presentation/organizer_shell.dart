import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/ui/app_bottom_nav.dart';
import '../../organizer/checkin/application/sync_controller.dart';

/// Bottom navigation for the organizer side: Events · Scan · Team · Settings.
/// The Scan item carries a pending-sync dot with the count.
class OrganizerShell extends ConsumerWidget {
  const OrganizerShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const items = [
    NavItem(icon: Icons.event_note_outlined, selectedIcon: Icons.event_note, label: 'Events'),
    NavItem(icon: Icons.qr_code_scanner, selectedIcon: Icons.qr_code_scanner, label: 'Scan'),
    NavItem(icon: Icons.group_outlined, selectedIcon: Icons.group, label: 'Team'),
    NavItem(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep the sync worker alive while the organizer side is open so queued
    // check-ins drain in the background.
    final sync = ref.watch(syncControllerProvider);
    final p = context.palette;
    final pending = sync.pending + sync.attention;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        items: items,
        selectedIndex: navigationShell.currentIndex,
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        badges: {
          if (pending > 0)
            1: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: sync.attention > 0 ? p.danger : p.warn,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$pending',
                style: AppType.caption.copyWith(color: Colors.white, fontSize: 10),
              ),
            ),
        },
      ),
    );
  }
}
