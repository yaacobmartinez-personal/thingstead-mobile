import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/time/app_time.dart';

/// Searchable list of every IANA zone this build knows, with the current
/// offset next to each. Returns the chosen zone, or null when dismissed.
Future<String?> showTimezonePicker(BuildContext context, {String? selected}) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _TimezonePickerSheet(selected: selected),
    );

class _TimezonePickerSheet extends StatefulWidget {
  const _TimezonePickerSheet({this.selected});

  final String? selected;

  @override
  State<_TimezonePickerSheet> createState() => _TimezonePickerSheetState();
}

class _TimezonePickerSheetState extends State<_TimezonePickerSheet> {
  final _query = TextEditingController();
  late final List<String> _all = AppTime.supportedTimeZones();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<String> get _matches {
    final q = _query.text.trim().toLowerCase().replaceAll(' ', '_');
    if (q.isEmpty) return _all;
    return _all.where((z) => z.toLowerCase().contains(q)).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc();
    final matches = _matches;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.x4, Spacing.x4, Spacing.x4, Spacing.x2),
            child: TextField(
              controller: _query,
              autofocus: true,
              autocorrect: false,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search timezones',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(_query.clear),
                      ),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: matches.isEmpty
                ? const Center(
                    child: Text('No timezone matches that.',
                        style: TextStyle(color: AppColors.muted)),
                  )
                : ListView.builder(
                    controller: controller,
                    itemCount: matches.length,
                    itemExtent: 48,
                    itemBuilder: (context, i) {
                      final zone = matches[i];
                      final isSelected = zone == widget.selected;
                      return ListTile(
                        dense: true,
                        selected: isSelected,
                        title: Text(zone.replaceAll('_', ' ')),
                        trailing: Text(
                          AppTime.zoneLabel(now, zone),
                          style: const TextStyle(color: AppColors.muted, fontSize: 12),
                        ),
                        leading: isSelected
                            ? const Icon(Icons.check, color: AppColors.navy)
                            : const SizedBox(width: 24),
                        onTap: () => Navigator.of(context).pop(zone),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
