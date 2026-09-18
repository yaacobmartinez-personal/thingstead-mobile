import 'register_result.dart';

/// Registering the signed-in person for a public event (API-CONTRACT #13).
/// The email is the account's; only the name is sent.
abstract class RegistrationRepository {
  Future<RegisterResult> register(String orgSlug, String eventSlug, {required String name});
}
