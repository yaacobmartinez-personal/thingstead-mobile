import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/router/deep_link_parser.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/util/slugify.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/section_card.dart';
import '../application/recent_orgs_controller.dart';
import 'link_scanner_sheet.dart';

/// Attendee "Events" tab. There is no directory — people arrive with a link
/// or an organization code — so this is a code field, a link scanner, and
/// the orgs they opened before.
class FindEventsScreen extends ConsumerStatefulWidget {
  const FindEventsScreen({super.key});

  @override
  ConsumerState<FindEventsScreen> createState() => _FindEventsScreenState();
}

class _FindEventsScreenState extends ConsumerState<FindEventsScreen> {
  final _code = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  /// Accepts a bare code or a pasted link.
  void _go() {
    final raw = _code.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = 'Enter the organization code from your invitation.');
      return;
    }
    final uri = Uri.tryParse(raw);
    if (uri != null && uri.hasScheme) {
      _open(DeepLinkParser().parse(uri));
      return;
    }
    final slug = raw.toLowerCase();
    if (!isUsableSlug(slug)) {
      setState(() => _error = 'Codes are 3–63 lowercase letters, numbers, or hyphens.');
      return;
    }
    setState(() => _error = null);
    FocusScope.of(context).unfocus();
    context.push(Routes.attendeeOrg(slug));
  }

  void _open(DeepLinkTarget? target) {
    switch (target) {
      case OrgEventsTarget(:final org):
        setState(() => _error = null);
        context.push(Routes.attendeeOrg(org));
      case EventDetailTarget(:final org, :final event):
        setState(() => _error = null);
        context.push(Routes.attendeeEvent(org, event));
      default:
        setState(() => _error = "That link doesn't point at an organization or event.");
    }
  }

  Future<void> _scan() async {
    final target = await showLinkScanner(context);
    if (target != null && mounted) _open(target);
  }

  @override
  Widget build(BuildContext context) {
    if (!isAvailable(Feature.attendeeMode, ref.watch(apiModeProvider))) {
      return Scaffold(
        appBar: AppBar(title: const Text('Find events')),
        body: const EmptyState(
          icon: Icons.search,
          title: 'Coming to the app soon',
          hint: 'Register for events on the web for now — this server does not '
              'support attendee accounts in the app yet.',
        ),
      );
    }

    final recent = ref.watch(recentOrgsProvider).value ?? const [];
    final host = Uri.parse(AppConfig.publicOrigin).host;
    return Scaffold(
      appBar: AppBar(title: const Text('Find events')),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(Spacing.x4),
        children: [
          SectionCard(
            heading: 'Have an organization code?',
            body: "It's the last part of their link: $host/<code>.",
            children: [
              TextField(
                controller: _code,
                autocorrect: false,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.url,
                onSubmitted: (_) => _go(),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                decoration: InputDecoration(
                  hintText: 'acme',
                  prefixText: '$host/',
                  errorText: _error,
                  errorMaxLines: 2,
                ),
              ),
              const SizedBox(height: Spacing.x3),
              FilledButton(
                onPressed: _go,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: const Text('Show events'),
              ),
              const SizedBox(height: Spacing.x2),
              OutlinedButton.icon(
                onPressed: _scan,
                icon: const Icon(Icons.qr_code_scanner, size: 20),
                label: const Text('Scan a link QR'),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              ),
            ],
          ),
          if (recent.isNotEmpty) ...[
            const SizedBox(height: Spacing.x6),
            const Padding(
              padding: EdgeInsets.only(left: Spacing.x1, bottom: Spacing.x2),
              child: Text(
                'RECENT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.faint,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  for (final (i, org) in recent.indexed) ...[
                    if (i > 0) const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.business_outlined),
                      title: Text(org.name),
                      subtitle: Text('$host/${org.slug}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(Routes.attendeeOrg(org.slug)),
                      onLongPress: () =>
                          ref.read(recentOrgsProvider.notifier).forget(org.slug),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
