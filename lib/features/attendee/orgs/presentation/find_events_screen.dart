import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/api_mode.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/router/deep_link_parser.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/illustrations.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/ui/hero_scaffold.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/ui/stagger.dart';
import '../../../../core/ui/tiles.dart';
import '../../../../core/util/slugify.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../auth/application/auth_controller.dart';
import '../application/recent_orgs_controller.dart';
import 'link_scanner_sheet.dart';

/// Attendee "Events" tab. There is no directory — people arrive with a link
/// or an organization code — so this is a greeting, a code field, the
/// shortcuts row, and the orgs they opened before.
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

  Future<void> _paste() async {
    final data = await Clipboard.getData('text/plain');
    final text = data?.text?.trim() ?? '';
    if (!mounted) return;
    if (text.isEmpty) {
      setState(() => _error = 'Nothing to paste.');
      return;
    }
    _code.text = text;
    _go();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
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

    final user = ref.watch(authControllerProvider).user;
    final first = (user?.name ?? '').trim().split(' ').firstOrNull;
    final recent = ref.watch(recentOrgsProvider).value ?? const [];
    final host = Uri.parse(AppConfig.publicOrigin).host;

    return HeroScaffold(
      image: const AssetImage(Illustrations.find),
      heroFraction: 0.36,
      imageAlignment: Alignment.bottomCenter,
      eyebrow: first == null || first.isEmpty ? 'Hello there' : 'Hello, $first',
      title: 'Find your next event',
      children: [
        Enter(
          child: Container(
            padding: const EdgeInsets.all(Spacing.gutter),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(Radii.card),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Have an organization code?', style: AppType.heading.copyWith(color: p.ink)),
                const SizedBox(height: Spacing.x1),
                Text(
                  "It's the last part of their link: $host/<code>.",
                  style: AppType.small.copyWith(color: p.muted),
                ),
                const SizedBox(height: Spacing.x4),
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
                    suffixIcon: IconButton(
                      tooltip: 'Show events',
                      icon: Icon(Icons.arrow_forward, color: p.ink),
                      onPressed: _go,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.x3),
                PillButton(label: 'Show events', onPressed: _go),
              ],
            ),
          ),
        ),
        const SizedBox(height: Spacing.x5),
        Enter(
          index: 1,
          child: Row(
            children: [
              Expanded(child: IconTile(icon: Icons.qr_code_scanner, label: 'Scan link', onTap: _scan)),
              Expanded(child: IconTile(icon: Icons.content_paste, label: 'Paste link', onTap: _paste)),
              Expanded(
                child: IconTile(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Tickets',
                  onTap: () => context.go(Routes.attendeeTickets),
                ),
              ),
              Expanded(
                child: IconTile(
                  icon: Icons.person_outline,
                  label: 'Account',
                  onTap: () => context.go(Routes.attendeeAccount),
                ),
              ),
            ],
          ),
        ),
        if (recent.isNotEmpty) ...[
          const SizedBox(height: Spacing.x6),
          const Enter(index: 2, child: SectionLabel('Recent')),
          for (final (i, org) in recent.indexed)
            Enter(
              index: 3 + i,
              child: Padding(
                padding: const EdgeInsets.only(bottom: Spacing.x3),
                child: Material(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(Radii.card),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.push(Routes.attendeeOrg(org.slug)),
                    onLongPress: () => ref.read(recentOrgsProvider.notifier).forget(org.slug),
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.x4),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Radii.md),
                            child: Image.asset(Illustrations.org, width: 56, height: 56, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: Spacing.x3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(org.name, style: AppType.bodyStrong.copyWith(color: p.ink)),
                                Text('$host/${org.slug}', style: AppType.small.copyWith(color: p.muted)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: p.faint),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
