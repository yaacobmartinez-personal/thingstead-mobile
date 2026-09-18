import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../domain/org.dart';
import '../domain/orgs_repository.dart';

class FakeOrgsRepository implements OrgsRepository {
  FakeOrgsRepository(this._store, this._latency, this._currentUserId);

  final FakeStore _store;
  final FakeLatency _latency;
  final String? Function() _currentUserId;

  @override
  Future<List<Org>> list() async {
    await _latency.wait();
    final userId = _currentUserId();
    if (userId == null || _store.userById(userId) == null) {
      throw ApiError.fromResponse(401, null);
    }
    final memberships = _store.membershipsOf(userId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return [
      for (final m in memberships)
        if (_store.tenantById(m.tenantId) case final t?
            when t.status == TenantStatus.active)
          Org(slug: t.slug, name: t.name, role: m.role, plan: t.plan),
    ];
  }
}
