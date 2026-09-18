// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The org's members and pending invitations, with the ADMIN-only actions
/// (API-CONTRACT #28–#32). Every action refetches the page afterwards; the
/// server is the source of truth for the last-admin rule.

@ProviderFor(TeamController)
final teamControllerProvider = TeamControllerFamily._();

/// The org's members and pending invitations, with the ADMIN-only actions
/// (API-CONTRACT #28–#32). Every action refetches the page afterwards; the
/// server is the source of truth for the last-admin rule.
final class TeamControllerProvider
    extends $AsyncNotifierProvider<TeamController, TeamPage> {
  /// The org's members and pending invitations, with the ADMIN-only actions
  /// (API-CONTRACT #28–#32). Every action refetches the page afterwards; the
  /// server is the source of truth for the last-admin rule.
  TeamControllerProvider._({
    required TeamControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'teamControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$teamControllerHash();

  @override
  String toString() {
    return r'teamControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TeamController create() => TeamController();

  @override
  bool operator ==(Object other) {
    return other is TeamControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$teamControllerHash() => r'ef0d349dd2526052660fa6b0cad06e2015309db8';

/// The org's members and pending invitations, with the ADMIN-only actions
/// (API-CONTRACT #28–#32). Every action refetches the page afterwards; the
/// server is the source of truth for the last-admin rule.

final class TeamControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TeamController,
          AsyncValue<TeamPage>,
          TeamPage,
          FutureOr<TeamPage>,
          String
        > {
  TeamControllerFamily._()
    : super(
        retry: null,
        name: r'teamControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The org's members and pending invitations, with the ADMIN-only actions
  /// (API-CONTRACT #28–#32). Every action refetches the page afterwards; the
  /// server is the source of truth for the last-admin rule.

  TeamControllerProvider call(String org) =>
      TeamControllerProvider._(argument: org, from: this);

  @override
  String toString() => r'teamControllerProvider';
}

/// The org's members and pending invitations, with the ADMIN-only actions
/// (API-CONTRACT #28–#32). Every action refetches the page afterwards; the
/// server is the source of truth for the last-admin rule.

abstract class _$TeamController extends $AsyncNotifier<TeamPage> {
  late final _$args = ref.$arg as String;
  String get org => _$args;

  FutureOr<TeamPage> build(String org);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TeamPage>, TeamPage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TeamPage>, TeamPage>,
              AsyncValue<TeamPage>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
