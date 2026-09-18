import 'package:flutter/material.dart';

/// The color tokens from docs/REDESIGN.md §1.1, one instance per brightness.
/// Widgets read them through `context.palette`, never as constants, so a
/// screen looks right in both themes without knowing which one is active.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.brightness,
    required this.sage,
    required this.sageDeep,
    required this.surface,
    required this.surfaceTint,
    required this.lime,
    required this.limeDeep,
    required this.moss,
    required this.ink,
    required this.muted,
    required this.faint,
    required this.success,
    required this.successBg,
    required this.warn,
    required this.warnBg,
    required this.danger,
    required this.dangerBg,
    required this.shadow,
  });

  final Brightness brightness;

  /// Scaffold background and its gradient end.
  final Color sage;
  final Color sageDeep;

  /// Cards and sheets; inputs and secondary cards.
  final Color surface;
  final Color surfaceTint;

  /// The accent: primary buttons, selected states. Always with [ink] text.
  final Color lime;
  final Color limeDeep;

  /// Headings on light illustrations, strong accents.
  final Color moss;

  /// Text and strong buttons.
  final Color ink;
  final Color muted;
  final Color faint;

  final Color success;
  final Color successBg;
  final Color warn;
  final Color warnBg;
  final Color danger;
  final Color dangerBg;

  /// The one soft shadow for floating elements.
  final Color shadow;

  bool get isDark => brightness == Brightness.dark;

  /// Text on top of [lime] — dark in both themes (contrast).
  Color get onLime => const Color(0xFF171C14);

  /// Text on top of [ink] buttons.
  Color get onInk => isDark ? const Color(0xFF171C14) : const Color(0xFFEEF3E6);

  /// Strong button fill: ink on light, pale on dark.
  Color get strong => isDark ? const Color(0xFFEEF3E6) : ink;

  /// Scrim gradient over hero images so titles stay legible.
  List<Color> get scrim => const [Color(0x00171C14), Color(0x26171C14), Color(0xBF171C14)];

  static const light = AppPalette(
    brightness: Brightness.light,
    sage: Color(0xFFE8F0D9),
    sageDeep: Color(0xFFD7E4BE),
    surface: Color(0xFFFFFFFF),
    surfaceTint: Color(0xFFF4F8EC),
    lime: Color(0xFFC8DC96),
    limeDeep: Color(0xFF9DB85B),
    moss: Color(0xFF2F4A2A),
    ink: Color(0xFF171C14),
    muted: Color(0xFF6B7565),
    faint: Color(0xFF98A28F),
    success: Color(0xFF2F7D4F),
    successBg: Color(0xFFE3F1E7),
    warn: Color(0xFFB8892E),
    warnBg: Color(0xFFF7EED6),
    danger: Color(0xFFB4232A),
    dangerBg: Color(0xFFFBE9EA),
    shadow: Color(0x0F171C14),
  );

  static const dark = AppPalette(
    brightness: Brightness.dark,
    sage: Color(0xFF121711),
    sageDeep: Color(0xFF0D110C),
    surface: Color(0xFF1C231A),
    surfaceTint: Color(0xFF262F23),
    lime: Color(0xFFC8DC96),
    limeDeep: Color(0xFFAFCB6E),
    moss: Color(0xFF9DB85B),
    ink: Color(0xFFEEF3E6),
    muted: Color(0xFFA5AF9C),
    faint: Color(0xFF6F7A68),
    success: Color(0xFF6CC48E),
    successBg: Color(0xFF1B3324),
    warn: Color(0xFFE0B25A),
    warnBg: Color(0xFF3A2F17),
    danger: Color(0xFFF08A90),
    dangerBg: Color(0xFF3F1D1F),
    shadow: Color(0x40000000),
  );

  @override
  AppPalette copyWith({
    Brightness? brightness,
    Color? sage,
    Color? sageDeep,
    Color? surface,
    Color? surfaceTint,
    Color? lime,
    Color? limeDeep,
    Color? moss,
    Color? ink,
    Color? muted,
    Color? faint,
    Color? success,
    Color? successBg,
    Color? warn,
    Color? warnBg,
    Color? danger,
    Color? dangerBg,
    Color? shadow,
  }) =>
      AppPalette(
        brightness: brightness ?? this.brightness,
        sage: sage ?? this.sage,
        sageDeep: sageDeep ?? this.sageDeep,
        surface: surface ?? this.surface,
        surfaceTint: surfaceTint ?? this.surfaceTint,
        lime: lime ?? this.lime,
        limeDeep: limeDeep ?? this.limeDeep,
        moss: moss ?? this.moss,
        ink: ink ?? this.ink,
        muted: muted ?? this.muted,
        faint: faint ?? this.faint,
        success: success ?? this.success,
        successBg: successBg ?? this.successBg,
        warn: warn ?? this.warn,
        warnBg: warnBg ?? this.warnBg,
        danger: danger ?? this.danger,
        dangerBg: dangerBg ?? this.dangerBg,
        shadow: shadow ?? this.shadow,
      );

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      brightness: t < 0.5 ? brightness : other.brightness,
      sage: c(sage, other.sage),
      sageDeep: c(sageDeep, other.sageDeep),
      surface: c(surface, other.surface),
      surfaceTint: c(surfaceTint, other.surfaceTint),
      lime: c(lime, other.lime),
      limeDeep: c(limeDeep, other.limeDeep),
      moss: c(moss, other.moss),
      ink: c(ink, other.ink),
      muted: c(muted, other.muted),
      faint: c(faint, other.faint),
      success: c(success, other.success),
      successBg: c(successBg, other.successBg),
      warn: c(warn, other.warn),
      warnBg: c(warnBg, other.warnBg),
      danger: c(danger, other.danger),
      dangerBg: c(dangerBg, other.dangerBg),
      shadow: c(shadow, other.shadow),
    );
  }
}

extension PaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ??
      (Theme.of(this).brightness == Brightness.dark ? AppPalette.dark : AppPalette.light);
}
