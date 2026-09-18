// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'org.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Org {

 String get slug; String get name; Role get role; PlanTier get plan;
/// Create a copy of Org
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrgCopyWith<Org> get copyWith => _$OrgCopyWithImpl<Org>(this as Org, _$identity);

  /// Serializes this Org to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Org;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Org&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.plan, _this.plan) || other.plan == _this.plan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Org;
  return Object.hash(runtimeType,_this.slug,_this.name,_this.role,_this.plan);
}

@override
String toString() {
  final _this = this as Org;
  return 'Org(slug: ${_this.slug}, name: ${_this.name}, role: ${_this.role}, plan: ${_this.plan})';
}


}

/// @nodoc
abstract mixin class $OrgCopyWith<$Res>  {
  factory $OrgCopyWith(Org value, $Res Function(Org) _then) = _$OrgCopyWithImpl;
@useResult
$Res call({
 String slug, String name, Role role, PlanTier plan
});




}
/// @nodoc
class _$OrgCopyWithImpl<$Res>
    implements $OrgCopyWith<$Res> {
  _$OrgCopyWithImpl(this._self, this._then);

  final Org _self;
  final $Res Function(Org) _then;

/// Create a copy of Org
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? name = null,Object? role = null,Object? plan = null,}) {
  return _then(Org(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PlanTier,
  ));
}

}


/// Adds pattern-matching-related methods to [Org].
extension OrgPatterns on Org {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Org value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Org() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Org value)  $default,){
final _that = this;
switch (_that) {
case _Org():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Org value)?  $default,){
final _that = this;
switch (_that) {
case _Org() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String name,  Role role,  PlanTier plan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Org() when $default != null:
return $default(_that.slug,_that.name,_that.role,_that.plan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String name,  Role role,  PlanTier plan)  $default,) {final _that = this;
switch (_that) {
case _Org():
return $default(_that.slug,_that.name,_that.role,_that.plan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String name,  Role role,  PlanTier plan)?  $default,) {final _that = this;
switch (_that) {
case _Org() when $default != null:
return $default(_that.slug,_that.name,_that.role,_that.plan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Org extends Org {
  const _Org({required this.slug, required this.name, required this.role, this.plan = PlanTier.free}): super._();
  factory _Org.fromJson(Map<String, dynamic> json) => _$OrgFromJson(json);

@override final  String slug;
@override final  String name;
@override final  Role role;
@override@JsonKey() final  PlanTier plan;

/// Create a copy of Org
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrgCopyWith<_Org> get copyWith => __$OrgCopyWithImpl<_Org>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrgToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Org&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.plan, plan) || other.plan == plan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slug,name,role,plan);
}

@override
String toString() {
    return 'Org(slug: $slug, name: $name, role: $role, plan: $plan)';
}


}

/// @nodoc
abstract mixin class _$OrgCopyWith<$Res> implements $OrgCopyWith<$Res> {
  factory _$OrgCopyWith(_Org value, $Res Function(_Org) _then) = __$OrgCopyWithImpl;
@override @useResult
$Res call({
 String slug, String name, Role role, PlanTier plan
});




}
/// @nodoc
class __$OrgCopyWithImpl<$Res>
    implements _$OrgCopyWith<$Res> {
  __$OrgCopyWithImpl(this._self, this._then);

  final _Org _self;
  final $Res Function(_Org) _then;

/// Create a copy of Org
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? name = null,Object? role = null,Object? plan = null,}) {
  return _then(_Org(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PlanTier,
  ));
}


}

// dart format on
