import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/util/slugify.dart';

/// Ported from regista/tests/slug.test.mjs where applicable.
void main() {
  test('slugify collapses whitespace and punctuation', () {
    expect(slugify('  Summer  Meetup 2026! '), 'summer-meetup-2026');
    expect(slugify('Ünïcode & Stuff'), 'ncode-stuff');
    expect(slugify('a---b'), 'a-b');
    expect(slugify('x' * 80).length, 63);
  });

  test('slug shape: 3-63 chars, lowercase alphanumeric, internal hyphens', () {
    expect(isValidSlugShape('acme'), isTrue);
    expect(isValidSlugShape('a-b'), isTrue);
    expect(isValidSlugShape('ab'), isFalse);
    expect(isValidSlugShape('-ab'), isFalse);
    expect(isValidSlugShape('ab-'), isFalse);
    expect(isValidSlugShape('Acme'), isFalse);
    expect(isValidSlugShape('a' * 63), isTrue);
    expect(isValidSlugShape('a' * 64), isFalse);
  });

  test('reserved names are never usable', () {
    for (final r in ['app', 'api', 'home', 'www', 'admin', 'login', 'signup', 'privacy']) {
      expect(isReservedSlug(r), isTrue, reason: r);
      expect(isUsableSlug(r), isFalse, reason: r);
    }
    expect(isUsableSlug('acme'), isTrue);
  });
}
