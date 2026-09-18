import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error.dart';
import '../domain/org.dart';
import '../domain/orgs_repository.dart';

class RealOrgsRepository implements OrgsRepository {
  RealOrgsRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<Org>> list() async {
    final json = await _api.get('/mobile/orgs');
    final items = json['orgs'];
    if (items is! List) return const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(Org.fromJson)
        .toList(growable: false);
  }

  @override
  Future<SlugAvailability> availability(String slug) async {
    if (!isAvailable(Feature.createOrg, ApiMode.real)) throw ApiError.notAvailable();
    final json = await _api.get('/mobile/orgs/availability', query: {'slug': slug});
    return SlugAvailability(
      json['slug'] as String? ?? slug,
      available: json['available'] == true,
      problem: SlugAvailability.problemFromWire(json['reason'] as String?),
    );
  }

  @override
  Future<Org> create({required String name, required String slug}) async {
    if (!isAvailable(Feature.createOrg, ApiMode.real)) throw ApiError.notAvailable();
    final json = await _api.post('/mobile/orgs', body: {'name': name, 'slug': slug});
    return Org.fromJson(json['org'] as Map<String, dynamic>);
  }
}
