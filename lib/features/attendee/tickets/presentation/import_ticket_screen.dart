import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/router/deep_link_parser.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../auth/application/auth_controller.dart';
import '../application/tickets_controller.dart';

/// Attach a registration made without the app (or on the web) to this
/// account, from the manage link in the confirmation email. Opened by the
/// deep link with the token in hand, or by hand with a pasted link.
class ImportTicketScreen extends ConsumerStatefulWidget {
  const ImportTicketScreen({super.key, this.token});

  final String? token;

  @override
  ConsumerState<ImportTicketScreen> createState() => _ImportTicketScreenState();
}

class _ImportTicketScreenState extends ConsumerState<ImportTicketScreen> {
  final _link = TextEditingController();
  bool _busy = false;
  String? _error;
  bool _mismatch = false;

  @override
  void initState() {
    super.initState();
    final token = widget.token;
    if (token != null && token.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _import(token));
    }
  }

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  /// A pasted manage link or the bare token.
  static String? tokenFrom(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) {
      final target = DeepLinkParser().parse(uri);
      return target is ImportTicketTarget ? target.token : uri.queryParameters['token'];
    }
    return value;
  }

  Future<void> _submit() => _import(tokenFrom(_link.text) ?? '');

  Future<void> _import(String token) async {
    if (token.isEmpty) {
      setState(() => _error = 'Paste the link from your confirmation email.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _mismatch = false;
    });
    try {
      final ticket = await ref.read(ticketActionsProvider.notifier).import(token);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Ticket added.')));
      context.pushReplacement(Routes.ticket(ticket.id));
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _mismatch = e.reason == 'email_mismatch';
        _error = _mismatch
            ? 'This ticket was registered with a different email address. Sign in '
                'with that address to add it.'
            : e.status == 404
                ? "That link isn't valid anymore. It may have been replaced by a newer "
                    'confirmation, or the details were erased.'
                : e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Couldn't add the ticket. Try again.");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(authControllerProvider).user?.email;
    return Scaffold(
      appBar: AppBar(title: const Text('Add a ticket')),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(Spacing.x4),
        children: [
          SectionCard(
            heading: 'From your confirmation email',
            body: 'Paste the "manage your registration" link. The ticket must have '
                'been registered with ${email ?? 'your account email'}.',
            children: [
              if (_error != null) ...[
                ErrorBanner(message: _error!),
                const SizedBox(height: Spacing.x3),
              ],
              TextField(
                controller: _link,
                enabled: !_busy,
                autocorrect: false,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  labelText: 'Link',
                  hintText: 'https://thingstead.pro/acme/summer-meetup/manage?token=…',
                ),
              ),
              const SizedBox(height: Spacing.x3),
              FilledButton(
                onPressed: _busy ? null : _submit,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: Text(_busy ? 'Adding…' : 'Add ticket'),
              ),
              if (_mismatch) ...[
                const SizedBox(height: Spacing.x2),
                Text(
                  'Tip: sign out from Account, then sign in with the address the '
                  'confirmation was sent to.',
                  style: TextStyle(color: context.palette.muted, fontSize: 13),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
