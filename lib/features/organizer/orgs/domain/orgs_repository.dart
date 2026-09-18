import 'org.dart';

/// Why an address cannot be used (API-CONTRACT #34).
enum SlugProblem { invalid, reserved, taken }

class SlugAvailability {
  const SlugAvailability(this.slug, {required this.available, this.problem});

  final String slug;
  final bool available;
  final SlugProblem? problem;

  /// The web's wording for each problem, so the app and the site agree.
  String? get message => switch (problem) {
        null => null,
        SlugProblem.reserved => "That address isn't available.",
        SlugProblem.taken => 'That address is already taken.',
        SlugProblem.invalid =>
          'Use 3–63 letters, numbers, or hyphens (start and end with a letter or number).',
      };

  static SlugProblem? problemFromWire(String? raw) => switch (raw) {
        'reserved' => SlugProblem.reserved,
        'taken' => SlugProblem.taken,
        'invalid' => SlugProblem.invalid,
        _ => null,
      };
}

abstract class OrgsRepository {
  /// E2 — the caller's ACTIVE organizations, in membership order. Also the
  /// cheapest way to validate a token until `GET /mobile/me` exists.
  Future<List<Org>> list();

  /// #34 — live check for the address field.
  Future<SlugAvailability> availability(String slug);

  /// #35 — create an organization; the caller becomes its ADMIN.
  Future<Org> create({required String name, required String slug});
}
