import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// The signed-in person, as the API describes them (`{id, email, name}`).
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? name,
    @Default(true) bool emailVerified,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// What to call them in the UI.
  String get displayName => (name ?? '').trim().isEmpty ? email : name!.trim();
}
