import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/motion.dart';
import '../theme/palette.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class NavItem {
  const NavItem({required this.icon, required this.selectedIcon, required this.label});

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Bottom navigation with a lime pill that slides between items and an icon
/// that pops on selection. [badges] maps an index to a small count/dot.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.badges = const {},
  });

  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Map<int, Widget> badges;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: p.surface,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth / items.length;
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: Motion.slow,
                    curve: Motion.move,
                    left: w * selectedIndex + (w - 64) / 2,
                    top: 8,
                    child: Container(
                      width: 64,
                      height: 32,
                      decoration: BoxDecoration(
                        color: p.lime,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (final (i, item) in items.indexed)
                        Expanded(
                          child: _NavButton(
                            item: item,
                            selected: i == selectedIndex,
                            badge: badges[i],
                            onTap: () {
                              HapticFeedback.selectionClick();
                              onSelected(i);
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final NavItem item;
  final bool selected;
  final VoidCallback onTap;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 32,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  AnimatedScale(
                    scale: selected ? 1.1 : 1,
                    duration: Motion.base,
                    curve: Motion.bounce,
                    child: Icon(
                      selected ? item.selectedIcon : item.icon,
                      size: 22,
                      color: selected ? p.onLime : p.muted,
                    ),
                  ),
                  if (badge != null) Positioned(top: -2, right: -14, child: badge!),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppType.captionQuiet.copyWith(
                fontSize: 12,
                color: selected ? p.ink : p.muted,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
