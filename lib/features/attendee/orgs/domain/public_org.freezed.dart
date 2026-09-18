// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_org.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublicOrg {

 String get slug; String get name;
/// Create a copy of PublicOrg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicOrgCopyWith<PublicOrg> get copyWith => _$PublicOrgCopyWithImpl<PublicOrg>(this as PublicOrg, _$identity);

  /// Serializes this PublicOrg to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PublicOrg;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicOrg&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PublicOrg;
  return Object.hash(runtimeType,_this.slug,_this.name);
}

@override
String toString() {
  final _this = this as PublicOrg;
  return 'PublicOrg(slug: ${_this.slug}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $PublicOrgCopyWith<$Res>  {
  factory $PublicOrgCopyWith(PublicOrg value, $Res Function(PublicOrg) _then) = _$PublicOrgCopyWithImpl;
@useResult
$Res call({
 String slug, String name
});




}
/// @nodoc
class _$PublicOrgCopyWithImpl<$Res>
    implements $PublicOrgCopyWith<$Res> {
  _$PublicOrgCopyWithImpl(this._self, this._then);

  final PublicOrg _self;
  final $Res Function(PublicOrg) _then;

/// Create a copy of PublicOrg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? name = null,}) {
  return _then(PublicOrg(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicOrg].
extension PublicOrgPatterns on PublicOrg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicOrg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicOrg() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicOrg value)  $default,){
final _that = this;
switch (_that) {
case _PublicOrg():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicOrg value)?  $default,){
final _that = this;
switch (_that) {
case _PublicOrg() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicOrg() when $default != null:
return $default(_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String name)  $default,) {final _that = this;
switch (_that) {
case _PublicOrg():
return $default(_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String name)?  $default,) {final _that = this;
switch (_that) {
case _PublicOrg() when $default != null:
return $default(_that.slug,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicOrg implements PublicOrg {
  const _PublicOrg({required this.slug, required this.name});
  factory _PublicOrg.fromJson(Map<String, dynamic> json) => _$PublicOrgFromJson(json);

@override final  String slug;
@override final  String name;

/// Create a copy of PublicOrg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicOrgCopyWith<_PublicOrg> get copyWith => __$PublicOrgCopyWithImpl<_PublicOrg>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicOrgToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicOrg&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slug,name);
}

@override
String toString() {
    return 'PublicOrg(slug: $slug, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PublicOrgCopyWith<$Res> implements $PublicOrgCopyWith<$Res> {
  factory _$PublicOrgCopyWith(_PublicOrg value, $Res Function(_PublicOrg) _then) = __$PublicOrgCopyWithImpl;
@override @useResult
$Res call({
 String slug, String name
});




}
/// @nodoc
class __$PublicOrgCopyWithImpl<$Res>
    implements _$PublicOrgCopyWith<$Res> {
  __$PublicOrgCopyWithImpl(this._self, this._then);

  final _PublicOrg _self;
  final $Res Function(_PublicOrg) _then;

/// Create a copy of PublicOrg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? name = null,}) {
  return _then(_PublicOrg(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PublicEvent {

 String get slug; String get title; String? get description; DateTime get startsAt; DateTime? get endsAt; String get timezone; int? get capacity;/// `capacity - confirmed`; null when uncapped.
 int? get remaining; bool get isFull; bool get waitlistEnabled;
/// Create a copy of PublicEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicEventCopyWith<PublicEvent> get copyWith => _$PublicEventCopyWithImpl<PublicEvent>(this as PublicEvent, _$identity);

  /// Serializes this PublicEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PublicEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicEvent&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.remaining, _this.remaining) || other.remaining == _this.remaining)&&(identical(other.isFull, _this.isFull) || other.isFull == _this.isFull)&&(identical(other.waitlistEnabled, _this.waitlistEnabled) || other.waitlistEnabled == _this.waitlistEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PublicEvent;
  return Object.hash(runtimeType,_this.slug,_this.title,_this.description,_this.startsAt,_this.endsAt,_this.timezone,_this.capacity,_this.remaining,_this.isFull,_this.waitlistEnabled);
}

@override
String toString() {
  final _this = this as PublicEvent;
  return 'PublicEvent(slug: ${_this.slug}, title: ${_this.title}, description: ${_this.description}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, timezone: ${_this.timezone}, capacity: ${_this.capacity}, remaining: ${_this.remaining}, isFull: ${_this.isFull}, waitlistEnabled: ${_this.waitlistEnabled})';
}


}

/// @nodoc
abstract mixin class $PublicEventCopyWith<$Res>  {
  factory $PublicEventCopyWith(PublicEvent value, $Res Function(PublicEvent) _then) = _$PublicEventCopyWithImpl;
@useResult
$Res call({
 String slug, String title, String? description, DateTime startsAt, DateTime? endsAt, String timezone, int? capacity, int? remaining, bool isFull, bool waitlistEnabled
});




}
/// @nodoc
class _$PublicEventCopyWithImpl<$Res>
    implements $PublicEventCopyWith<$Res> {
  _$PublicEventCopyWithImpl(this._self, this._then);

  final PublicEvent _self;
  final $Res Function(PublicEvent) _then;

/// Create a copy of PublicEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? title = null,Object? description = freezed,Object? startsAt = null,Object? endsAt = freezed,Object? timezone = null,Object? capacity = freezed,Object? remaining = freezed,Object? isFull = null,Object? waitlistEnabled = null,}) {
  return _then(PublicEvent(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,remaining: freezed == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int?,isFull: null == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool,waitlistEnabled: null == waitlistEnabled ? _self.waitlistEnabled : waitlistEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicEvent].
extension PublicEventPatterns on PublicEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicEvent value)  $default,){
final _that = this;
switch (_that) {
case _PublicEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicEvent value)?  $default,){
final _that = this;
switch (_that) {
case _PublicEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String title,  String? description,  DateTime startsAt,  DateTime? endsAt,  String timezone,  int? capacity,  int? remaining,  bool isFull,  bool waitlistEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicEvent() when $default != null:
return $default(_that.slug,_that.title,_that.description,_that.startsAt,_that.endsAt,_that.timezone,_that.capacity,_that.remaining,_that.isFull,_that.waitlistEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String title,  String? description,  DateTime startsAt,  DateTime? endsAt,  String timezone,  int? capacity,  int? remaining,  bool isFull,  bool waitlistEnabled)  $default,) {final _that = this;
switch (_that) {
case _PublicEvent():
return $default(_that.slug,_that.title,_that.description,_that.startsAt,_that.endsAt,_that.timezone,_that.capacity,_that.remaining,_that.isFull,_that.waitlistEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String title,  String? description,  DateTime startsAt,  DateTime? endsAt,  String timezone,  int? capacity,  int? remaining,  bool isFull,  bool waitlistEnabled)?  $default,) {final _that = this;
switch (_that) {
case _PublicEvent() when $default != null:
return $default(_that.slug,_that.title,_that.description,_that.startsAt,_that.endsAt,_that.timezone,_that.capacity,_that.remaining,_that.isFull,_that.waitlistEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicEvent extends PublicEvent {
  const _PublicEvent({required this.slug, required this.title, this.description, required this.startsAt, this.endsAt, required this.timezone, this.capacity, this.remaining, this.isFull = false, this.waitlistEnabled = false}): super._();
  factory _PublicEvent.fromJson(Map<String, dynamic> json) => _$PublicEventFromJson(json);

@override final  String slug;
@override final  String title;
@override final  String? description;
@override final  DateTime startsAt;
@override final  DateTime? endsAt;
@override final  String timezone;
@override final  int? capacity;
/// `capacity - confirmed`; null when uncapped.
@override final  int? remaining;
@override@JsonKey() final  bool isFull;
@override@JsonKey() final  bool waitlistEnabled;

/// Create a copy of PublicEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicEventCopyWith<_PublicEvent> get copyWith => __$PublicEventCopyWithImpl<_PublicEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicEvent&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.isFull, isFull) || other.isFull == isFull)&&(identical(other.waitlistEnabled, waitlistEnabled) || other.waitlistEnabled == waitlistEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slug,title,description,startsAt,endsAt,timezone,capacity,remaining,isFull,waitlistEnabled);
}

@override
String toString() {
    return 'PublicEvent(slug: $slug, title: $title, description: $description, startsAt: $startsAt, endsAt: $endsAt, timezone: $timezone, capacity: $capacity, remaining: $remaining, isFull: $isFull, waitlistEnabled: $waitlistEnabled)';
}


}

/// @nodoc
abstract mixin class _$PublicEventCopyWith<$Res> implements $PublicEventCopyWith<$Res> {
  factory _$PublicEventCopyWith(_PublicEvent value, $Res Function(_PublicEvent) _then) = __$PublicEventCopyWithImpl;
@override @useResult
$Res call({
 String slug, String title, String? description, DateTime startsAt, DateTime? endsAt, String timezone, int? capacity, int? remaining, bool isFull, bool waitlistEnabled
});




}
/// @nodoc
class __$PublicEventCopyWithImpl<$Res>
    implements _$PublicEventCopyWith<$Res> {
  __$PublicEventCopyWithImpl(this._self, this._then);

  final _PublicEvent _self;
  final $Res Function(_PublicEvent) _then;

/// Create a copy of PublicEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? title = null,Object? description = freezed,Object? startsAt = null,Object? endsAt = freezed,Object? timezone = null,Object? capacity = freezed,Object? remaining = freezed,Object? isFull = null,Object? waitlistEnabled = null,}) {
  return _then(_PublicEvent(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,remaining: freezed == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int?,isFull: null == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool,waitlistEnabled: null == waitlistEnabled ? _self.waitlistEnabled : waitlistEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PublicEventsPage {

 PublicOrg get org; List<PublicEvent> get events;
/// Create a copy of PublicEventsPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicEventsPageCopyWith<PublicEventsPage> get copyWith => _$PublicEventsPageCopyWithImpl<PublicEventsPage>(this as PublicEventsPage, _$identity);

  /// Serializes this PublicEventsPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PublicEventsPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicEventsPage&&(identical(other.org, _this.org) || other.org == _this.org)&&const DeepCollectionEquality().equals(other.events, _this.events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PublicEventsPage;
  return Object.hash(runtimeType,_this.org,const DeepCollectionEquality().hash(_this.events));
}

@override
String toString() {
  final _this = this as PublicEventsPage;
  return 'PublicEventsPage(org: ${_this.org}, events: ${_this.events})';
}


}

/// @nodoc
abstract mixin class $PublicEventsPageCopyWith<$Res>  {
  factory $PublicEventsPageCopyWith(PublicEventsPage value, $Res Function(PublicEventsPage) _then) = _$PublicEventsPageCopyWithImpl;
@useResult
$Res call({
 PublicOrg org, List<PublicEvent> events
});


$PublicOrgCopyWith<$Res> get org;

}
/// @nodoc
class _$PublicEventsPageCopyWithImpl<$Res>
    implements $PublicEventsPageCopyWith<$Res> {
  _$PublicEventsPageCopyWithImpl(this._self, this._then);

  final PublicEventsPage _self;
  final $Res Function(PublicEventsPage) _then;

/// Create a copy of PublicEventsPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? org = null,Object? events = null,}) {
  return _then(PublicEventsPage(
org: null == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as PublicOrg,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<PublicEvent>,
  ));
}
/// Create a copy of PublicEventsPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicOrgCopyWith<$Res> get org {
  
  return $PublicOrgCopyWith<$Res>(_self.org, (value) {
    return _then(_self.copyWith(org: value));
  });
}
}


/// Adds pattern-matching-related methods to [PublicEventsPage].
extension PublicEventsPagePatterns on PublicEventsPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicEventsPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicEventsPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicEventsPage value)  $default,){
final _that = this;
switch (_that) {
case _PublicEventsPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicEventsPage value)?  $default,){
final _that = this;
switch (_that) {
case _PublicEventsPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PublicOrg org,  List<PublicEvent> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicEventsPage() when $default != null:
return $default(_that.org,_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PublicOrg org,  List<PublicEvent> events)  $default,) {final _that = this;
switch (_that) {
case _PublicEventsPage():
return $default(_that.org,_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PublicOrg org,  List<PublicEvent> events)?  $default,) {final _that = this;
switch (_that) {
case _PublicEventsPage() when $default != null:
return $default(_that.org,_that.events);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicEventsPage implements PublicEventsPage {
  const _PublicEventsPage({required this.org,  List<PublicEvent> events = const <PublicEvent>[]}): _events = events;
  factory _PublicEventsPage.fromJson(Map<String, dynamic> json) => _$PublicEventsPageFromJson(json);

@override final  PublicOrg org;
 final  List<PublicEvent> _events;
@override@JsonKey() List<PublicEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of PublicEventsPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicEventsPageCopyWith<_PublicEventsPage> get copyWith => __$PublicEventsPageCopyWithImpl<_PublicEventsPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicEventsPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicEventsPage&&(identical(other.org, org) || other.org == org)&&const DeepCollectionEquality().equals(other.events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,org,const DeepCollectionEquality().hash(_events));
}

@override
String toString() {
    return 'PublicEventsPage(org: $org, events: $events)';
}


}

/// @nodoc
abstract mixin class _$PublicEventsPageCopyWith<$Res> implements $PublicEventsPageCopyWith<$Res> {
  factory _$PublicEventsPageCopyWith(_PublicEventsPage value, $Res Function(_PublicEventsPage) _then) = __$PublicEventsPageCopyWithImpl;
@override @useResult
$Res call({
 PublicOrg org, List<PublicEvent> events
});


@override $PublicOrgCopyWith<$Res> get org;

}
/// @nodoc
class __$PublicEventsPageCopyWithImpl<$Res>
    implements _$PublicEventsPageCopyWith<$Res> {
  __$PublicEventsPageCopyWithImpl(this._self, this._then);

  final _PublicEventsPage _self;
  final $Res Function(_PublicEventsPage) _then;

/// Create a copy of PublicEventsPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? org = null,Object? events = null,}) {
  return _then(_PublicEventsPage(
org: null == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as PublicOrg,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<PublicEvent>,
  ));
}

/// Create a copy of PublicEventsPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicOrgCopyWith<$Res> get org {
  
  return $PublicOrgCopyWith<$Res>(_self.org, (value) {
    return _then(_self.copyWith(org: value));
  });
}
}


/// @nodoc
mixin _$PublicEventPage {

 PublicOrg get org; PublicEvent get event;
/// Create a copy of PublicEventPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicEventPageCopyWith<PublicEventPage> get copyWith => _$PublicEventPageCopyWithImpl<PublicEventPage>(this as PublicEventPage, _$identity);

  /// Serializes this PublicEventPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PublicEventPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicEventPage&&(identical(other.org, _this.org) || other.org == _this.org)&&(identical(other.event, _this.event) || other.event == _this.event));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PublicEventPage;
  return Object.hash(runtimeType,_this.org,_this.event);
}

@override
String toString() {
  final _this = this as PublicEventPage;
  return 'PublicEventPage(org: ${_this.org}, event: ${_this.event})';
}


}

/// @nodoc
abstract mixin class $PublicEventPageCopyWith<$Res>  {
  factory $PublicEventPageCopyWith(PublicEventPage value, $Res Function(PublicEventPage) _then) = _$PublicEventPageCopyWithImpl;
@useResult
$Res call({
 PublicOrg org, PublicEvent event
});


$PublicOrgCopyWith<$Res> get org;$PublicEventCopyWith<$Res> get event;

}
/// @nodoc
class _$PublicEventPageCopyWithImpl<$Res>
    implements $PublicEventPageCopyWith<$Res> {
  _$PublicEventPageCopyWithImpl(this._self, this._then);

  final PublicEventPage _self;
  final $Res Function(PublicEventPage) _then;

/// Create a copy of PublicEventPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? org = null,Object? event = null,}) {
  return _then(PublicEventPage(
org: null == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as PublicOrg,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as PublicEvent,
  ));
}
/// Create a copy of PublicEventPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicOrgCopyWith<$Res> get org {
  
  return $PublicOrgCopyWith<$Res>(_self.org, (value) {
    return _then(_self.copyWith(org: value));
  });
}/// Create a copy of PublicEventPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicEventCopyWith<$Res> get event {
  
  return $PublicEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [PublicEventPage].
extension PublicEventPagePatterns on PublicEventPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicEventPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicEventPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicEventPage value)  $default,){
final _that = this;
switch (_that) {
case _PublicEventPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicEventPage value)?  $default,){
final _that = this;
switch (_that) {
case _PublicEventPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PublicOrg org,  PublicEvent event)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicEventPage() when $default != null:
return $default(_that.org,_that.event);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PublicOrg org,  PublicEvent event)  $default,) {final _that = this;
switch (_that) {
case _PublicEventPage():
return $default(_that.org,_that.event);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PublicOrg org,  PublicEvent event)?  $default,) {final _that = this;
switch (_that) {
case _PublicEventPage() when $default != null:
return $default(_that.org,_that.event);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicEventPage implements PublicEventPage {
  const _PublicEventPage({required this.org, required this.event});
  factory _PublicEventPage.fromJson(Map<String, dynamic> json) => _$PublicEventPageFromJson(json);

@override final  PublicOrg org;
@override final  PublicEvent event;

/// Create a copy of PublicEventPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicEventPageCopyWith<_PublicEventPage> get copyWith => __$PublicEventPageCopyWithImpl<_PublicEventPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicEventPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicEventPage&&(identical(other.org, org) || other.org == org)&&(identical(other.event, event) || other.event == event));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,org,event);
}

@override
String toString() {
    return 'PublicEventPage(org: $org, event: $event)';
}


}

/// @nodoc
abstract mixin class _$PublicEventPageCopyWith<$Res> implements $PublicEventPageCopyWith<$Res> {
  factory _$PublicEventPageCopyWith(_PublicEventPage value, $Res Function(_PublicEventPage) _then) = __$PublicEventPageCopyWithImpl;
@override @useResult
$Res call({
 PublicOrg org, PublicEvent event
});


@override $PublicOrgCopyWith<$Res> get org;@override $PublicEventCopyWith<$Res> get event;

}
/// @nodoc
class __$PublicEventPageCopyWithImpl<$Res>
    implements _$PublicEventPageCopyWith<$Res> {
  __$PublicEventPageCopyWithImpl(this._self, this._then);

  final _PublicEventPage _self;
  final $Res Function(_PublicEventPage) _then;

/// Create a copy of PublicEventPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? org = null,Object? event = null,}) {
  return _then(_PublicEventPage(
org: null == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as PublicOrg,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as PublicEvent,
  ));
}

/// Create a copy of PublicEventPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicOrgCopyWith<$Res> get org {
  
  return $PublicOrgCopyWith<$Res>(_self.org, (value) {
    return _then(_self.copyWith(org: value));
  });
}/// Create a copy of PublicEventPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicEventCopyWith<$Res> get event {
  
  return $PublicEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
