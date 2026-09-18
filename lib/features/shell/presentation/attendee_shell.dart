import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/app_bottom_nav.dart';

/// Bottom navigation for the attendee side: Events · Tickets · Account.
class AttendeeShell extends StatelessWidget {
  const AttendeeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const items = [
    NavItem(icon: Icons.event_outlined, selectedIcon: Icons.event, label: 'Events'),
    NavItem(
      icon: Icons.confirmation_number_outlined,
      selectedIcon: Icons.confirmation_number,
      label: 'Tickets',
    ),
    NavItem(icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        items: items,
        selectedIndex: navigationShell.currentIndex,
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
