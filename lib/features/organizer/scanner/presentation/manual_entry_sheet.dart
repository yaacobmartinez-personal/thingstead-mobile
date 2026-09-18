import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';

/// Type or paste a ticket code / URL when the camera cannot read it.
/// Returns the entered text, or null when dismissed.
Future<String?> showManualEntrySheet(BuildContext context) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
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

  void _submit() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Spacing.x4,
        0,
        Spacing.x4,
        MediaQuery.viewInsetsOf(context).bottom + Spacing.x4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Enter a ticket code',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: Spacing.x1),
          const Text(
            'Paste the code or the whole check-in link from the ticket.',
            style: TextStyle(color: Colors.black54),
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
          FilledButton(onPressed: _submit, child: const Text('Check in')),
        ],
      ),
    );
  }
}
