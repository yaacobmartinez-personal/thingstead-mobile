import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/time/app_time.dart';
import 'package:thingstead/features/organizer/events/domain/event_input.dart';

void main() {
  setUpAll(AppTime.ensureInitialized);

  EventInput input({
    String title = 'Summer Meetup',
    String? slug,
    String? description,
    String startsAt = '2026-08-15T18:00',
    String? endsAt,
    String timezone = 'Asia/Manila',
    int? capacity,
    bool waitlistEnabled = false,
  }) =>
      EventInput(
        title: title,
        slug: slug,
        description: description,
        startsAt: startsAt,
        endsAt: endsAt,
        timezone: timezone,
        capacity: capacity,
        waitlistEnabled: waitlistEnabled,
      );

  test('a complete input has no errors', () {
    expect(input(endsAt: '2026-08-15T20:00', capacity: 40).validate(), isEmpty);
  });

  test('title must be 2–140 characters', () {
    expect(input(title: ' ').validate()['title'], 'Give the event a title.');
    expect(input(title: 'x').validate()['title'], 'Give the event a title.');
    expect(input(title: 'a' * 141).validate()['title'], contains('under 140'));
    expect(input(title: 'ok').validate(), isNot(contains('title')));
  });

  test('slug is optional but must be well-formed when given', () {
    expect(input(slug: '').validate(), isNot(contains('slug')));
    expect(input(slug: 'summer-meetup').validate(), isNot(contains('slug')));
    expect(input(slug: 'Summer Meetup').validate()['slug'], isNotNull);
    expect(input(slug: 'ab').validate()['slug'], isNotNull);
  });

  test('description is capped at 5000', () {
    expect(input(description: 'a' * 5000).validate(), isNot(contains('description')));
    expect(input(description: 'a' * 5001).validate()['description'], contains('5000'));
  });

  test('start is required and must parse', () {
    expect(input(startsAt: '').validate()['startsAt'], 'Pick a start date and time.');
    expect(input(startsAt: 'tomorrow').validate()['startsAt'], "That date doesn't look right.");
    expect(input(startsAt: '2026-02-30T10:00').validate()['startsAt'], isNotNull);
  });

  test('a start inside a DST gap is rejected with the web message', () {
    // Clocks go 01:00 → 02:00 in London on 29 March 2026.
    final e = input(startsAt: '2026-03-29T01:30', timezone: 'Europe/London').validate();
    expect(e['startsAt'], EventInput.dstGapMessage);
  });

  test('end must be after start, in the event zone', () {
    expect(input(endsAt: '2026-08-15T18:00').validate()['endsAt'],
        'The end time must be after the start time.');
    expect(input(endsAt: '2026-08-15T17:00').validate()['endsAt'], isNotNull);
    expect(input(endsAt: '2026-08-15T18:01').validate(), isNot(contains('endsAt')));
    expect(input(endsAt: 'nope').validate()['endsAt'], "That date doesn't look right.");
  });

  test('timezone must be a known IANA name', () {
    expect(input(timezone: 'Mars/Olympus').validate()['timezone'],
        'Pick a timezone for the event.');
    expect(input(timezone: 'UTC').validate(), isNot(contains('timezone')));
  });

  test('capacity is 1..1,000,000 or null for unlimited', () {
    expect(input().validate(), isNot(contains('capacity')));
    expect(input(capacity: 0).validate()['capacity'],
        'Capacity must be a whole number above zero.');
    expect(input(capacity: 1000001).validate()['capacity'], isNotNull);
    expect(input(capacity: 1).validate(), isNot(contains('capacity')));
  });

  test('UTC instants come from the wall clock in the event zone', () {
    final i = input(endsAt: '2026-08-15T20:00');
    expect(i.startsAtUtc, DateTime.utc(2026, 8, 15, 10)); // Manila is UTC+8
    expect(i.endsAtUtc, DateTime.utc(2026, 8, 15, 12));
    expect(input().endsAtUtc, isNull);
  });

  test('effectiveSlug falls back to the slugified title', () {
    expect(input().effectiveSlug, 'summer-meetup');
    expect(input(slug: 'custom').effectiveSlug, 'custom');
    expect(input(title: '!!!').effectiveSlug, 'event');
  });

  test('toJson trims and omits empty optionals', () {
    final json = input(title: '  Summer Meetup ', slug: '', description: ' ', capacity: 40)
        .toJson();
    expect(json, {
      'title': 'Summer Meetup',
      'startsAt': '2026-08-15T18:00',
      'timezone': 'Asia/Manila',
      'capacity': 40,
      'waitlistEnabled': false,
    });
  });
}
