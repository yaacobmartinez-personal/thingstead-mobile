import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_error.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/spacing.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_scaffold.dart';

/// Attendee account creation (API-CONTRACT #1). Always lands on "check your
/// email" so the screen never reveals whether the address was taken.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final fields = <String, String>{};
    if (_name.text.trim().length < 2) fields['name'] = 'Enter your name.';
    if (!_email.text.contains('@')) fields['email'] = 'Enter a valid email address.';
    if (_password.text.length < 8) fields['password'] = 'Use at least 8 characters.';
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
      await ref.read(authControllerProvider.notifier).signUp(
            email: _email.text,
            password: _password.text,
            name: _name.text,
          );
      if (!mounted) return;
      context.pushReplacement(
        '${Routes.checkEmail}?email=${Uri.encodeComponent(_email.text.trim())}',
      );
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
      title: 'Create your account',
      subtitle: 'Join in a minute',
      showBack: true,
      compact: true,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) AuthError(_error!),
            TextField(
              controller: _name,
              enabled: !_busy,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _fieldErrors['name'],
              ),
            ),
            const SizedBox(height: Spacing.x4),
            TextField(
              controller: _email,
              enabled: !_busy,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _fieldErrors['email'],
              ),
            ),
            const SizedBox(height: Spacing.x4),
            TextField(
              controller: _password,
              enabled: !_busy,
              obscureText: true,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Password',
                helperText: 'At least 8 characters',
                errorText: _fieldErrors['password'],
              ),
            ),
            const SizedBox(height: Spacing.x5),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: Text(_busy ? 'Creating…' : 'Create account'),
            ),
            const SizedBox(height: Spacing.x2),
            TextButton(
              onPressed: _busy ? null : () => context.pushReplacement(Routes.login),
              child: const Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
