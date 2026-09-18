// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SignedOut value)?  signedOut,TResult Function( SignedIn value)?  signedIn,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SignedOut() when signedOut != null:
return signedOut(_that);case SignedIn() when signedIn != null:
return signedIn(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SignedOut value)  signedOut,required TResult Function( SignedIn value)  signedIn,}){
final _that = this;
switch (_that) {
case SignedOut():
return signedOut(_that);case SignedIn():
return signedIn(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SignedOut value)?  signedOut,TResult? Function( SignedIn value)?  signedIn,}){
final _that = this;
switch (_that) {
case SignedOut() when signedOut != null:
return signedOut(_that);case SignedIn() when signedIn != null:
return signedIn(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( SignOutReason? reason)?  signedOut,TResult Function( User user,  String token,  DateTime expiresAt,  List<Org> orgs,  bool orgsFresh)?  signedIn,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SignedOut() when signedOut != null:
return signedOut(_that.reason);case SignedIn() when signedIn != null:
return signedIn(_that.user,_that.token,_that.expiresAt,_that.orgs,_that.orgsFresh);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( SignOutReason? reason)  signedOut,required TResult Function( User user,  String token,  DateTime expiresAt,  List<Org> orgs,  bool orgsFresh)  signedIn,}) {final _that = this;
switch (_that) {
case SignedOut():
return signedOut(_that.reason);case SignedIn():
return signedIn(_that.user,_that.token,_that.expiresAt,_that.orgs,_that.orgsFresh);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( SignOutReason? reason)?  signedOut,TResult? Function( User user,  String token,  DateTime expiresAt,  List<Org> orgs,  bool orgsFresh)?  signedIn,}) {final _that = this;
switch (_that) {
case SignedOut() when signedOut != null:
return signedOut(_that.reason);case SignedIn() when signedIn != null:
return signedIn(_that.user,_that.token,_that.expiresAt,_that.orgs,_that.orgsFresh);case _:
  return null;

}
}

}

/// @nodoc


class SignedOut extends AuthState {
  const SignedOut({this.reason}): super._();
  

 final  SignOutReason? reason;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignedOutCopyWith<SignedOut> get copyWith => _$SignedOutCopyWithImpl<SignedOut>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SignedOut&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,reason);
}

@override
String toString() {
    return 'AuthState.signedOut(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $SignedOutCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $SignedOutCopyWith(SignedOut value, $Res Function(SignedOut) _then) = _$SignedOutCopyWithImpl;
@useResult
$Res call({
 SignOutReason? reason
});




}
/// @nodoc
class _$SignedOutCopyWithImpl<$Res>
    implements $SignedOutCopyWith<$Res> {
  _$SignedOutCopyWithImpl(this._self, this._then);

  final SignedOut _self;
  final $Res Function(SignedOut) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = freezed,}) {
  return _then(SignedOut(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as SignOutReason?,
  ));
}


}

/// @nodoc


class SignedIn extends AuthState {
  const SignedIn({required this.user, required this.token, required this.expiresAt,  List<Org> orgs = const <Org>[], this.orgsFresh = false}): _orgs = orgs,super._();
  

 final  User user;
 final  String token;
 final  DateTime expiresAt;
/// Org memberships. Restored from the last session at boot, then
/// refreshed from the server; [orgsFresh] says which.
 final  List<Org> _orgs;
/// Org memberships. Restored from the last session at boot, then
/// refreshed from the server; [orgsFresh] says which.
@JsonKey() List<Org> get orgs {
  if (_orgs is EqualUnmodifiableListView) return _orgs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orgs);
}

@JsonKey() final  bool orgsFresh;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignedInCopyWith<SignedIn> get copyWith => _$SignedInCopyWithImpl<SignedIn>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SignedIn&&(identical(other.user, user) || other.user == user)&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other.orgs, _orgs)&&(identical(other.orgsFresh, orgsFresh) || other.orgsFresh == orgsFresh));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user,token,expiresAt,const DeepCollectionEquality().hash(_orgs),orgsFresh);
}

@override
String toString() {
    return 'AuthState.signedIn(user: $user, token: $token, expiresAt: $expiresAt, orgs: $orgs, orgsFresh: $orgsFresh)';
}


}

/// @nodoc
abstract mixin class $SignedInCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $SignedInCopyWith(SignedIn value, $Res Function(SignedIn) _then) = _$SignedInCopyWithImpl;
@useResult
$Res call({
 User user, String token, DateTime expiresAt, List<Org> orgs, bool orgsFresh
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$SignedInCopyWithImpl<$Res>
    implements $SignedInCopyWith<$Res> {
  _$SignedInCopyWithImpl(this._self, this._then);

  final SignedIn _self;
  final $Res Function(SignedIn) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? token = null,Object? expiresAt = null,Object? orgs = null,Object? orgsFresh = null,}) {
  return _then(SignedIn(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,orgs: null == orgs ? _self._orgs : orgs // ignore: cast_nullable_to_non_nullable
as List<Org>,orgsFresh: null == orgsFresh ? _self.orgsFresh : orgsFresh // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
