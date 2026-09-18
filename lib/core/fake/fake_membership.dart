import '../model/enums.dart';
import '../network/api_error.dart';
import 'fake_store.dart';

/// The caller's resolved membership, like `MobileContext` on the server.
class FakeMembershipContext {
  const FakeMembershipContext({
    required this.userId,
    required this.tenant,
    required this.role,
  });

  final String userId;
  final FakeTenant tenant;
  final Role role;
}

/// Port of `resolveMobileMembership` (regista/lib/mobile-auth.ts): 401 for
/// no session, 403 for non-member, inactive tenant, or insufficient role —
/// never 404, so tenants are not enumerable.
FakeMembershipContext requireMembership(
  FakeStore store,
  String? userId,
  String slug, {
  Role? minRole,
}) {
  if (userId == null || store.userById(userId) == null) {
    throw ApiError.fromResponse(401, null);
  }
  final tenant = store.tenantBySlug(slug);
  final membership = tenant == null ? null : store.membership(userId, tenant.id);
  if (tenant == null ||
      membership == null ||
      tenant.status != TenantStatus.active ||
      (minRole != null && !membership.role.atLeast(minRole))) {
    throw ApiError.fromResponse(403, {'error': 'Forbidden'});
  }
  return FakeMembershipContext(userId: userId, tenant: tenant, role: membership.role);
}
