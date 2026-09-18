/// 4pt spacing scale, same as the Expo app's spacing(n) helper.
abstract final class Spacing {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;

  /// Screen gutter and card padding (docs/REDESIGN.md §1.3).
  static const double gutter = 20;
}

/// Corner radii (docs/REDESIGN.md §1.3).
abstract final class Radii {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double card = 24;
  static const double sheet = 28;
  static const double pill = 999;
}
