import '../../../../core/fake/fake_latency.dart';
import '../../../../core/fake/fake_membership.dart';
import '../../../../core/fake/fake_store.dart';
import '../../../../core/model/enums.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/time/clock.dart';
import '../domain/team.dart';
import '../domain/team_repository.dart';

/// Ports the team actions in regista/app/app/o/[slug]/team/actions.tsx:
/// ADMIN-only, rows matched on (id, tenantId), one pending invitation per
/// email, and the last-admin guard on demotion and removal.
class FakeTeamRepository implements TeamRepository {
  FakeTeamRepository(
    this._store,
    this._latency,
    this._currentUserId, {
    Clock? clock,
    bool Function()? offline,
  })  : _clock = clock ?? (() => DateTime.now().toUtc()),
        _offline = offline ?? (() => false);

  final FakeStore _store;
  final FakeLatency _latency;
  final String? Function() _currentUserId;
  final Clock _clock;
  final bool Function() _offline;

  static const invitationTtl = Duration(days: 7);

  Future<FakeMembershipContext> _ctx(String org) async {
    if (_offline()) throw ApiError.network();
    await _latency.wait();
    return requireMembership(_store, _currentUserId(), org, minRole: Role.admin);
  }

  int _adminCount(String tenantId) => _store.memberships
      .where((m) => m.tenantId == tenantId && m.role == Role.admin)
      .length;

  TeamMember _member(FakeMembership m, String selfId) {
    final u = _store.userById(m.userId);
    return TeamMember(
      id: m.id,
      userId: m.userId,
      name: u?.name,
      email: u?.email ?? '',
      role: m.role,
      isSelf: m.userId == selfId,
      joinedAt: m.createdAt,
    );
  }

  TeamInvitation _invitation(FakeInvitation i) => TeamInvitation(
        id: i.id,
        email: i.email,
        role: i.role,
        expiresAt: i.expiresAt,
        expired: i.expiresAt.isBefore(_clock()),
      );

  @override
  Future<TeamPage> get(String orgSlug) async {
    final ctx = await _ctx(orgSlug);
    final members = _store.memberships.where((m) => m.tenantId == ctx.tenant.id).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final invitations = _store.invitations
        .where((i) => i.tenantId == ctx.tenant.id && i.acceptedAt == null)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return TeamPage(
      members: [for (final m in members) _member(m, ctx.userId)],
      invitations: [for (final i in invitations) _invitation(i)],
      adminCount: _adminCount(ctx.tenant.id),
    );
  }

  @override
  Future<InviteResult> invite(String orgSlug, {required String email, required Role role}) async {
    final ctx = await _ctx(orgSlug);
    final normalized = email.trim().toLowerCase();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(normalized)) {
      throw ApiError.fromResponse(400, {
        'error': 'Check the highlighted fields.',
        'fieldErrors': {'email': 'Enter a valid email address.'},
      });
    }
    final existing = _store.userByEmail(normalized);
    if (existing != null && _store.membership(existing.id, ctx.tenant.id) != null) {
      return const InviteResult(alreadyMember: true);
    }
    // One pending invitation per address: a re-invite replaces the old one.
    _store.invitations.removeWhere(
      (i) => i.tenantId == ctx.tenant.id && i.email == normalized && i.acceptedAt == null,
    );
    final invitation = FakeInvitation(
      id: _store.nextId('inv'),
      tenantId: ctx.tenant.id,
      email: normalized,
      role: role,
      token: 'invite_${_store.nextId('tok')}',
      expiresAt: _clock().add(invitationTtl),
      createdAt: _clock(),
    );
    _store.invitations.add(invitation);
    _store.outbox.add(FakeEmail(
      to: normalized,
      kind: FakeEmailKind.invite,
      token: invitation.token,
      sentAt: _clock(),
    ));
    return InviteResult(invitation: _invitation(invitation));
  }

  @override
  Future<void> revoke(String orgSlug, String invitationId) async {
    final ctx = await _ctx(orgSlug);
    final before = _store.invitations.length;
    _store.invitations.removeWhere(
      (i) => i.id == invitationId && i.tenantId == ctx.tenant.id && i.acceptedAt == null,
    );
    if (_store.invitations.length == before) {
      throw ApiError.fromResponse(404, {'error': 'Not found'});
    }
  }

  FakeMembership _membership(FakeMembershipContext ctx, String membershipId) {
    final m = _store.memberships
        .where((m) => m.id == membershipId && m.tenantId == ctx.tenant.id)
        .firstOrNull;
    if (m == null) throw ApiError.fromResponse(404, {'error': 'Not found'});
    return m;
  }

  ApiError _lastAdmin() => ApiError.fromResponse(409, {
        'error': 'This is the only admin. Make someone else an admin first.',
        'reason': 'last_admin',
      });

  @override
  Future<TeamMember> changeRole(String orgSlug, String membershipId, Role role) async {
    final ctx = await _ctx(orgSlug);
    final m = _membership(ctx, membershipId);
    if (m.role == Role.admin && role != Role.admin && _adminCount(ctx.tenant.id) <= 1) {
      throw _lastAdmin();
    }
    m.role = role;
    return _member(m, ctx.userId);
  }

  @override
  Future<void> remove(String orgSlug, String membershipId) async {
    final ctx = await _ctx(orgSlug);
    final m = _membership(ctx, membershipId);
    if (m.role == Role.admin && _adminCount(ctx.tenant.id) <= 1) throw _lastAdmin();
    _store.memberships.remove(m);
  }
}
