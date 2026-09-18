import 'package:flutter/material.dart';

import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/ui/sheets.dart';

/// Type or paste a ticket code / URL when the camera cannot read it.
/// Returns the entered text, or null when dismissed.
Future<String?> showManualEntrySheet(BuildContext context) =>
    showAppSheet<String>(
      context,
      scrollControlled: true,
      padded: false,
      builder: (context) => const _ManualEntrySheet(),
    );

/// Owns its controller so it outlives the sheet's exit animation (disposing
/// it in `whenComplete` tears the field down while it is still on screen).
class _ManualEntrySheet extends StatefulWidget {
  const _ManualEntrySheet();

  @override
  State<_ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends State<_ManualEntrySheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    // Hide the keyboard and let its animation finish before the route pops.
    // Popping while the IME is still animating out, with a camera texture
    // underneath, stalls rendering on some Android builds.
    FocusManager.instance.primaryFocus?.unfocus();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.gutter, 0, Spacing.gutter, Spacing.gutter),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Enter a ticket code', style: AppType.heading.copyWith(color: p.ink)),
          const SizedBox(height: Spacing.x1),
          Text(
            'Paste the code or the whole check-in link from the ticket.',
            style: AppType.small.copyWith(color: p.muted),
          ),
          const SizedBox(height: Spacing.x4),
          TextField(
            controller: _controller,
            autofocus: true,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: const InputDecoration(hintText: 'Code or link'),
          ),
          const SizedBox(height: Spacing.x4),
          PillButton(label: 'Check in', onPressed: _submit, icon: Icons.check),
        ],
      ),
    );
  }
}
