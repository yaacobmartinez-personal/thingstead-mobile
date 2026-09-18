import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/fake/fake_providers.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';

/// Fake mode has no inbox, so the token the "email" would carry is shown
/// here with a one-tap "Use it". Renders nothing in real mode.
class FakeOutboxHint extends ConsumerWidget {
  const FakeOutboxHint({
    super.key,
    required this.email,
    required this.kind,
    required this.onUse,
  });

  final String? email;
  final FakeEmailKind kind;
  final void Function(String token) onUse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(apiModeProvider) != ApiMode.fake) return const SizedBox.shrink();
    final store = ref.watch(fakeStoreProvider);
    final needle = email?.trim().toLowerCase();
    final mail = store.outbox.reversed
        .where((m) => m.kind == kind && (needle == null || m.to.toLowerCase() == needle))
        .firstOrNull;
    if (mail == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: Spacing.x4),
      padding: const EdgeInsets.all(Spacing.x3),
      decoration: BoxDecoration(
        color: AppColors.warnBg,
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fake mode inbox',
            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.warn),
          ),
          const SizedBox(height: Spacing.x1),
          Text(
            'To ${mail.to}: token ${mail.token}',
            style: const TextStyle(color: AppColors.warn, fontSize: 13),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => onUse(mail.token),
              child: const Text('Use it'),
            ),
          ),
        ],
      ),
    );
  }
}
