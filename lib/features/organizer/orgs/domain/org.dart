import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/enums.dart';

part 'org.freezed.dart';
part 'org.g.dart';

/// An organization the signed-in user belongs to, with their role in it.
/// Shape of `GET /mobile/orgs` items.
@freezed
abstract class Org with _$Org {
  const factory Org({
    required String slug,
    required String name,
    required Role role,
    @Default(PlanTier.free) PlanTier plan,
  }) = _Org;

  const Org._();

  factory Org.fromJson(Map<String, dynamic> json) => _$OrgFromJson(json);

  bool get isAdmin => role == Role.admin;
}
