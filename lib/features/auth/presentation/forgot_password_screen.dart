import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/fake/fake_store.dart';
import '../../../core/network/api_error.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/spacing.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/fake_outbox_hint.dart';

/// API-CONTRACT #4. Always reports success so the screen never reveals
/// whether an account exists.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_email.text.contains('@')) {
      setState(() => _error = 'Enter your email address.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).forgotPassword(_email.text);
      setState(() => _sent = true);
    } on ApiError catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _reset([String? token]) {
    final q = token == null ? '' : '?token=${Uri.encodeComponent(token)}';
    context.push('${Routes.reset}$q');
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: AppConfig.appName,
      subtitle: 'Reset your password',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) AuthError(_error!),
          if (_sent)
            const AuthNotice(
              'If an account exists for that email, a reset link is on its way.',
            ),
          TextField(
            controller: _email,
            enabled: !_busy && !_sent,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: Spacing.x5),
          FilledButton(
            onPressed: _busy || _sent ? null : _submit,
            child: Text(_busy ? 'Sending…' : 'Send reset link'),
          ),
          TextButton(
            onPressed: () => _reset(),
            child: const Text('I have a reset code'),
          ),
          FakeOutboxHint(
            email: _email.text,
            kind: FakeEmailKind.reset,
            onUse: _reset,
          ),
        ],
      ),
    );
  }
}
