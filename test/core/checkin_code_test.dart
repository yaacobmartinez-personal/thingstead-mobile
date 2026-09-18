import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/util/checkin_code.dart';

void main() {
  test('extracts c from the ticket URL', () {
    expect(
      extractCheckInToken('https://app.thingstead.pro/checkin?c=AbC-123_x'),
      'AbC-123_x',
    );
  });

  test('accepts a bare token, trimmed', () {
    expect(extractCheckInToken('  AbC-123_x \n'), 'AbC-123_x');
  });

  test('a URL without c is returned as-is (the server will say invalid)', () {
    expect(
      extractCheckInToken('https://app.thingstead.pro/checkin'),
      'https://app.thingstead.pro/checkin',
    );
  });

  test('empty is null', () {
    expect(extractCheckInToken(''), isNull);
    expect(extractCheckInToken('   '), isNull);
  });
}
