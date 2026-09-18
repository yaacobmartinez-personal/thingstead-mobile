import 'package:flutter/material.dart';

/// Manrope type scale (docs/REDESIGN.md §1.2). Manrope ships as a variable
/// font, so every style carries the `wght` axis as well as [FontWeight] —
/// Flutter picks the axis value, other tooling reads the weight.
abstract final class AppType {
  static const family = 'Manrope';

  static TextStyle _s(
    double size,
    int weight, {
    double? spacing,
    double? height,
    Color? color,
  }) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        fontWeight: FontWeight.values[(weight ~/ 100) - 1],
        fontVariations: [FontVariation.weight(weight.toDouble())],
        letterSpacing: spacing,
        height: height,
        color: color,
      );

  /// Onboarding and hero titles.
  static final display = _s(32, 800, spacing: -0.5, height: 1.15);

  /// Screen titles inside sheets.
  static final title = _s(24, 800, spacing: -0.3, height: 1.2);

  /// Card titles, section headings.
  static final heading = _s(18, 700, height: 1.3);

  /// Descriptions, list text.
  static final body = _s(15, 500, height: 1.5);
  static final bodyStrong = _s(15, 700, height: 1.5);
  static final small = _s(13, 500, height: 1.4);

  /// Buttons, chips.
  static final label = _s(14, 700, spacing: 0.1);

  /// "MEMBERS (3)", stat labels — uppercase by convention at the call site.
  static final caption = _s(12, 700, spacing: 0.6);
  static final captionQuiet = _s(12, 600, height: 1.35);

  /// Stats and date tiles.
  static final numeral = _s(28, 800, spacing: -0.5).copyWith(
    fontFeatures: const [FontFeature.tabularFigures()],
  );
  static final numeralSmall = _s(20, 800, spacing: -0.3).copyWith(
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  /// A Material [TextTheme] built from the scale so default widgets
  /// (dialogs, list tiles, app bars) speak the same language.
  static TextTheme textTheme(Color ink, Color muted) => TextTheme(
        displayLarge: display.copyWith(color: ink),
        displayMedium: display.copyWith(color: ink, fontSize: 28),
        headlineLarge: title.copyWith(color: ink),
        headlineMedium: title.copyWith(color: ink, fontSize: 22),
        headlineSmall: heading.copyWith(color: ink, fontSize: 20),
        titleLarge: heading.copyWith(color: ink),
        titleMedium: bodyStrong.copyWith(color: ink),
        titleSmall: label.copyWith(color: ink),
        bodyLarge: body.copyWith(color: ink, fontSize: 16),
        bodyMedium: body.copyWith(color: ink),
        bodySmall: small.copyWith(color: muted),
        labelLarge: label.copyWith(color: ink),
        labelMedium: captionQuiet.copyWith(color: muted),
        labelSmall: caption.copyWith(color: muted, fontSize: 11),
      );
}
