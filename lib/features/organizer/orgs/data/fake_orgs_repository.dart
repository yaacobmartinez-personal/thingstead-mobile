import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../../../../core/util/slugify.dart';
import '../domain/org.dart';
import '../domain/orgs_repository.dart';

class FakeOrgsRepository implements OrgsRepository {
  FakeOrgsRepository(
    this._store,
    this._latency,
    this._currentUserId, {
    Clock? clock,
  }) : _clock = clock ?? (() => DateTime.now().toUtc());

  final FakeStore _store;
  final FakeLatency _latency;
  final String? Function() _currentUserId;
  final Clock _clock;

  String _requireUser() {
    final userId = _currentUserId();
    if (userId == null || _store.userById(userId) == null) {
      throw ApiError.fromResponse(401, null);
    }
    return userId;
  }

  @override
  Future<List<Org>> list() async {
    await _latency.wait();
    final userId = _requireUser();
    final memberships = _store.membershipsOf(userId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return [
      for (final m in memberships)
        if (_store.tenantById(m.tenantId) case final t?
            when t.status == TenantStatus.active)
          Org(slug: t.slug, name: t.name, role: m.role, plan: t.plan),
    ];
  }

  SlugAvailability _check(String raw) {
    final slug = raw.trim().toLowerCase();
    if (isReservedSlug(slug)) {
      return SlugAvailability(slug, available: false, problem: SlugProblem.reserved);
    }
    if (!isValidSlugShape(slug)) {
      return SlugAvailability(slug, available: false, problem: SlugProblem.invalid);
    }
    if (_store.tenantBySlug(slug) != null) {
      return SlugAvailability(slug, available: false, problem: SlugProblem.taken);
    }
    return SlugAvailability(slug, available: true);
  }

  @override
  Future<SlugAvailability> availability(String slug) async {
    await _latency.wait();
    _requireUser();
    if (slug.trim().isEmpty) {
      throw ApiError.fromResponse(400, {'error': 'Missing slug.'});
    }
    return _check(slug);
  }

  @override
  Future<Org> create({required String name, required String slug}) async {
    await _latency.wait();
    final userId = _requireUser();
    final errors = <String, String>{};
    final cleanName = name.trim();
    if (cleanName.length < 2) errors['name'] = 'Organization name is too short.';
    if (cleanName.length > 60) errors['name'] = 'Organization name is too long.';
    final check = _check(slug);
    if (!check.available) errors['slug'] = check.message!;
    if (errors.isNotEmpty) {
      throw ApiError.fromResponse(400, {
        'error': 'Check the highlighted fields.',
        'fieldErrors': errors,
      });
    }
    final now = _clock();
    final tenant = FakeTenant(
      id: _store.nextId('t'),
      slug: check.slug,
      name: cleanName,
      createdAt: now,
    );
    _store.tenants.add(tenant);
    _store.memberships.add(FakeMembership(
      id: _store.nextId('m'),
      userId: userId,
      tenantId: tenant.id,
      role: Role.admin,
      createdAt: now,
    ));
    return Org(slug: tenant.slug, name: tenant.name, role: Role.admin, plan: tenant.plan);
  }
}
