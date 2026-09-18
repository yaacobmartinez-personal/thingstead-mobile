// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamMember {

 String get id; String get userId; String? get name; String get email; Role get role; bool get isSelf; DateTime get joinedAt;
/// Create a copy of TeamMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamMemberCopyWith<TeamMember> get copyWith => _$TeamMemberCopyWithImpl<TeamMember>(this as TeamMember, _$identity);

  /// Serializes this TeamMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TeamMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamMember&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.isSelf, _this.isSelf) || other.isSelf == _this.isSelf)&&(identical(other.joinedAt, _this.joinedAt) || other.joinedAt == _this.joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TeamMember;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.name,_this.email,_this.role,_this.isSelf,_this.joinedAt);
}

@override
String toString() {
  final _this = this as TeamMember;
  return 'TeamMember(id: ${_this.id}, userId: ${_this.userId}, name: ${_this.name}, email: ${_this.email}, role: ${_this.role}, isSelf: ${_this.isSelf}, joinedAt: ${_this.joinedAt})';
}


}

/// @nodoc
abstract mixin class $TeamMemberCopyWith<$Res>  {
  factory $TeamMemberCopyWith(TeamMember value, $Res Function(TeamMember) _then) = _$TeamMemberCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? name, String email, Role role, bool isSelf, DateTime joinedAt
});




}
/// @nodoc
class _$TeamMemberCopyWithImpl<$Res>
    implements $TeamMemberCopyWith<$Res> {
  _$TeamMemberCopyWithImpl(this._self, this._then);

  final TeamMember _self;
  final $Res Function(TeamMember) _then;

/// Create a copy of TeamMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = freezed,Object? email = null,Object? role = null,Object? isSelf = null,Object? joinedAt = null,}) {
  return _then(TeamMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,isSelf: null == isSelf ? _self.isSelf : isSelf // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamMember].
extension TeamMemberPatterns on TeamMember {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamMember() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamMember value)  $default,){
final _that = this;
switch (_that) {
case _TeamMember():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamMember value)?  $default,){
final _that = this;
switch (_that) {
case _TeamMember() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? name,  String email,  Role role,  bool isSelf,  DateTime joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamMember() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.email,_that.role,_that.isSelf,_that.joinedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? name,  String email,  Role role,  bool isSelf,  DateTime joinedAt)  $default,) {final _that = this;
switch (_that) {
case _TeamMember():
return $default(_that.id,_that.userId,_that.name,_that.email,_that.role,_that.isSelf,_that.joinedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? name,  String email,  Role role,  bool isSelf,  DateTime joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _TeamMember() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.email,_that.role,_that.isSelf,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamMember extends TeamMember {
  const _TeamMember({required this.id, required this.userId, this.name, required this.email, required this.role, this.isSelf = false, required this.joinedAt}): super._();
  factory _TeamMember.fromJson(Map<String, dynamic> json) => _$TeamMemberFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? name;
@override final  String email;
@override final  Role role;
@override@JsonKey() final  bool isSelf;
@override final  DateTime joinedAt;

/// Create a copy of TeamMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamMemberCopyWith<_TeamMember> get copyWith => __$TeamMemberCopyWithImpl<_TeamMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamMember&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.isSelf, isSelf) || other.isSelf == isSelf)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,name,email,role,isSelf,joinedAt);
}

@override
String toString() {
    return 'TeamMember(id: $id, userId: $userId, name: $name, email: $email, role: $role, isSelf: $isSelf, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$TeamMemberCopyWith<$Res> implements $TeamMemberCopyWith<$Res> {
  factory _$TeamMemberCopyWith(_TeamMember value, $Res Function(_TeamMember) _then) = __$TeamMemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? name, String email, Role role, bool isSelf, DateTime joinedAt
});




}
/// @nodoc
class __$TeamMemberCopyWithImpl<$Res>
    implements _$TeamMemberCopyWith<$Res> {
  __$TeamMemberCopyWithImpl(this._self, this._then);

  final _TeamMember _self;
  final $Res Function(_TeamMember) _then;

/// Create a copy of TeamMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = freezed,Object? email = null,Object? role = null,Object? isSelf = null,Object? joinedAt = null,}) {
  return _then(_TeamMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,isSelf: null == isSelf ? _self.isSelf : isSelf // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TeamInvitation {

 String get id; String get email; Role get role; DateTime get expiresAt; bool get expired;
/// Create a copy of TeamInvitation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamInvitationCopyWith<TeamInvitation> get copyWith => _$TeamInvitationCopyWithImpl<TeamInvitation>(this as TeamInvitation, _$identity);

  /// Serializes this TeamInvitation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TeamInvitation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamInvitation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.expired, _this.expired) || other.expired == _this.expired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TeamInvitation;
  return Object.hash(runtimeType,_this.id,_this.email,_this.role,_this.expiresAt,_this.expired);
}

@override
String toString() {
  final _this = this as TeamInvitation;
  return 'TeamInvitation(id: ${_this.id}, email: ${_this.email}, role: ${_this.role}, expiresAt: ${_this.expiresAt}, expired: ${_this.expired})';
}


}

/// @nodoc
abstract mixin class $TeamInvitationCopyWith<$Res>  {
  factory $TeamInvitationCopyWith(TeamInvitation value, $Res Function(TeamInvitation) _then) = _$TeamInvitationCopyWithImpl;
@useResult
$Res call({
 String id, String email, Role role, DateTime expiresAt, bool expired
});




}
/// @nodoc
class _$TeamInvitationCopyWithImpl<$Res>
    implements $TeamInvitationCopyWith<$Res> {
  _$TeamInvitationCopyWithImpl(this._self, this._then);

  final TeamInvitation _self;
  final $Res Function(TeamInvitation) _then;

/// Create a copy of TeamInvitation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? role = null,Object? expiresAt = null,Object? expired = null,}) {
  return _then(TeamInvitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamInvitation].
extension TeamInvitationPatterns on TeamInvitation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamInvitation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamInvitation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamInvitation value)  $default,){
final _that = this;
switch (_that) {
case _TeamInvitation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamInvitation value)?  $default,){
final _that = this;
switch (_that) {
case _TeamInvitation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  Role role,  DateTime expiresAt,  bool expired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamInvitation() when $default != null:
return $default(_that.id,_that.email,_that.role,_that.expiresAt,_that.expired);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  Role role,  DateTime expiresAt,  bool expired)  $default,) {final _that = this;
switch (_that) {
case _TeamInvitation():
return $default(_that.id,_that.email,_that.role,_that.expiresAt,_that.expired);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  Role role,  DateTime expiresAt,  bool expired)?  $default,) {final _that = this;
switch (_that) {
case _TeamInvitation() when $default != null:
return $default(_that.id,_that.email,_that.role,_that.expiresAt,_that.expired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamInvitation implements TeamInvitation {
  const _TeamInvitation({required this.id, required this.email, required this.role, required this.expiresAt, this.expired = false});
  factory _TeamInvitation.fromJson(Map<String, dynamic> json) => _$TeamInvitationFromJson(json);

@override final  String id;
@override final  String email;
@override final  Role role;
@override final  DateTime expiresAt;
@override@JsonKey() final  bool expired;

/// Create a copy of TeamInvitation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamInvitationCopyWith<_TeamInvitation> get copyWith => __$TeamInvitationCopyWithImpl<_TeamInvitation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamInvitationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamInvitation&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expired, expired) || other.expired == expired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,role,expiresAt,expired);
}

@override
String toString() {
    return 'TeamInvitation(id: $id, email: $email, role: $role, expiresAt: $expiresAt, expired: $expired)';
}


}

/// @nodoc
abstract mixin class _$TeamInvitationCopyWith<$Res> implements $TeamInvitationCopyWith<$Res> {
  factory _$TeamInvitationCopyWith(_TeamInvitation value, $Res Function(_TeamInvitation) _then) = __$TeamInvitationCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, Role role, DateTime expiresAt, bool expired
});




}
/// @nodoc
class __$TeamInvitationCopyWithImpl<$Res>
    implements _$TeamInvitationCopyWith<$Res> {
  __$TeamInvitationCopyWithImpl(this._self, this._then);

  final _TeamInvitation _self;
  final $Res Function(_TeamInvitation) _then;

/// Create a copy of TeamInvitation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? role = null,Object? expiresAt = null,Object? expired = null,}) {
  return _then(_TeamInvitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TeamPage {

 List<TeamMember> get members; List<TeamInvitation> get invitations; int get adminCount;
/// Create a copy of TeamPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamPageCopyWith<TeamPage> get copyWith => _$TeamPageCopyWithImpl<TeamPage>(this as TeamPage, _$identity);

  /// Serializes this TeamPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TeamPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamPage&&const DeepCollectionEquality().equals(other.members, _this.members)&&const DeepCollectionEquality().equals(other.invitations, _this.invitations)&&(identical(other.adminCount, _this.adminCount) || other.adminCount == _this.adminCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TeamPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.members),const DeepCollectionEquality().hash(_this.invitations),_this.adminCount);
}

@override
String toString() {
  final _this = this as TeamPage;
  return 'TeamPage(members: ${_this.members}, invitations: ${_this.invitations}, adminCount: ${_this.adminCount})';
}


}

/// @nodoc
abstract mixin class $TeamPageCopyWith<$Res>  {
  factory $TeamPageCopyWith(TeamPage value, $Res Function(TeamPage) _then) = _$TeamPageCopyWithImpl;
@useResult
$Res call({
 List<TeamMember> members, List<TeamInvitation> invitations, int adminCount
});




}
/// @nodoc
class _$TeamPageCopyWithImpl<$Res>
    implements $TeamPageCopyWith<$Res> {
  _$TeamPageCopyWithImpl(this._self, this._then);

  final TeamPage _self;
  final $Res Function(TeamPage) _then;

/// Create a copy of TeamPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? members = null,Object? invitations = null,Object? adminCount = null,}) {
  return _then(TeamPage(
members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<TeamMember>,invitations: null == invitations ? _self.invitations : invitations // ignore: cast_nullable_to_non_nullable
as List<TeamInvitation>,adminCount: null == adminCount ? _self.adminCount : adminCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamPage].
extension TeamPagePatterns on TeamPage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamPage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamPage value)  $default,){
final _that = this;
switch (_that) {
case _TeamPage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamPage value)?  $default,){
final _that = this;
switch (_that) {
case _TeamPage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TeamMember> members,  List<TeamInvitation> invitations,  int adminCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamPage() when $default != null:
return $default(_that.members,_that.invitations,_that.adminCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TeamMember> members,  List<TeamInvitation> invitations,  int adminCount)  $default,) {final _that = this;
switch (_that) {
case _TeamPage():
return $default(_that.members,_that.invitations,_that.adminCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TeamMember> members,  List<TeamInvitation> invitations,  int adminCount)?  $default,) {final _that = this;
switch (_that) {
case _TeamPage() when $default != null:
return $default(_that.members,_that.invitations,_that.adminCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamPage extends TeamPage {
  const _TeamPage({ List<TeamMember> members = const <TeamMember>[],  List<TeamInvitation> invitations = const <TeamInvitation>[], this.adminCount = 0}): _members = members,_invitations = invitations,super._();
  factory _TeamPage.fromJson(Map<String, dynamic> json) => _$TeamPageFromJson(json);

 final  List<TeamMember> _members;
@override@JsonKey() List<TeamMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<TeamInvitation> _invitations;
@override@JsonKey() List<TeamInvitation> get invitations {
  if (_invitations is EqualUnmodifiableListView) return _invitations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invitations);
}

@override@JsonKey() final  int adminCount;

/// Create a copy of TeamPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamPageCopyWith<_TeamPage> get copyWith => __$TeamPageCopyWithImpl<_TeamPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamPage&&const DeepCollectionEquality().equals(other.members, _members)&&const DeepCollectionEquality().equals(other.invitations, _invitations)&&(identical(other.adminCount, adminCount) || other.adminCount == adminCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_invitations),adminCount);
}

@override
String toString() {
    return 'TeamPage(members: $members, invitations: $invitations, adminCount: $adminCount)';
}


}

/// @nodoc
abstract mixin class _$TeamPageCopyWith<$Res> implements $TeamPageCopyWith<$Res> {
  factory _$TeamPageCopyWith(_TeamPage value, $Res Function(_TeamPage) _then) = __$TeamPageCopyWithImpl;
@override @useResult
$Res call({
 List<TeamMember> members, List<TeamInvitation> invitations, int adminCount
});




}
/// @nodoc
class __$TeamPageCopyWithImpl<$Res>
    implements _$TeamPageCopyWith<$Res> {
  __$TeamPageCopyWithImpl(this._self, this._then);

  final _TeamPage _self;
  final $Res Function(_TeamPage) _then;

/// Create a copy of TeamPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? members = null,Object? invitations = null,Object? adminCount = null,}) {
  return _then(_TeamPage(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<TeamMember>,invitations: null == invitations ? _self._invitations : invitations // ignore: cast_nullable_to_non_nullable
as List<TeamInvitation>,adminCount: null == adminCount ? _self.adminCount : adminCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
