import '../../../../core/network/api_client.dart';
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
}
