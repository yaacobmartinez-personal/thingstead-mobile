import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_error.dart';
import '../../../core/theme/spacing.dart';
import '../../shell/application/app_mode_controller.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_scaffold.dart';

/// Redeems a verification token (API-CONTRACT #2). Opened from the emailed
/// link via deep link (token pre-filled and auto-submitted) or by pasting.
class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({super.key, this.token});

  final String? token;

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  late final _token = TextEditingController(text: widget.token ?? '');
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if ((widget.token ?? '').isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _submit());
    }
  }

  @override
  void dispose() {
    _token.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final token = _token.text.trim();
    if (token.isEmpty) {
      setState(() => _error = 'Paste the code from the email.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).verifyEmail(token);
      if (!mounted) return;
      context.go(ref.read(appModeControllerProvider).home);
    } on ApiError catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Verify your email',
      subtitle: 'Almost there',
      showBack: true,
      compact: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) AuthError(_error!),
          TextField(
            controller: _token,
            enabled: !_busy,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: const InputDecoration(
              labelText: 'Verification code',
              helperText: 'From the link in your email',
            ),
          ),
          const SizedBox(height: Spacing.x5),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: Text(_busy ? 'Verifying…' : 'Verify and sign in'),
          ),
        ],
      ),
    );
  }
}
