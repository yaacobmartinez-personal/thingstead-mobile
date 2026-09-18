import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error.dart';
import '../domain/register_result.dart';
import '../domain/registration_repository.dart';

class RealRegistrationRepository implements RegistrationRepository {
  RealRegistrationRepository(this._api);

  final ApiClient _api;

  @override
  Future<RegisterResult> register(String orgSlug, String eventSlug, {required String name}) async {
    if (!isAvailable(Feature.attendeeMode, ApiMode.real)) throw ApiError.notAvailable();
    final json = await _api.post(
      '/mobile/orgs/${Uri.encodeComponent(orgSlug)}/events/${Uri.encodeComponent(eventSlug)}/register',
      body: {'name': name.trim()},
    );
    return RegisterResult.fromJson(json);
  }
}
