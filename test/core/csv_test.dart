import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/util/csv.dart';

/// Ported from regista/tests/csv.test.mjs. This escaping is a security
/// control, so it is tested against the payloads it exists to stop.
void main() {
  test('neutralises formula triggers', () {
    const payloads = {
      "=cmd|'/c calc'!A1": "'=cmd|'/c calc'!A1",
      '+1-555-0100': "'+1-555-0100",
      '-2+3': "'-2+3",
      '@SUM(A1:A9)': "'@SUM(A1:A9)",
      '\tstartswithtab': "'\tstartswithtab",
    };
    payloads.forEach((input, expected) => expect(escapeCsvCell(input), expected, reason: input));
  });

  test('leaves ordinary values alone', () {
    expect(escapeCsvCell('Priya Raman'), 'Priya Raman');
    expect(escapeCsvCell('priya@example.com'), 'priya@example.com');
    expect(escapeCsvCell(''), '');
    expect(escapeCsvCell(null), '');
  });

  test('quotes values containing delimiters, quotes or newlines', () {
    expect(escapeCsvCell('Quote "Quinn", Jr'), '"Quote ""Quinn"", Jr"');
    expect(escapeCsvCell('line one\nline two'), '"line one\nline two"');
    expect(escapeCsvCell('a,b'), '"a,b"');
  });

  test('applies both treatments in the right order', () {
    expect(escapeCsvCell('=cmd|x,y"z'), '"\'=cmd|x,y""z"');
  });

  test('builds a well-formed document', () {
    final csv = toCsv(
      ['Name', 'Email'],
      [
        ['Priya Raman', 'priya@example.com'],
        ['=danger', 'x@example.com'],
      ],
    );
    expect(csv, "Name,Email\r\nPriya Raman,priya@example.com\r\n'=danger,x@example.com\r\n");
  });

  test('produces safe filenames', () {
    expect(filenameSlug('Acme Summer Meetup'), 'acme-summer-meetup');
    expect(filenameSlug('../../etc/passwd'), 'etc-passwd');
    expect(filenameSlug(''), 'export');
    expect(filenameSlug('!!!'), 'export');
  });
}
