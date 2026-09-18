import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/router/guards.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../auth/application/auth_controller.dart';
import '../../registration/presentation/register_sheet.dart';
import '../application/public_events_controller.dart';
import '../application/recent_orgs_controller.dart';
import '../domain/public_org.dart';
import 'org_events_screen.dart';

/// One event's public page with the Register call to action. Public to
/// read; registering asks for a sign-in first (mirrors `register-form.tsx`:
/// "Join the waitlist" when full with a waitlist, disabled when just full).
class PublicEventScreen extends ConsumerWidget {
  const PublicEventScreen({super.key, required this.orgSlug, required this.eventSlug});

  final String orgSlug;
  final String eventSlug;

  Future<void> _register(BuildContext context, WidgetRef ref, PublicEventPage page) async {
    final auth = ref.read(authControllerProvider);
    final user = auth.user;
    if (user == null) {
      unawaited(context.push(loginFor(GoRouterState.of(context).uri)));
      return;
    }
    final result = await showRegisterSheet(
      context,
      org: orgSlug,
      event: page.event,
      email: user.email,
      initialName: user.name,
    );
    final ticket = result?.ticket;
    if (ticket != null && context.mounted) unawaited(context.push(Routes.ticket(ticket.id)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = publicEventProvider(orgSlug, eventSlug);
    final page = ref.watch(provider);

    ref.listen(provider, (_, next) {
      final org = next.value?.org;
      if (org != null) ref.read(recentOrgsProvider.notifier).remember(org);
    });

    final notFound = page.hasError && (page.error as ApiError?)?.status == 404;
    return Scaffold(
      appBar: AppBar(title: Text(page.value?.org.name ?? orgSlug)),
      body: notFound
          ? const EmptyState(
              icon: Icons.event_busy_outlined,
              title: 'This event is not open',
              hint: "It may have been closed, or the link isn't right.",
            )
          : RefreshIndicator(
              onRefresh: () => ref.refresh(provider.future),
              child: AsyncView(
                value: page,
                onRetry: () => ref.invalidate(provider),
                data: (data) => _Body(
                  page: data,
                  onRegister: () => _register(context, ref, data),
                ),
              ),
            ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.page, required this.onRegister});

  final PublicEventPage page;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final e = page.event;
    final chip = PublicEventCard.availabilityChip(e);
    final cta = e.isFull
        ? (e.waitlistEnabled ? 'Join the waitlist' : 'Full')
        : 'Register';
    return ListView(
      padding: const EdgeInsets.all(Spacing.x4),
      children: [
        Text(e.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: Spacing.x2),
        Text(
          AppTime.formatEventWhen(e.startsAt, e.endsAt, e.timezone),
          style: const TextStyle(color: AppColors.muted, height: 1.4, fontSize: 15),
        ),
        Text(
          e.timezone.replaceAll('_', ' '),
          style: const TextStyle(color: AppColors.faint, fontSize: 12),
        ),
        if (chip != null) ...[const SizedBox(height: Spacing.x3), Align(alignment: Alignment.centerLeft, child: chip)],
        if (e.isFull && !e.waitlistEnabled)
          const Padding(
            padding: EdgeInsets.only(top: Spacing.x2),
            child: Text('All places have been taken.', style: TextStyle(color: AppColors.muted)),
          ),
        const SizedBox(height: Spacing.x5),
        FilledButton(
          onPressed: e.canRegister ? onRegister : null,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          child: Text(cta, style: const TextStyle(fontSize: 16)),
        ),
        if ((e.description ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: Spacing.x6),
          const Text(
            'ABOUT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.faint,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: Spacing.x2),
          Text(e.description!.trim(), style: const TextStyle(height: 1.5, fontSize: 15)),
        ],
        const SizedBox(height: Spacing.x6),
        Text(
          'Hosted by ${page.org.name}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.faint, fontSize: 12),
        ),
      ],
    );
  }
}
