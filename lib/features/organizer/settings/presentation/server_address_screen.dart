import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/server_url.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../auth/application/auth_controller.dart';

/// Which deployment the app talks to. Port of the Expo SettingsScreen's
/// server section: validation, "Will save as:" preview, reset to default.
/// Saving while signed in ends the session (a token is server-specific).
class ServerAddressScreen extends ConsumerStatefulWidget {
  const ServerAddressScreen({super.key});

  @override
  ConsumerState<ServerAddressScreen> createState() => _ServerAddressScreenState();
}

class _ServerAddressScreenState extends ConsumerState<ServerAddressScreen> {
  late final TextEditingController _value;
  bool _busy = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _value = TextEditingController(text: ref.read(serverUrlProvider));
    _value.addListener(() {
      if (_saved) setState(() => _saved = false);
    });
  }

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final signedIn = ref.read(authControllerProvider).isSignedIn;
    if (signedIn) {
      final ok = await confirmDialog(
        context,
        title: 'Change server?',
        message: "You'll be signed out, because your session belongs to the "
            'current server.',
        confirmLabel: 'Change and sign out',
      );
      if (!ok) return;
    }
    setState(() => _busy = true);
    await ref.read(authControllerProvider.notifier).changeServer(_value.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _saved = true;
    });
    if (signedIn) context.go('/a/events');
  }

  @override
  Widget build(BuildContext context) {
    final raw = _value.text;
    final invalid = !isValidServerUrl(raw);
    final normalized =
        normalizeServerUrl(raw.trim().isEmpty ? AppConfig.defaultServerUrl : raw);

    return Scaffold(
      appBar: AppBar(title: const Text('Server address')),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.x4),
        children: [
          SectionCard(
            heading: 'Server address',
            body: 'Where this app sends requests. Use your Thingstead '
                "deployment's address — the live site, a staging server, or a "
                'laptop on the same network.',
            children: [
              TextField(
                controller: _value,
                enabled: !_busy,
                keyboardType: TextInputType.url,
                autocorrect: false,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Base URL',
                  hintText: AppConfig.defaultServerUrl,
                  helperText: 'Include http:// or https:// and no trailing path.',
                  errorText: invalid && raw.trim().isNotEmpty
                      ? 'Enter a full URL starting with http:// or https://.'
                      : null,
                ),
              ),
              if (_saved && !invalid)
                const Padding(
                  padding: EdgeInsets.only(top: Spacing.x3),
                  child: Text('Saved.', style: TextStyle(color: AppColors.success)),
                ),
              const SizedBox(height: Spacing.x4),
              FilledButton(
                onPressed: _busy || invalid ? null : _save,
                child: Text(_busy ? 'Saving…' : 'Save address'),
              ),
              if (raw.trim() != AppConfig.defaultServerUrl) ...[
                const SizedBox(height: Spacing.x2),
                OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () => setState(
                            () => _value.text = AppConfig.defaultServerUrl,
                          ),
                  child: const Text('Reset to default'),
                ),
              ],
              const SizedBox(height: Spacing.x3),
              Text(
                'Will save as: $normalized',
                style: const TextStyle(fontSize: 12, color: AppColors.faint),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
