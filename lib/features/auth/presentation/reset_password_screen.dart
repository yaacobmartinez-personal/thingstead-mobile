import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_error.dart';
import '../../../core/theme/spacing.dart';
import '../../shell/application/app_mode_controller.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_scaffold.dart';

/// API-CONTRACT #5. Token arrives via deep link or is pasted; success signs
/// the person in.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, this.token});

  final String? token;

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late final _token = TextEditingController(text: widget.token ?? '');
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  String? _error;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    _token.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final fields = <String, String>{};
    if (_token.text.trim().isEmpty) fields['token'] = 'Paste the code from the email.';
    if (_password.text.length < 8) fields['password'] = 'Use at least 8 characters.';
    if (_confirm.text != _password.text) fields['confirm'] = "Passwords don't match.";
    if (fields.isNotEmpty) {
      setState(() {
        _fieldErrors = fields;
        _error = null;
      });
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _fieldErrors = const {};
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .resetPassword(_token.text.trim(), _password.text);
      if (!mounted) return;
      context.go(ref.read(appModeControllerProvider).home);
    } on ApiError catch (e) {
      setState(() {
        _error = e.fieldErrors.isEmpty ? e.message : null;
        _fieldErrors = e.fieldErrors;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Choose a new password',
      subtitle: 'Make it a good one',
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
            decoration: InputDecoration(
              labelText: 'Reset code',
              errorText: _fieldErrors['token'],
            ),
          ),
          const SizedBox(height: Spacing.x4),
          TextField(
            controller: _password,
            enabled: !_busy,
            obscureText: true,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(
              labelText: 'New password',
              helperText: 'At least 8 characters',
              errorText: _fieldErrors['password'],
            ),
          ),
          const SizedBox(height: Spacing.x4),
          TextField(
            controller: _confirm,
            enabled: !_busy,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Confirm password',
              errorText: _fieldErrors['confirm'],
            ),
          ),
          const SizedBox(height: Spacing.x5),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: Text(_busy ? 'Saving…' : 'Save and sign in'),
          ),
        ],
      ),
    );
  }
}
