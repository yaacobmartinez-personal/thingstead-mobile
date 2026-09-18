import 'package:intl/intl.dart';
import 'package:timezone/data/latest_10y.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Timezone handling for event times, ported from regista/lib/time.ts and
/// regista/mobile/src/format.ts.
///
/// An event happens in a place, so each event carries an IANA timezone.
/// Instants are stored in UTC; the zone decides how a wall-clock time typed by
/// an organizer maps to an instant, and how everyone sees it afterwards.
abstract final class AppTime {
  static bool _initialized = false;

  /// The device's IANA zone, set at boot from flutter_timezone. Used as the
  /// fallback when an event carries a zone this build doesn't know.
  static String deviceZone = 'UTC';

  static void ensureInitialized() {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    _initialized = true;
  }

  /// Spellings of UTC that the embedded database does not list by name.
  static const _utcAliases = {'UTC', 'Etc/UTC', 'Etc/GMT', 'GMT', 'Z'};

  static tz.Location? tryLocation(String zone) {
    if (zone.isEmpty) return null;
    if (_utcAliases.contains(zone)) return tz.UTC;
    ensureInitialized();
    try {
      return tz.getLocation(zone);
    } on tz.LocationNotFoundException {
      return null;
    }
  }

  static bool isValidTimeZone(String zone) => tryLocation(zone) != null;

  static tz.Location _locationOrFallback(String? zone) =>
      (zone == null ? null : tryLocation(zone)) ??
      tryLocation(deviceZone) ??
      tz.UTC;

  /// The instant [utc] as wall-clock time in [zone] (device zone if unknown).
  static tz.TZDateTime inZone(DateTime utc, String? zone) =>
      tz.TZDateTime.from(utc.toUtc(), _locationOrFallback(zone));

  /// "Sat, 15 Aug, 6:00 PM" — event cards and lists.
  static String formatEventDate(DateTime utc, String zone) =>
      DateFormat('EEE, d MMM, h:mm a').format(inZone(utc, zone));

  /// "6:04 PM" — check-in timestamps.
  static String formatTime(DateTime utc, [String? zone]) =>
      DateFormat('h:mm a').format(inZone(utc, zone));

  /// Short zone label, e.g. "GMT+8", "GMT+5:30", "UTC".
  static String zoneLabel(DateTime utc, String zone) {
    final local = inZone(utc, zone);
    final offset = local.timeZoneOffset;
    if (offset == Duration.zero) {
      return _utcAliases.contains(local.location.name) ? 'UTC' : 'GMT';
    }
    final sign = offset.isNegative ? '-' : '+';
    final abs = offset.abs();
    final hours = abs.inHours;
    final minutes = abs.inMinutes.remainder(60);
    return minutes == 0
        ? 'GMT$sign$hours'
        : 'GMT$sign$hours:${minutes.toString().padLeft(2, '0')}';
  }

  /// The canonical way to present an event's date and time — the same shape as
  /// the public web page and the confirmation email:
  /// "Saturday, 15 August 2026 · 18:00–20:00 GMT+8".
  static String formatEventWhen(DateTime startsAt, DateTime? endsAt, String zone) {
    final start = inZone(startsAt, zone);
    final date = DateFormat('EEEE, d MMMM y').format(start);
    final startTime = DateFormat('HH:mm').format(start);
    final label = zoneLabel(startsAt, zone);
    if (endsAt == null) return '$date · $startTime $label';
    final endTime = DateFormat('HH:mm').format(inZone(endsAt, zone));
    return '$date · $startTime–$endTime $label';
  }

  static final RegExp _wallClock =
      RegExp(r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}))?$');

  /// Convert a wall-clock value ("YYYY-MM-DDTHH:mm") interpreted in [zone] into
  /// the corresponding UTC instant. Returns null for malformed input or an
  /// unknown zone.
  static DateTime? fromWallClock(String input, String zone) {
    final m = _wallClock.firstMatch(input.trim());
    final location = tryLocation(zone);
    if (m == null || location == null) return null;
    final local = tz.TZDateTime(
      location,
      int.parse(m[1]!),
      int.parse(m[2]!),
      int.parse(m[3]!),
      int.parse(m[4]!),
      int.parse(m[5]!),
      int.parse(m[6] ?? '0'),
    );
    return local.toUtc();
  }

  /// Render a UTC instant as a wall-clock value ("YYYY-MM-DDTHH:mm") in [zone].
  static String toWallClock(DateTime utc, String zone) {
    final local = inZone(utc, zone);
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)}'
        'T${two(local.hour)}:${two(local.minute)}';
  }

  /// Whether a wall-clock time actually occurs in a zone. On the morning clocks
  /// go forward an hour never happens; converting it anyway lands on a
  /// different time, so a round trip is the reliable test.
  static bool wallClockExists(String input, String zone) {
    final instant = fromWallClock(input, zone);
    if (instant == null) return false;
    final normalized =
        input.trim().length > 16 ? input.trim().substring(0, 16) : input.trim();
    return toWallClock(instant, zone) == normalized;
  }

  /// Every zone this build knows, for the event editor's picker.
  static List<String> supportedTimeZones() {
    ensureInitialized();
    final names = tz.timeZoneDatabase.locations.keys.toList()..sort();
    return names;
  }
}
