import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/motion.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/section_card.dart';
import '../application/appearance_controller.dart';

/// System / Light / Dark as a segmented pill.
class AppearanceCard extends ConsumerWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final mode = ref.watch(appearanceControllerProvider);
    const options = [
      (ThemeMode.system, 'System', Icons.brightness_auto_outlined),
      (ThemeMode.light, 'Light', Icons.light_mode_outlined),
      (ThemeMode.dark, 'Dark', Icons.dark_mode_outlined),
    ];
    return SectionCard(
      heading: 'Appearance',
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: p.surfaceTint,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: [
              for (final (value, label, icon) in options)
                Expanded(
                  child: GestureDetector(
                    onTap: () => ref.read(appearanceControllerProvider.notifier).set(value),
                    child: AnimatedContainer(
                      duration: Motion.base,
                      curve: Motion.move,
                      height: 40,
                      decoration: BoxDecoration(
                        color: mode == value ? p.lime : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 18, color: mode == value ? p.onLime : p.muted),
                          const SizedBox(width: Spacing.x1),
                          Flexible(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.label.copyWith(
                                fontSize: 13,
                                color: mode == value ? p.onLime : p.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
