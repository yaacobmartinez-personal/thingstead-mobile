import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/ui/celebration.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/ui/sheets.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../orgs/domain/public_org.dart';
import '../application/register_controller.dart';
import '../domain/register_result.dart';

/// Name + confirm, then the outcome in place with the celebration mark.
/// Resolves to the result once the person dismisses the outcome (null if
/// they backed out before submitting).
Future<RegisterResult?> showRegisterSheet(
  BuildContext context, {
  required String org,
  required PublicEvent event,
  required String email,
  String? initialName,
}) =>
    showAppSheet<RegisterResult>(
      context,
      builder: (context) =>
          RegisterSheet(org: org, event: event, email: email, initialName: initialName),
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
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: result != null ? _Outcome(result: result) : _form(),
    );
  }

  Widget _form() {
    final p = context.palette;
    final joinWaitlist = widget.event.isFull && widget.event.waitlistEnabled;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(joinWaitlist ? 'Join the waitlist' : 'Register', style: AppType.title.copyWith(color: p.ink)),
        const SizedBox(height: Spacing.x1),
        Text(widget.event.title, style: AppType.body.copyWith(color: p.muted)),
        if (joinWaitlist)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.x2),
            child: Text(
              "This event is full — you'll be emailed if a place opens up.",
              style: AppType.small.copyWith(color: p.warn, fontWeight: FontWeight.w600),
            ),
          ),
        if (_error != null) ...[
          const SizedBox(height: Spacing.x3),
          ErrorBanner(message: _error!, margin: EdgeInsets.zero),
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
          child: Text(widget.email, style: AppType.body.copyWith(color: p.muted)),
        ),
        const SizedBox(height: Spacing.x5),
        PillButton(
          label: _busy
              ? 'Signing you up…'
              : joinWaitlist
                  ? 'Join the waitlist'
                  : 'Register',
          loading: _busy,
          onPressed: _busy ? null : _submit,
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
    final p = context.palette;
    final o = result.outcome;
    final (IconData? icon, Color color) = switch (o) {
      RegisterOutcome.confirmed => (null, p.success),
      RegisterOutcome.waitlisted => (Icons.hourglass_top, p.warn),
      RegisterOutcome.duplicate => (Icons.confirmation_number_outlined, p.ink),
      RegisterOutcome.full => (Icons.block, p.muted),
      RegisterOutcome.closed => (Icons.lock_outline, p.muted),
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: Celebration(icon: icon, color: color)),
        Text(
          RegisterCopy.title(o),
          textAlign: TextAlign.center,
          style: AppType.title.copyWith(color: p.ink),
        ),
        const SizedBox(height: Spacing.x2),
        Text(
          RegisterCopy.body(o),
          textAlign: TextAlign.center,
          style: AppType.body.copyWith(color: p.muted),
        ),
        const SizedBox(height: Spacing.x5),
        PillButton(
          label: result.ticket != null ? 'View my ticket' : 'OK',
          variant: result.ticket != null ? PillVariant.primary : PillVariant.strong,
          onPressed: () => Navigator.of(context).pop(result),
        ),
      ],
    );
  }
}
