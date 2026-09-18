import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../auth/application/auth_controller.dart';

/// Confirm, delete (E7), and explain a 409 `sole_admin` refusal. Copy from
/// the Expo SettingsScreen.
Future<void> runDeleteAccount(BuildContext context, WidgetRef ref) async {
  final ok = await confirmDialog(
    context,
    title: 'Delete account?',
    message: 'This permanently deletes your Thingstead account. Your name and '
        "email are removed and you're taken off every organization. This "
        "can't be undone.",
    confirmLabel: 'Delete account',
    destructive: true,
  );
  if (!ok || !context.mounted) return;

  try {
    await ref.read(authControllerProvider.notifier).deleteAccount();
    if (!context.mounted) return;
    await infoDialog(
      context,
      title: 'Account deleted',
      message: 'Your account and personal details have been removed.',
    );
  } on ApiError catch (e) {
    if (!context.mounted) return;
    await infoDialog(
      context,
      title: "Couldn't delete account",
      message: e.message,
    );
  }
}
