// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventSummary {

 String get slug; String get title; DateTime get startsAt; DateTime? get endsAt; String get timezone; int? get capacity; EventStatus get status; int get confirmed; int get checkedIn;
/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventSummaryCopyWith<EventSummary> get copyWith => _$EventSummaryCopyWithImpl<EventSummary>(this as EventSummary, _$identity);

  /// Serializes this EventSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventSummary&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.confirmed, _this.confirmed) || other.confirmed == _this.confirmed)&&(identical(other.checkedIn, _this.checkedIn) || other.checkedIn == _this.checkedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventSummary;
  return Object.hash(runtimeType,_this.slug,_this.title,_this.startsAt,_this.endsAt,_this.timezone,_this.capacity,_this.status,_this.confirmed,_this.checkedIn);
}

@override
String toString() {
  final _this = this as EventSummary;
  return 'EventSummary(slug: ${_this.slug}, title: ${_this.title}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, timezone: ${_this.timezone}, capacity: ${_this.capacity}, status: ${_this.status}, confirmed: ${_this.confirmed}, checkedIn: ${_this.checkedIn})';
}


}

/// @nodoc
abstract mixin class $EventSummaryCopyWith<$Res>  {
  factory $EventSummaryCopyWith(EventSummary value, $Res Function(EventSummary) _then) = _$EventSummaryCopyWithImpl;
@useResult
$Res call({
 String slug, String title, DateTime startsAt, DateTime? endsAt, String timezone, int? capacity, EventStatus status, int confirmed, int checkedIn
});




}
/// @nodoc
class _$EventSummaryCopyWithImpl<$Res>
    implements $EventSummaryCopyWith<$Res> {
  _$EventSummaryCopyWithImpl(this._self, this._then);

  final EventSummary _self;
  final $Res Function(EventSummary) _then;

/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? title = null,Object? startsAt = null,Object? endsAt = freezed,Object? timezone = null,Object? capacity = freezed,Object? status = null,Object? confirmed = null,Object? checkedIn = null,}) {
  return _then(EventSummary(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as int,checkedIn: null == checkedIn ? _self.checkedIn : checkedIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EventSummary].
extension EventSummaryPatterns on EventSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventSummary value)  $default,){
final _that = this;
switch (_that) {
case _EventSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventSummary value)?  $default,){
final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String title,  DateTime startsAt,  DateTime? endsAt,  String timezone,  int? capacity,  EventStatus status,  int confirmed,  int checkedIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
return $default(_that.slug,_that.title,_that.startsAt,_that.endsAt,_that.timezone,_that.capacity,_that.status,_that.confirmed,_that.checkedIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String title,  DateTime startsAt,  DateTime? endsAt,  String timezone,  int? capacity,  EventStatus status,  int confirmed,  int checkedIn)  $default,) {final _that = this;
switch (_that) {
case _EventSummary():
return $default(_that.slug,_that.title,_that.startsAt,_that.endsAt,_that.timezone,_that.capacity,_that.status,_that.confirmed,_that.checkedIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String title,  DateTime startsAt,  DateTime? endsAt,  String timezone,  int? capacity,  EventStatus status,  int confirmed,  int checkedIn)?  $default,) {final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
return $default(_that.slug,_that.title,_that.startsAt,_that.endsAt,_that.timezone,_that.capacity,_that.status,_that.confirmed,_that.checkedIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventSummary extends EventSummary {
  const _EventSummary({required this.slug, required this.title, required this.startsAt, this.endsAt, required this.timezone, this.capacity, required this.status, this.confirmed = 0, this.checkedIn = 0}): super._();
  factory _EventSummary.fromJson(Map<String, dynamic> json) => _$EventSummaryFromJson(json);

@override final  String slug;
@override final  String title;
@override final  DateTime startsAt;
@override final  DateTime? endsAt;
@override final  String timezone;
@override final  int? capacity;
@override final  EventStatus status;
@override@JsonKey() final  int confirmed;
@override@JsonKey() final  int checkedIn;

/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventSummaryCopyWith<_EventSummary> get copyWith => __$EventSummaryCopyWithImpl<_EventSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventSummary&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.status, status) || other.status == status)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.checkedIn, checkedIn) || other.checkedIn == checkedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slug,title,startsAt,endsAt,timezone,capacity,status,confirmed,checkedIn);
}

