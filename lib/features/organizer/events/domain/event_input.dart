import '../../../../core/time/app_time.dart';
import '../../../../core/util/slugify.dart';

/// What the event form submits (API-CONTRACT #19/#20). Times are wall-clock
/// strings in [timezone], exactly as the web form sends them; the server
/// converts to UTC. Port of `eventInputSchema` in regista/lib/events.ts.
class EventInput {
  const EventInput({
    required this.title,
    this.slug,
    this.description,
    required this.startsAt,
    this.endsAt,
    required this.timezone,
    this.capacity,
    this.waitlistEnabled = false,
  });

  final String title;

  /// Optional link segment; the server slugifies the title when empty and
  /// appends -2, -3… on collision.
  final String? slug;
  final String? description;

  /// "YYYY-MM-DDTHH:mm" in [timezone].
  final String startsAt;
  final String? endsAt;
  final String timezone;

  /// Null = unlimited.
  final int? capacity;
  final bool waitlistEnabled;

  static const maxTitle = 140;
  static const maxDescription = 5000;
  static const maxCapacity = 1000000;

  static final _wallClock = RegExp(r'^\d{4}-\d{2}-\d{2}T([01]\d|2[0-3]):[0-5]\d$');

  static const dstGapMessage =
      "That time doesn't exist on that date in the chosen timezone — the "
      'clocks go forward. Pick a different time.';

  /// Field → message, empty when valid. Same messages as the server so the
  /// form reads the same whether the check happened here or there.
  Map<String, String> validate() {
    final errors = <String, String>{};
    final t = title.trim();
    if (t.length < 2) errors['title'] = 'Give the event a title.';
    if (t.length > maxTitle) errors['title'] = 'Keep the title under $maxTitle characters.';

    final s = (slug ?? '').trim();
    if (s.isNotEmpty && (s.length > 63 || !isValidSlugShape(s))) {
      errors['slug'] = 'Use 3–63 lowercase letters, numbers, or hyphens.';
    }
    if ((description ?? '').trim().length > maxDescription) {
      errors['description'] = 'Keep the description under $maxDescription characters.';
    }

    final zoneOk = AppTime.isValidTimeZone(timezone.trim());
    if (!zoneOk) errors['timezone'] = 'Pick a timezone for the event.';

    final start = startsAt.trim();
    if (start.isEmpty) {
      errors['startsAt'] = 'Pick a start date and time.';
    } else if (!_wallClock.hasMatch(start) || AppTime.fromWallClock(start, 'UTC') == null) {
      errors['startsAt'] = "That date doesn't look right.";
    } else if (zoneOk && !AppTime.wallClockExists(start, timezone.trim())) {
      errors['startsAt'] = dstGapMessage;
    }

    final end = (endsAt ?? '').trim();
    if (end.isNotEmpty) {
      if (!_wallClock.hasMatch(end) || AppTime.fromWallClock(end, 'UTC') == null) {
        errors['endsAt'] = "That date doesn't look right.";
      } else if (zoneOk && !AppTime.wallClockExists(end, timezone.trim())) {
        errors['endsAt'] = dstGapMessage;
      } else if (zoneOk && !errors.containsKey('startsAt')) {
        final a = AppTime.fromWallClock(start, timezone.trim());
        final b = AppTime.fromWallClock(end, timezone.trim());
        if (a != null && b != null && !b.isAfter(a)) {
          errors['endsAt'] = 'The end time must be after the start time.';
        }
      }
    }

    final c = capacity;
    if (c != null && (c <= 0 || c > maxCapacity)) {
      errors['capacity'] = 'Capacity must be a whole number above zero.';
    }
    return errors;
  }

  /// UTC instants, valid only after [validate] passes.
  DateTime get startsAtUtc => AppTime.fromWallClock(startsAt, timezone)!;
  DateTime? get endsAtUtc =>
      (endsAt ?? '').trim().isEmpty ? null : AppTime.fromWallClock(endsAt!, timezone);

  /// The link segment the server will start from.
  String get effectiveSlug {
    final s = (slug ?? '').trim();
    final base = s.isNotEmpty ? s : slugify(title);
    return base.isEmpty ? 'event' : base;
  }

  Map<String, dynamic> toJson() => {
        'title': title.trim(),
        if ((slug ?? '').trim().isNotEmpty) 'slug': slug!.trim(),
        if ((description ?? '').trim().isNotEmpty) 'description': description!.trim(),
        'startsAt': startsAt.trim(),
        if ((endsAt ?? '').trim().isNotEmpty) 'endsAt': endsAt!.trim(),
        'timezone': timezone.trim(),
        'capacity': capacity,
        'waitlistEnabled': waitlistEnabled,
      };
}
