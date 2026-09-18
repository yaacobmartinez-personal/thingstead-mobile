import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/app_mode_controller.dart';

/// "Switch to organizer" / "Switch to attendee" entry. Sets the mode, then
/// jumps to that shell's home.
class ModeSwitchTile extends ConsumerWidget {
  const ModeSwitchTile({super.key, required this.target});

  final AppMode target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOrganizer = target == AppMode.organizer;
    return ListTile(
      leading: Icon(isOrganizer ? Icons.admin_panel_settings : Icons.person),
      title: Text(isOrganizer ? 'Switch to organizer' : 'Switch to attendee mode'),
      subtitle: Text(
        isOrganizer
            ? 'Manage events, check people in'
            : 'Find events and keep your tickets',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ref.read(appModeControllerProvider.notifier).set(target);
        context.go(target.home);
      },
    );
  }
}