@override
String toString() {
    return 'EventSummary(slug: $slug, title: $title, startsAt: $startsAt, endsAt: $endsAt, timezone: $timezone, capacity: $capacity, status: $status, confirmed: $confirmed, checkedIn: $checkedIn)';
}


}

/// @nodoc
abstract mixin class _$EventSummaryCopyWith<$Res> implements $EventSummaryCopyWith<$Res> {
  factory _$EventSummaryCopyWith(_EventSummary value, $Res Function(_EventSummary) _then) = __$EventSummaryCopyWithImpl;
@override @useResult
$Res call({
 String slug, String title, DateTime startsAt, DateTime? endsAt, String timezone, int? capacity, EventStatus status, int confirmed, int checkedIn
});




}
/// @nodoc
class __$EventSummaryCopyWithImpl<$Res>
    implements _$EventSummaryCopyWith<$Res> {
  __$EventSummaryCopyWithImpl(this._self, this._then);

  final _EventSummary _self;
  final $Res Function(_EventSummary) _then;

/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? title = null,Object? startsAt = null,Object? endsAt = freezed,Object? timezone = null,Object? capacity = freezed,Object? status = null,Object? confirmed = null,Object? checkedIn = null,}) {
  return _then(_EventSummary(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as int,checkedIn: null == checkedIn ? _self.checkedIn : checkedIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EventsPage {

 OrgRef get org; List<EventSummary> get events;
/// Create a copy of EventsPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventsPageCopyWith<EventsPage> get copyWith => _$EventsPageCopyWithImpl<EventsPage>(this as EventsPage, _$identity);

  /// Serializes this EventsPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventsPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventsPage&&(identical(other.org, _this.org) || other.org == _this.org)&&const DeepCollectionEquality().equals(other.events, _this.events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventsPage;
  return Object.hash(runtimeType,_this.org,const DeepCollectionEquality().hash(_this.events));
}

@override
String toString() {
  final _this = this as EventsPage;
  return 'EventsPage(org: ${_this.org}, events: ${_this.events})';
}


}

/// @nodoc
abstract mixin class $EventsPageCopyWith<$Res>  {
  factory $EventsPageCopyWith(EventsPage value, $Res Function(EventsPage) _then) = _$EventsPageCopyWithImpl;
@useResult
$Res call({
 OrgRef org, List<EventSummary> events
});


$OrgRefCopyWith<$Res> get org;

}
/// @nodoc
class _$EventsPageCopyWithImpl<$Res>
    implements $EventsPageCopyWith<$Res> {
  _$EventsPageCopyWithImpl(this._self, this._then);

  final EventsPage _self;
  final $Res Function(EventsPage) _then;

/// Create a copy of EventsPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? org = null,Object? events = null,}) {
  return _then(EventsPage(
org: null == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as OrgRef,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<EventSummary>,
  ));
}
/// Create a copy of EventsPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrgRefCopyWith<$Res> get org {
  
  return $OrgRefCopyWith<$Res>(_self.org, (value) {
    return _then(_self.copyWith(org: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventsPage].
extension EventsPagePatterns on EventsPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventsPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventsPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventsPage value)  $default,){
final _that = this;
switch (_that) {
case _EventsPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventsPage value)?  $default,){
final _that = this;
switch (_that) {
case _EventsPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OrgRef org,  List<EventSummary> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventsPage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OrgRef org,  List<EventSummary> events)  $default,) {final _that = this;
switch (_that) {
case _EventsPage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OrgRef org,  List<EventSummary> events)?  $default,) {final _that = this;
switch (_that) {
case _EventsPage() when $default != null:
return $default(_that.org,_that.events);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventsPage implements EventsPage {
  const _EventsPage({required this.org,  List<EventSummary> events = const <EventSummary>[]}): _events = events;
  factory _EventsPage.fromJson(Map<String, dynamic> json) => _$EventsPageFromJson(json);

@override final  OrgRef org;
 final  List<EventSummary> _events;
@override@JsonKey() List<EventSummary> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of EventsPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventsPageCopyWith<_EventsPage> get copyWith => __$EventsPageCopyWithImpl<_EventsPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventsPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventsPage&&(identical(other.org, org) || other.org == org)&&const DeepCollectionEquality().equals(other.events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,org,const DeepCollectionEquality().hash(_events));
}

@override
String toString() {
    return 'EventsPage(org: $org, events: $events)';
}


}

/// @nodoc
abstract mixin class _$EventsPageCopyWith<$Res> implements $EventsPageCopyWith<$Res> {
  factory _$EventsPageCopyWith(_EventsPage value, $Res Function(_EventsPage) _then) = __$EventsPageCopyWithImpl;
@override @useResult
$Res call({
 OrgRef org, List<EventSummary> events
});


@override $OrgRefCopyWith<$Res> get org;

}
/// @nodoc
class __$EventsPageCopyWithImpl<$Res>
    implements _$EventsPageCopyWith<$Res> {
  __$EventsPageCopyWithImpl(this._self, this._then);

  final _EventsPage _self;
  final $Res Function(_EventsPage) _then;

/// Create a copy of EventsPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? org = null,Object? events = null,}) {
  return _then(_EventsPage(
org: null == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as OrgRef,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<EventSummary>,
  ));
}

/// Create a copy of EventsPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrgRefCopyWith<$Res> get org {
  
  return $OrgRefCopyWith<$Res>(_self.org, (value) {
    return _then(_self.copyWith(org: value));
  });
}
}


/// @nodoc
mixin _$OrgRef {

 String get slug; String get name;
/// Create a copy of OrgRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrgRefCopyWith<OrgRef> get copyWith => _$OrgRefCopyWithImpl<OrgRef>(this as OrgRef, _$identity);

  /// Serializes this OrgRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrgRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrgRef&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrgRef;
  return Object.hash(runtimeType,_this.slug,_this.name);
}

@override
String toString() {
  final _this = this as OrgRef;
  return 'OrgRef(slug: ${_this.slug}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $OrgRefCopyWith<$Res>  {
  factory $OrgRefCopyWith(OrgRef value, $Res Function(OrgRef) _then) = _$OrgRefCopyWithImpl;
@useResult
$Res call({
 String slug, String name
});




}
/// @nodoc
class _$OrgRefCopyWithImpl<$Res>
    implements $OrgRefCopyWith<$Res> {
  _$OrgRefCopyWithImpl(this._self, this._then);

  final OrgRef _self;
  final $Res Function(OrgRef) _then;

/// Create a copy of OrgRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? name = null,}) {
  return _then(OrgRef(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrgRef].
extension OrgRefPatterns on OrgRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrgRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrgRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrgRef value)  $default,){
final _that = this;
switch (_that) {
case _OrgRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrgRef value)?  $default,){
final _that = this;
switch (_that) {
case _OrgRef() when $default != null:
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
case _OrgRef() when $default != null:
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
case _OrgRef():
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
case _OrgRef() when $default != null:
return $default(_that.slug,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrgRef implements OrgRef {
  const _OrgRef({required this.slug, required this.name});
  factory _OrgRef.fromJson(Map<String, dynamic> json) => _$OrgRefFromJson(json);

@override final  String slug;
@override final  String name;

/// Create a copy of OrgRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrgRefCopyWith<_OrgRef> get copyWith => __$OrgRefCopyWithImpl<_OrgRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrgRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrgRef&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slug,name);
}

@override
String toString() {
    return 'OrgRef(slug: $slug, name: $name)';
}


}

/// @nodoc
abstract mixin class _$OrgRefCopyWith<$Res> implements $OrgRefCopyWith<$Res> {
  factory _$OrgRefCopyWith(_OrgRef value, $Res Function(_OrgRef) _then) = __$OrgRefCopyWithImpl;
@override @useResult
$Res call({
 String slug, String name
});




}
/// @nodoc
class __$OrgRefCopyWithImpl<$Res>
    implements _$OrgRefCopyWith<$Res> {
  __$OrgRefCopyWithImpl(this._self, this._then);

  final _OrgRef _self;
  final $Res Function(_OrgRef) _then;

/// Create a copy of OrgRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? name = null,}) {
  return _then(_OrgRef(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
