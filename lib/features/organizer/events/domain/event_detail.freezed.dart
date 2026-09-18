// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventDetail {

 String get id; String get slug; String get title; String? get description; DateTime get startsAt; DateTime? get endsAt; String get timezone; String get startsAtLocal; String? get endsAtLocal; int? get capacity; bool get waitlistEnabled; EventStatus get status; int get confirmed; int get waitlist; int get checkedIn; DateTime get createdAt;
/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailCopyWith<EventDetail> get copyWith => _$EventDetailCopyWithImpl<EventDetail>(this as EventDetail, _$identity);

  /// Serializes this EventDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.startsAtLocal, _this.startsAtLocal) || other.startsAtLocal == _this.startsAtLocal)&&(identical(other.endsAtLocal, _this.endsAtLocal) || other.endsAtLocal == _this.endsAtLocal)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.waitlistEnabled, _this.waitlistEnabled) || other.waitlistEnabled == _this.waitlistEnabled)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.confirmed, _this.confirmed) || other.confirmed == _this.confirmed)&&(identical(other.waitlist, _this.waitlist) || other.waitlist == _this.waitlist)&&(identical(other.checkedIn, _this.checkedIn) || other.checkedIn == _this.checkedIn)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventDetail;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.title,_this.description,_this.startsAt,_this.endsAt,_this.timezone,_this.startsAtLocal,_this.endsAtLocal,_this.capacity,_this.waitlistEnabled,_this.status,_this.confirmed,_this.waitlist,_this.checkedIn,_this.createdAt);
}

@override
String toString() {
  final _this = this as EventDetail;
  return 'EventDetail(id: ${_this.id}, slug: ${_this.slug}, title: ${_this.title}, description: ${_this.description}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, timezone: ${_this.timezone}, startsAtLocal: ${_this.startsAtLocal}, endsAtLocal: ${_this.endsAtLocal}, capacity: ${_this.capacity}, waitlistEnabled: ${_this.waitlistEnabled}, status: ${_this.status}, confirmed: ${_this.confirmed}, waitlist: ${_this.waitlist}, checkedIn: ${_this.checkedIn}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $EventDetailCopyWith<$Res>  {
  factory $EventDetailCopyWith(EventDetail value, $Res Function(EventDetail) _then) = _$EventDetailCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, String? description, DateTime startsAt, DateTime? endsAt, String timezone, String startsAtLocal, String? endsAtLocal, int? capacity, bool waitlistEnabled, EventStatus status, int confirmed, int waitlist, int checkedIn, DateTime createdAt
});




}
/// @nodoc
class _$EventDetailCopyWithImpl<$Res>
    implements $EventDetailCopyWith<$Res> {
  _$EventDetailCopyWithImpl(this._self, this._then);

  final EventDetail _self;
  final $Res Function(EventDetail) _then;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? description = freezed,Object? startsAt = null,Object? endsAt = freezed,Object? timezone = null,Object? startsAtLocal = null,Object? endsAtLocal = freezed,Object? capacity = freezed,Object? waitlistEnabled = null,Object? status = null,Object? confirmed = null,Object? waitlist = null,Object? checkedIn = null,Object? createdAt = null,}) {
  return _then(EventDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,startsAtLocal: null == startsAtLocal ? _self.startsAtLocal : startsAtLocal // ignore: cast_nullable_to_non_nullable
as String,endsAtLocal: freezed == endsAtLocal ? _self.endsAtLocal : endsAtLocal // ignore: cast_nullable_to_non_nullable
as String?,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,waitlistEnabled: null == waitlistEnabled ? _self.waitlistEnabled : waitlistEnabled // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as int,waitlist: null == waitlist ? _self.waitlist : waitlist // ignore: cast_nullable_to_non_nullable
as int,checkedIn: null == checkedIn ? _self.checkedIn : checkedIn // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EventDetail].
extension EventDetailPatterns on EventDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDetail value)  $default,){
final _that = this;
switch (_that) {
case _EventDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDetail value)?  $default,){
final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String? description,  DateTime startsAt,  DateTime? endsAt,  String timezone,  String startsAtLocal,  String? endsAtLocal,  int? capacity,  bool waitlistEnabled,  EventStatus status,  int confirmed,  int waitlist,  int checkedIn,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.description,_that.startsAt,_that.endsAt,_that.timezone,_that.startsAtLocal,_that.endsAtLocal,_that.capacity,_that.waitlistEnabled,_that.status,_that.confirmed,_that.waitlist,_that.checkedIn,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String? description,  DateTime startsAt,  DateTime? endsAt,  String timezone,  String startsAtLocal,  String? endsAtLocal,  int? capacity,  bool waitlistEnabled,  EventStatus status,  int confirmed,  int waitlist,  int checkedIn,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _EventDetail():
return $default(_that.id,_that.slug,_that.title,_that.description,_that.startsAt,_that.endsAt,_that.timezone,_that.startsAtLocal,_that.endsAtLocal,_that.capacity,_that.waitlistEnabled,_that.status,_that.confirmed,_that.waitlist,_that.checkedIn,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  String? description,  DateTime startsAt,  DateTime? endsAt,  String timezone,  String startsAtLocal,  String? endsAtLocal,  int? capacity,  bool waitlistEnabled,  EventStatus status,  int confirmed,  int waitlist,  int checkedIn,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.description,_that.startsAt,_that.endsAt,_that.timezone,_that.startsAtLocal,_that.endsAtLocal,_that.capacity,_that.waitlistEnabled,_that.status,_that.confirmed,_that.waitlist,_that.checkedIn,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventDetail extends EventDetail {
  const _EventDetail({required this.id, required this.slug, required this.title, this.description, required this.startsAt, this.endsAt, required this.timezone, required this.startsAtLocal, this.endsAtLocal, this.capacity, this.waitlistEnabled = false, required this.status, this.confirmed = 0, this.waitlist = 0, this.checkedIn = 0, required this.createdAt}): super._();
  factory _EventDetail.fromJson(Map<String, dynamic> json) => _$EventDetailFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
@override final  String? description;
@override final  DateTime startsAt;
@override final  DateTime? endsAt;
@override final  String timezone;
@override final  String startsAtLocal;
@override final  String? endsAtLocal;
@override final  int? capacity;
@override@JsonKey() final  bool waitlistEnabled;
@override final  EventStatus status;
@override@JsonKey() final  int confirmed;
@override@JsonKey() final  int waitlist;
@override@JsonKey() final  int checkedIn;
@override final  DateTime createdAt;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDetailCopyWith<_EventDetail> get copyWith => __$EventDetailCopyWithImpl<_EventDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.startsAtLocal, startsAtLocal) || other.startsAtLocal == startsAtLocal)&&(identical(other.endsAtLocal, endsAtLocal) || other.endsAtLocal == endsAtLocal)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.waitlistEnabled, waitlistEnabled) || other.waitlistEnabled == waitlistEnabled)&&(identical(other.status, status) || other.status == status)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.waitlist, waitlist) || other.waitlist == waitlist)&&(identical(other.checkedIn, checkedIn) || other.checkedIn == checkedIn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,title,description,startsAt,endsAt,timezone,startsAtLocal,endsAtLocal,capacity,waitlistEnabled,status,confirmed,waitlist,checkedIn,createdAt);
}

