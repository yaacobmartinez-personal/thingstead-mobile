import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/fake/fake_store.dart';
import '../../../core/network/api_error.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/fake_outbox_hint.dart';

/// After signup: wait for the verification email, resend it (rate-limited),
/// or paste the token by hand.
class CheckEmailScreen extends ConsumerStatefulWidget {
  const CheckEmailScreen({super.key, this.email});

  final String? email;

  @override
  ConsumerState<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends ConsumerState<CheckEmailScreen> {
  static const _cooldown = 30;
  int _secondsLeft = 0;
  Timer? _timer;
  bool _busy = false;
  String? _notice;
  String? _error;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    final email = widget.email;
    if (email == null) return;
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).resendVerification(email);
      setState(() {
        _notice = 'Sent again. Give it a minute and check spam too.';
        _secondsLeft = _cooldown;
      });
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return t.cancel();
        setState(() => _secondsLeft--);
        if (_secondsLeft <= 0) t.cancel();
      });
    } on ApiError catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _verify([String? token]) {
    final q = token == null ? '' : '?token=${Uri.encodeComponent(token)}';
    context.push('${Routes.verify}$q');
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    return AuthScaffold(
      title: AppConfig.appName,
      subtitle: 'Check your email',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) AuthError(_error!),
          if (_notice != null) AuthNotice(_notice!),
          const Icon(Icons.mark_email_unread_outlined, size: 40, color: AppColors.navy),
          const SizedBox(height: Spacing.x3),
          Text(
            email == null
                ? 'We sent you a verification link.'
                : 'We sent a verification link to $email.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: Spacing.x2),
          const Text(
            'Open it on this phone to finish creating your account.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: Spacing.x5),
          OutlinedButton(
            onPressed: _busy || _secondsLeft > 0 || email == null ? null : _resend,
            child: Text(
              _secondsLeft > 0 ? 'Resend in ${_secondsLeft}s' : 'Resend email',
            ),
          ),
          TextButton(
            onPressed: () => _verify(),
            child: const Text('I have a verification code'),
          ),
          FakeOutboxHint(email: email, kind: FakeEmailKind.verify, onUse: _verify),
        ],
      ),
    );
  }
}
