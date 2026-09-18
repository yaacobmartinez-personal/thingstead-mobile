import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/api_mode.dart';
import '../../../core/config/feature_availability.dart';
import '../../../core/network/api_error.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/motion.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/ui/pill_button.dart';
import '../../organizer/onboarding/application/organize_intent.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_scaffold.dart';

/// Account creation (API-CONTRACT #1). Always lands on "check your email" so
/// the screen never reveals whether the address was taken. The "organize"
/// choice is remembered so verification can continue into org setup.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key, this.organize = false});

  /// Preselect "Organize events" (arrived via the organizer entry points).
  final bool organize;

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
  late bool _organize = widget.organize;

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
      ref.read(organizeIntentProvider.notifier).set(_organize && _canOrganize);
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

  bool get _canOrganize => isAvailable(Feature.createOrg, ref.read(apiModeProvider));

  @override
  Widget build(BuildContext context) {
    final organize = _organize && _canOrganize;
    return AuthScaffold(
      title: 'Create your account',
      subtitle: organize ? 'Your organization comes next' : 'Join in a minute',
      showBack: true,
      compact: true,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) AuthError(_error!),
            if (_canOrganize) ...[
              _IntentChoice(
                organize: _organize,
                enabled: !_busy,
                onChanged: (v) => setState(() => _organize = v),
              ),
              const SizedBox(height: Spacing.x4),
            ],
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
            PillButton(
              label: _busy ? 'Creating…' : 'Create account',
              loading: _busy,
              onPressed: _busy ? null : _submit,
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

/// "I'm here to…" — two selectable cards. Attend is the default; Organize
/// sets the intent that routes verification into organization setup.
class _IntentChoice extends StatelessWidget {
  const _IntentChoice({
    required this.organize,
    required this.enabled,
    required this.onChanged,
  });

  final bool organize;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("I'm here to", style: AppType.caption.copyWith(color: p.muted)),
        const SizedBox(height: Spacing.x2),
        Row(
          children: [
            Expanded(
              child: _IntentCard(
                icon: Icons.confirmation_number_outlined,
                title: 'Attend events',
                body: 'Register and keep my tickets',
                selected: !organize,
                onTap: enabled ? () => onChanged(false) : null,
              ),
            ),
            const SizedBox(width: Spacing.x3),
            Expanded(
              child: _IntentCard(
                icon: Icons.storefront_outlined,
                title: 'Organize events',
                body: 'Run registrations and check-in',
                selected: organize,
                onTap: enabled ? () => onChanged(true) : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IntentCard extends StatelessWidget {
  const _IntentCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: title,
      child: AnimatedContainer(
        duration: Motion.base,
        curve: Motion.move,
        decoration: BoxDecoration(
          color: selected ? p.lime : p.surfaceTint,
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Radii.lg),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.x3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 22, color: selected ? p.onLime : p.moss),
                  const SizedBox(height: Spacing.x2),
                  Text(
                    title,
                    style: AppType.label.copyWith(color: selected ? p.onLime : p.ink),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    body,
                    style: AppType.small.copyWith(
                      color: selected ? p.onLime.withValues(alpha: 0.75) : p.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