@override
String toString() {
    return 'EventDetail(id: $id, slug: $slug, title: $title, description: $description, startsAt: $startsAt, endsAt: $endsAt, timezone: $timezone, startsAtLocal: $startsAtLocal, endsAtLocal: $endsAtLocal, capacity: $capacity, waitlistEnabled: $waitlistEnabled, status: $status, confirmed: $confirmed, waitlist: $waitlist, checkedIn: $checkedIn, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EventDetailCopyWith<$Res> implements $EventDetailCopyWith<$Res> {
  factory _$EventDetailCopyWith(_EventDetail value, $Res Function(_EventDetail) _then) = __$EventDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, String? description, DateTime startsAt, DateTime? endsAt, String timezone, String startsAtLocal, String? endsAtLocal, int? capacity, bool waitlistEnabled, EventStatus status, int confirmed, int waitlist, int checkedIn, DateTime createdAt
});




}
/// @nodoc
class __$EventDetailCopyWithImpl<$Res>
    implements _$EventDetailCopyWith<$Res> {
  __$EventDetailCopyWithImpl(this._self, this._then);

  final _EventDetail _self;
  final $Res Function(_EventDetail) _then;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? description = freezed,Object? startsAt = null,Object? endsAt = freezed,Object? timezone = null,Object? startsAtLocal = null,Object? endsAtLocal = freezed,Object? capacity = freezed,Object? waitlistEnabled = null,Object? status = null,Object? confirmed = null,Object? waitlist = null,Object? checkedIn = null,Object? createdAt = null,}) {
  return _then(_EventDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,startsAtLocal: null == startsAtLocal ? _self.startsAtLocal : startsAtLocal // ignore: cast_nullable_to_non_nullable
as String,endsAtLocal: freezed == endsAtLocal ? _self.endsAtLocal : endsAtLocal // ignore: cast_nullable_to_non_nullable
as String?,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,waitlistEnabled: null == waitlistEnabled ? _self.waitlistEnabled : waitlistEnabled // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as int,waitlist: null == waitlist ? _self.waitlist : waitlist // ignore: cast_nullable_to_non_nullable
as int,checkedIn: null == checkedIn ? _self.checkedIn : checkedIn // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
