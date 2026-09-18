import 'package:flutter/material.dart';

import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/error_banner.dart';
import '../domain/team.dart';

/// Email + role, submitted through [onInvite]. Resolves to the result, or
/// null when dismissed. Field errors from the server show inline.
Future<InviteResult?> showInviteSheet(
  BuildContext context, {
  required Future<InviteResult> Function({required String email, required Role role}) onInvite,
}) =>
    showModalBottomSheet<InviteResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: InviteSheet(onInvite: onInvite),
      ),
    );

class InviteSheet extends StatefulWidget {
  const InviteSheet({super.key, required this.onInvite});

  final Future<InviteResult> Function({required String email, required Role role}) onInvite;

  @override
  State<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<InviteSheet> {
  final _email = TextEditingController();
  Role _role = Role.staff;
  bool _busy = false;
  String? _error;
  String? _emailError;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = 'Enter an email address.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _emailError = null;
    });
    try {
      final result = await widget.onInvite(email: email, role: _role);
      if (mounted) Navigator.of(context).pop(result);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _emailError = e.fieldErrors['email'];
        _error = e.fieldErrors.isEmpty ? e.message : null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Couldn't send the invitation. Try again.");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.x4, Spacing.x4, Spacing.x4, Spacing.x4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Invite a teammate',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: Spacing.x1),
          const Text(
            "They'll get an email with a link that's valid for 7 days.",
            style: TextStyle(color: AppColors.muted),
          ),
          if (_error != null) ...[
            const SizedBox(height: Spacing.x3),
            ErrorBanner(message: _error!),
          ],
          const SizedBox(height: Spacing.x4),
          TextField(
            controller: _email,
            enabled: !_busy,
            autofocus: true,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'name@example.com',
              errorText: _emailError,
            ),
          ),
          const SizedBox(height: Spacing.x3),
          RadioGroup<Role>(
            groupValue: _role,
            onChanged: (r) {
              if (!_busy && r != null) setState(() => _role = r);
            },
            child: Column(
              children: [
                for (final role in [Role.staff, Role.admin])
                  RadioListTile<Role>(
                    value: role,
                    enabled: !_busy,
                    contentPadding: EdgeInsets.zero,
                    title: Text(RoleCopy.label(role)),
                    subtitle: Text(RoleCopy.summary(role)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.x3),
          FilledButton(
            onPressed: _busy ? null : _submit,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: Text(_busy ? 'Sending…' : 'Send invitation'),
          ),
        ],
      ),
    );
  }
}
