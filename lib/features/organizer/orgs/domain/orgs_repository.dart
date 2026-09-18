import 'org.dart';

abstract class OrgsRepository {
  /// E2 — the caller's ACTIVE organizations, in membership order. Also the
  /// cheapest way to validate a token until `GET /mobile/me` exists.
  Future<List<Org>> list();
}
