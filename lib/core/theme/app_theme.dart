import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'palette.dart';
import 'spacing.dart';
import 'typography.dart';

/// Light and dark themes built from one [AppPalette] each. Widgets read
/// colors through `context.palette`; the Material theme below exists so the
/// stock widgets (dialogs, pickers, snackbars) match without per-use styling.
abstract final class AppTheme {
  static ThemeData light() => _build(AppPalette.light);
  static ThemeData dark() => _build(AppPalette.dark);

  static ThemeData _build(AppPalette p) {
    final scheme = ColorScheme(
      brightness: p.brightness,
      primary: p.lime,
      onPrimary: p.onLime,
      primaryContainer: p.limeDeep,
      onPrimaryContainer: p.onLime,
      secondary: p.moss,
      onSecondary: p.isDark ? p.onLime : const Color(0xFFEEF3E6),
      secondaryContainer: p.surfaceTint,
      onSecondaryContainer: p.ink,
      tertiary: p.warn,
      onTertiary: p.onLime,
      tertiaryContainer: p.warnBg,
      onTertiaryContainer: p.warn,
      error: p.danger,
      onError: p.isDark ? p.onLime : Colors.white,
      errorContainer: p.dangerBg,
      onErrorContainer: p.danger,
      surface: p.surface,
      onSurface: p.ink,
      onSurfaceVariant: p.muted,
      outline: p.faint,
      outlineVariant: p.surfaceTint,
      surfaceContainerHighest: p.surfaceTint,
      surfaceContainerHigh: p.surfaceTint,
      surfaceContainer: p.surface,
      surfaceContainerLow: p.sage,
      surfaceContainerLowest: p.surface,
      inverseSurface: p.strong,
      onInverseSurface: p.onInk,
      inversePrimary: p.limeDeep,
      shadow: p.shadow,
      scrim: const Color(0xFF171C14),
    );

    final text = AppType.textTheme(p.ink, p.muted);
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppType.family,
      textTheme: text,
      scaffoldBackgroundColor: p.sage,
      splashFactory: InkSparkle.splashFactory,
      extensions: [p],
      // Shared-axis pushes on Android; iOS keeps its swipe-back Cupertino push.
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: p.sage,
          ),
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
        },
      ),
    );

    final card = RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.card));
    final sheet = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
    );
    OutlineInputBorder inputBorder(Color color, [double width = 0]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: width == 0 ? BorderSide.none : BorderSide(color: color, width: width),
        );
    final buttonText = AppType.label.copyWith(fontSize: 15);

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: p.sage,
        foregroundColor: p.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppType.heading.copyWith(color: p.ink, fontSize: 20),
        iconTheme: IconThemeData(color: p.ink),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        indicatorColor: p.lime,
        indicatorShape: const StadiumBorder(),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppType.captionQuiet.copyWith(
            fontSize: 12,
            color: states.contains(WidgetState.selected) ? p.ink : p.muted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? p.onLime : p.muted,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: card,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surfaceTint,
        contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.x4, vertical: 14),
        border: inputBorder(p.surfaceTint),
        enabledBorder: inputBorder(p.surfaceTint),
        focusedBorder: inputBorder(p.limeDeep, 2),
        errorBorder: inputBorder(p.danger, 1.5),
        focusedErrorBorder: inputBorder(p.danger, 2),
        disabledBorder: inputBorder(p.surfaceTint),
        labelStyle: AppType.small.copyWith(color: p.muted),
        floatingLabelStyle: AppType.small.copyWith(color: p.muted, fontWeight: FontWeight.w700),
        hintStyle: AppType.body.copyWith(color: p.faint),
        helperStyle: AppType.captionQuiet.copyWith(color: p.muted),
        errorStyle: AppType.captionQuiet.copyWith(color: p.danger),
        prefixStyle: AppType.body.copyWith(color: p.muted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.lime,
          foregroundColor: p.onLime,
          disabledBackgroundColor: p.surfaceTint,
          disabledForegroundColor: p.faint,
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: buttonText,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.ink,
          backgroundColor: p.surface,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide.none,
          shape: const StadiumBorder(),
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.ink,
          shape: const StadiumBorder(),
          textStyle: buttonText,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: p.ink),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.strong,
        foregroundColor: p.onInk,
        elevation: 0,
        highlightElevation: 0,
        shape: const StadiumBorder(),
        extendedTextStyle: buttonText,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: BorderSide(color: p.faint, width: 1.5),
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.success : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all(Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.onLime : p.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.lime : p.surfaceTint,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.limeDeep : p.faint,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surfaceTint,
        selectedColor: p.lime,
        labelStyle: AppType.label.copyWith(color: p.ink, fontSize: 13),
        shape: const StadiumBorder(),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.x3, vertical: Spacing.x2),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.strong,
        contentTextStyle: AppType.body.copyWith(color: p.onInk, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
        insetPadding: const EdgeInsets.all(Spacing.gutter),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: card,
        titleTextStyle: AppType.heading.copyWith(color: p.ink, fontSize: 20),
        contentTextStyle: AppType.body.copyWith(color: p.muted),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: p.surface,
        shape: sheet,
        showDragHandle: true,
        dragHandleColor: p.surfaceTint,
        dragHandleSize: const Size(40, 4),
        clipBehavior: Clip.antiAlias,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.lg)),
        textStyle: AppType.body.copyWith(color: p.ink),
      ),
      dividerTheme: DividerThemeData(color: p.surfaceTint, space: 1, thickness: 1),
      listTileTheme: ListTileThemeData(
        iconColor: p.muted,
        textColor: p.ink,
        titleTextStyle: AppType.bodyStrong.copyWith(color: p.ink),
        subtitleTextStyle: AppType.small.copyWith(color: p.muted),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.limeDeep,
        linearTrackColor: p.surfaceTint,
        circularTrackColor: Colors.transparent,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: card,
        headerBackgroundColor: p.lime,
        headerForegroundColor: p.onLime,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: p.surface,
        shape: card,
        hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
        dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: p.strong,
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        textStyle: AppType.small.copyWith(color: p.onInk),
      ),
    );
  }
}
