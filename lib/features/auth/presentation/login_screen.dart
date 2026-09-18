import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/api_mode.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/feature_availability.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/server_url.dart';
import '../../../core/network/unauthorized_events.dart';
import '../../../core/router/guards.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/pill_button.dart';
import '../../shell/application/app_mode_controller.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/social_buttons.dart';

/// Port of the Expo LoginScreen: email + password, plus social sign-in and
/// the "Server: host · Change" footer. On success the router's redirect
/// moves on (to `from`, or the shell for the person's role).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.from});

  final String? from;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _run(Future<bool> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final signedIn = await action();
      if (signedIn && mounted) {
        // The screen may be pushed over a shell, where the router's own
        // redirect does not re-run, so move on explicitly.
        context.go(afterSignInTarget(
          from: widget.from,
          mode: ref.read(appModeControllerProvider),
        ));
      }
    } on ApiError catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = "Couldn't sign in. Try again.");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _submit() {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _error = 'Enter your email and password.');
      return;
    }
    _run(() async {
      await ref
          .read(authControllerProvider.notifier)
          .signInWithPassword(_email.text, _password.text);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiMode = ref.watch(apiModeProvider);
    final waking = ref.watch(serverWakingProvider);
    final host = ref.watch(serverUrlProvider.notifier).host;
    final social = isAvailable(Feature.socialSignIn, apiMode);
    final canSignUp = isAvailable(Feature.signup, apiMode);
    final canReset = isAvailable(Feature.passwordReset, apiMode);
    final showApple = social && (Platform.isIOS || apiMode == ApiMode.fake);

    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to your account',
      footer: TextButton(
        onPressed: _busy ? null : () => context.push(Routes.serverAddress),
        child: Text.rich(
          TextSpan(
            text: 'Server: ',
            style: TextStyle(color: context.palette.muted, fontSize: 13),
            children: [
              TextSpan(
                text: host,
                style: TextStyle(
                  color: context.palette.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TextSpan(text: ' · Change'),
            ],
          ),
        ),
      ),
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) AuthError(_error!),
            TextField(
              controller: _email,
              enabled: !_busy,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@example.com',
              ),
            ),
            const SizedBox(height: Spacing.x4),
            TextField(
              controller: _password,
              enabled: !_busy,
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.go,
              onSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: '••••••••',
              ),
            ),
            if (canReset)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _busy ? null : () => context.push(Routes.forgot),
                  child: const Text('Forgot password?'),
                ),
              )
            else
              const SizedBox(height: Spacing.x4),
            PillButton(
              label: _busy ? (waking ? 'Waking the server…' : 'Signing in…') : 'Sign in',
              onPressed: _busy ? null : _submit,
              loading: _busy && !waking,
            ),
            if (social) ...[
              const SizedBox(height: Spacing.x5),
              const _OrDivider(),
              const SizedBox(height: Spacing.x5),
              SocialButtons(
                busy: _busy,
                showApple: showApple,
                onGoogle: () => _run(
                  () => ref.read(authControllerProvider.notifier).signInWithGoogle(),
                ),
                onApple: () => _run(
                  () => ref.read(authControllerProvider.notifier).signInWithApple(),
                ),
              ),
            ],
            if (canSignUp) ...[
              const SizedBox(height: Spacing.x4),
              TextButton(
                onPressed: _busy ? null : () => context.pushReplacement(Routes.signup),
                child: const Text('New here? Create an account'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.x3),
          child: Text('or', style: TextStyle(color: context.palette.faint)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
