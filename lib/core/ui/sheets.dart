import 'package:flutter/material.dart';

import '../theme/spacing.dart';

/// One way to open a bottom sheet: rounded top, drag handle (from the
/// theme), keyboard inset, safe area, gutter padding. Returns the sheet's
/// result.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool scrollControlled = true,
  bool padded = true,
}) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: scrollControlled,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: padded
            ? Padding(
                padding: const EdgeInsets.fromLTRB(Spacing.gutter, 0, Spacing.gutter, Spacing.gutter),
                child: builder(context),
              )
            : builder(context),
      ),
    );
