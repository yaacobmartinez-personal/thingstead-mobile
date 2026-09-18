import 'package:flutter/material.dart';

/// Navy + gold palette, matched to the web app's brand tokens
/// (ported from regista/mobile/src/theme.ts).
abstract final class AppColors {
  static const navy = Color(0xFF26385C);
  static const navyDark = Color(0xFF1B2942);
  static const gold = Color(0xFFC6A45F);
  static const goldDeep = Color(0xFF8A6A2F);

  static const bg = Color(0xFFF4F5F8);
  static const card = Color(0xFFFFFFFF);
  static const border = Color(0xFFE3E6EC);

  static const text = Color(0xFF10151F);
  static const muted = Color(0xFF5B6472);
  static const faint = Color(0xFF8C94A3);

  static const success = Color(0xFF2F7D4F);
  static const successBg = Color(0xFFE7F3EC);
  static const danger = Color(0xFFB4232A);
  static const dangerBg = Color(0xFFFBE9EA);
  static const warn = Color(0xFF8A6A2F);
  static const warnBg = Color(0xFFF6EFDD);
  static const neutralBg = Color(0xFFEEF0F4);

  static const onNavy = Color(0xFFF3F5FB);
}
