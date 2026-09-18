import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../orgs/domain/public_org.dart';
import '../application/register_controller.dart';
import '../domain/register_result.dart';

/// Name + confirm, then the outcome in place. Resolves to the result once
/// the person dismisses the outcome (null if they backed out before
/// submitting).
Future<RegisterResult?> showRegisterSheet(
  BuildContext context, {
  required String org,
  required PublicEvent event,
  required String email,
  String? initialName,
}) =>
    showModalBottomSheet<RegisterResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: RegisterSheet(org: org, event: event, email: email, initialName: initialName),
      ),
    );

class RegisterSheet extends ConsumerStatefulWidget {
  const RegisterSheet({
    super.key,
    required this.org,
    required this.event,
    required this.email,
    this.initialName,
  });

  final String org;
  final PublicEvent event;
  final String email;
  final String? initialName;

  @override
  ConsumerState<RegisterSheet> createState() => _RegisterSheetState();
}

class _RegisterSheetState extends ConsumerState<RegisterSheet> {
  late final _name = TextEditingController(text: widget.initialName ?? '');
  bool _busy = false;
  String? _error;
  String? _nameError;
  RegisterResult? _result;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Tell us your name.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _nameError = null;
    });
    try {
      final result = await ref
          .read(registerControllerProvider.notifier)
          .register(widget.org, widget.event.slug, name: name);
      if (mounted) setState(() => _result = result);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _nameError = e.fieldErrors['name'];
        _error = e.fieldErrors.isEmpty ? e.message : null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Couldn't register. Try again.");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Padding(
      padding: const EdgeInsets.all(Spacing.x4),
      child: result != null ? _Outcome(result: result) : _form(),
    );
  }

  Widget _form() {
    final joinWaitlist = widget.event.isFull && widget.event.waitlistEnabled;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          joinWaitlist ? 'Join the waitlist' : 'Register',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: Spacing.x1),
        Text(
          widget.event.title,
          style: const TextStyle(color: AppColors.muted),
        ),
        if (joinWaitlist)
          const Padding(
            padding: EdgeInsets.only(top: Spacing.x2),
            child: Text(
              "This event is full — you'll be emailed if a place opens up.",
              style: TextStyle(color: AppColors.warn),
            ),
          ),
        if (_error != null) ...[
          const SizedBox(height: Spacing.x3),
          ErrorBanner(message: _error!),
        ],
        const SizedBox(height: Spacing.x4),
        TextField(
          controller: _name,
          enabled: !_busy,
          autofocus: (widget.initialName ?? '').isEmpty,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(labelText: 'Your name', errorText: _nameError),
        ),
        const SizedBox(height: Spacing.x3),
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Email',
            helperText: 'Your ticket and updates go to your account email.',
            helperMaxLines: 2,
          ),
          child: Text(widget.email, style: const TextStyle(color: AppColors.muted)),
        ),
        const SizedBox(height: Spacing.x4),
        FilledButton(
          onPressed: _busy ? null : _submit,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          child: Text(
            _busy
                ? 'Signing you up…'
                : joinWaitlist
                    ? 'Join the waitlist'
                    : 'Register',
          ),
        ),
      ],
    );
  }
}

class _Outcome extends StatelessWidget {
  const _Outcome({required this.result});

  final RegisterResult result;

  @override
  Widget build(BuildContext context) {
    final o = result.outcome;
    final good = o == RegisterOutcome.confirmed;
    final (icon, color, bg) = good
        ? (Icons.check_circle_outline, AppColors.success, AppColors.successBg)
        : (Icons.info_outline, AppColors.warn, AppColors.warnBg);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.x4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(Radii.md),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: Spacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      RegisterCopy.title(o),
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: color),
                    ),
                    const SizedBox(height: Spacing.x1),
                    Text(RegisterCopy.body(o), style: const TextStyle(height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.x4),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(result),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          child: Text(result.ticket != null ? 'View my ticket' : 'OK'),
        ),
      ],
    );
  }
}
