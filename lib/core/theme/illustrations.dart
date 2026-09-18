/// Every illustration asset by name (see assets/illustrations/MANIFEST.md)
/// so screens never spell paths.
abstract final class Illustrations {
  static const _dir = 'assets/illustrations';

  static const onboarding1 = '$_dir/onboarding_1.webp';
  static const onboarding2 = '$_dir/onboarding_2.webp';
  static const onboarding3 = '$_dir/onboarding_3.webp';
  static const auth = '$_dir/hero_auth.webp';
  static const find = '$_dir/hero_find.webp';
  static const org = '$_dir/hero_org.webp';

  static const _events = [
    '$_dir/hero_event_1.webp',
    '$_dir/hero_event_2.webp',
  ];

  /// An event always gets the same hero: the set is picked by its slug.
  static String event(String slug) {
    var h = 0;
    for (final c in slug.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return _events[h % _events.length];
  }
}
