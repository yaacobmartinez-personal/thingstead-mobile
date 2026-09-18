import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'spacing.dart';

/// Light theme only for v1 (the Expo app was userInterfaceStyle: light).
/// Tokens live in [AppColors] so a dark scheme can be added without touching
/// widgets.
abstract final class AppTheme {
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.navy,
      onPrimary: AppColors.onNavy,
      primaryContainer: AppColors.navyDark,
      onPrimaryContainer: AppColors.onNavy,
      secondary: AppColors.gold,
      onSecondary: AppColors.navyDark,
      secondaryContainer: AppColors.warnBg,
      onSecondaryContainer: AppColors.goldDeep,
      tertiary: AppColors.goldDeep,
      onTertiary: AppColors.onNavy,
      error: AppColors.danger,
      onError: Colors.white,
      errorContainer: AppColors.dangerBg,
      onErrorContainer: AppColors.danger,
      surface: AppColors.card,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.muted,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
      surfaceContainerHighest: AppColors.neutralBg,
      surfaceContainerLow: AppColors.bg,
      inverseSurface: AppColors.navyDark,
      onInverseSurface: AppColors.onNavy,
      inversePrimary: AppColors.gold,
      shadow: Colors.black,
      scrim: Colors.black,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bg,
    );

    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.md),
    );
    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.onNavy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.onNavy,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.warnBg,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? AppColors.navy
                : AppColors.muted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.navy
                : AppColors.muted,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: rounded.copyWith(
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.x4,
          vertical: Spacing.x3,
        ),
        border: inputBorder(AppColors.border),
        enabledBorder: inputBorder(AppColors.border),
        focusedBorder: inputBorder(AppColors.navy, 1.5),
        errorBorder: inputBorder(AppColors.danger),
        focusedErrorBorder: inputBorder(AppColors.danger, 1.5),
        labelStyle: const TextStyle(color: AppColors.muted),
        hintStyle: const TextStyle(color: AppColors.faint),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.onNavy,
          minimumSize: const Size.fromHeight(48),
          shape: rounded,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: AppColors.border),
          shape: rounded,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.navy),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.navyDark,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.navyDark,
        contentTextStyle: TextStyle(color: AppColors.onNavy),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, space: 1),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.muted,
        textColor: AppColors.text,
      ),
    );
  }
}
