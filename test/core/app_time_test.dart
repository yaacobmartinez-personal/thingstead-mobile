import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/time/app_time.dart';

/// Ported from regista/tests/time.test.mjs. Timezone handling fails silently:
/// a wrong offset just puts the event at the wrong time for everyone, so these
/// are the cases that were actually broken at some point on the web.
void main() {
  setUpAll(AppTime.ensureInitialized);

  group('fromWallClock', () {
    test('converts a wall-clock time to the right instant', () {
      const cases = [
        ('2026-09-15T18:00', 'Asia/Manila', '2026-09-15T10:00:00.000Z'),
        ('2026-09-15T18:00', 'Europe/London', '2026-09-15T17:00:00.000Z'), // BST
        ('2026-01-15T18:00', 'Europe/London', '2026-01-15T18:00:00.000Z'), // GMT
        ('2026-09-15T18:00', 'America/New_York', '2026-09-15T22:00:00.000Z'), // EDT
        ('2026-12-15T18:00', 'America/New_York', '2026-12-15T23:00:00.000Z'), // EST
        ('2026-06-01T12:00', 'UTC', '2026-06-01T12:00:00.000Z'),
      ];
      for (final (input, zone, expected) in cases) {
        expect(
          AppTime.fromWallClock(input, zone)!.toIso8601String(),
          expected,
          reason: '$input in $zone',
        );
      }
    });

    test('rejects malformed input and unknown zones', () {
      expect(AppTime.fromWallClock('2026-09-15', 'UTC'), isNull);
      expect(AppTime.fromWallClock('not a date', 'UTC'), isNull);
      expect(AppTime.fromWallClock('2026-09-15T18:00', 'Not/AZone'), isNull);
    });
  });

  test('round-trips through every offset shape, including half and quarter hours',
      () {
    const zones = [
      'UTC',
      'Asia/Manila',
      'Europe/London',
      'America/New_York',
      'America/Santiago',
      'Australia/Sydney',
      'Asia/Kolkata', // +05:30
      'Australia/Lord_Howe', // +10:30 / +11
      'Pacific/Chatham', // +12:45 / +13:45
    ];
    const times = ['2026-01-15T09:30', '2026-06-21T23:45', '2026-11-02T00:15'];

    for (final zone in zones) {
      for (final input in times) {
        final instant = AppTime.fromWallClock(input, zone)!;
        expect(
          AppTime.toWallClock(instant, zone),
          input,
          reason: '$input in $zone should survive a round trip',
        );
      }
    }
  });

  group('wallClockExists', () {
    test('rejects wall-clock times that do not exist', () {
      // The hour skipped when clocks go forward.
      const gaps = [
        ('2026-03-08T02:30', 'America/New_York'),
        ('2026-03-29T01:30', 'Europe/London'),
        ('2026-09-06T00:30', 'America/Santiago'),
      ];
      for (final (input, zone) in gaps) {
        expect(AppTime.wallClockExists(input, zone), isFalse,
            reason: '$input in $zone');
      }
    });

    test('accepts real times, including ones that happen twice', () {
      const real = [
        ('2026-03-08T03:30', 'America/New_York'), // just after the gap
        ('2026-09-15T18:00', 'America/New_York'), // ordinary
        ('2026-10-25T01:30', 'Europe/London'), // ambiguous: occurs twice
      ];
      for (final (input, zone) in real) {
        expect(AppTime.wallClockExists(input, zone), isTrue,
            reason: '$input in $zone');
      }
    });

    test('is false for garbage', () {
      expect(AppTime.wallClockExists('', 'UTC'), isFalse);
      expect(AppTime.wallClockExists('2026-09-15T18:00', ''), isFalse);
    });
  });

  group('formatting', () {
    final startsAt = DateTime.utc(2026, 9, 15, 22); // 18:00 in New York

    test("formats an event in its own zone, not the machine's", () {
      final formatted = AppTime.formatEventWhen(startsAt, null, 'America/New_York');
      expect(formatted, contains('18:00'));
      expect(formatted, contains('15 September 2026'));
      expect(formatted, contains('GMT-4'));
    });

    test('includes the end time and a positive offset', () {
      final ends = startsAt.add(const Duration(hours: 2));
      final formatted = AppTime.formatEventWhen(startsAt, ends, 'Asia/Manila');
      // 22:00Z is 06:00 the next day in Manila.
      expect(formatted, 'Wednesday, 16 September 2026 · 06:00–08:00 GMT+8');
    });

    test('labels half-hour zones and UTC', () {
      expect(AppTime.zoneLabel(startsAt, 'Asia/Kolkata'), 'GMT+5:30');
      expect(AppTime.zoneLabel(startsAt, 'UTC'), 'UTC');
    });

    test('formatEventDate matches the Expo card format', () {
      expect(
        AppTime.formatEventDate(startsAt, 'America/New_York'),
        'Tue, 15 Sep, 6:00 PM',
      );
    });

    test('formatTime is short', () {
      expect(AppTime.formatTime(startsAt, 'Asia/Manila'), '6:00 AM');
    });

    test('falls back to the device zone for an unknown zone', () {
      AppTime.deviceZone = 'Asia/Manila';
      addTearDown(() => AppTime.deviceZone = 'UTC');
      expect(AppTime.formatTime(startsAt, 'Not/AZone'), '6:00 AM');
    });
  });

  test('recognises valid and invalid zone names', () {
    expect(AppTime.isValidTimeZone('Europe/London'), isTrue);
    expect(AppTime.isValidTimeZone('UTC'), isTrue);
    expect(AppTime.isValidTimeZone('Not/AZone'), isFalse);
    expect(AppTime.isValidTimeZone(''), isFalse);
  });

  test('supportedTimeZones is a sorted, non-trivial list', () {
    final zones = AppTime.supportedTimeZones();
    expect(zones.length, greaterThan(300));
    expect(zones, contains('Asia/Manila'));
    expect(zones, orderedEquals([...zones]..sort()));
  });
}
