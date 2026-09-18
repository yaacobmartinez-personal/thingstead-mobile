// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Attendee {

 String get id; String? get name; String? get email; RegistrationStatus get status; DateTime? get checkedInAt; bool get erased; String? get checkInToken;
/// Create a copy of Attendee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendeeCopyWith<Attendee> get copyWith => _$AttendeeCopyWithImpl<Attendee>(this as Attendee, _$identity);

  /// Serializes this Attendee to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Attendee;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attendee&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.checkedInAt, _this.checkedInAt) || other.checkedInAt == _this.checkedInAt)&&(identical(other.erased, _this.erased) || other.erased == _this.erased)&&(identical(other.checkInToken, _this.checkInToken) || other.checkInToken == _this.checkInToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Attendee;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.status,_this.checkedInAt,_this.erased,_this.checkInToken);
}

@override
String toString() {
  final _this = this as Attendee;
  return 'Attendee(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, status: ${_this.status}, checkedInAt: ${_this.checkedInAt}, erased: ${_this.erased}, checkInToken: ${_this.checkInToken})';
}


}

/// @nodoc
abstract mixin class $AttendeeCopyWith<$Res>  {
  factory $AttendeeCopyWith(Attendee value, $Res Function(Attendee) _then) = _$AttendeeCopyWithImpl;
@useResult
$Res call({
 String id, String? name, String? email, RegistrationStatus status, DateTime? checkedInAt, bool erased, String? checkInToken
});




}
/// @nodoc
class _$AttendeeCopyWithImpl<$Res>
    implements $AttendeeCopyWith<$Res> {
  _$AttendeeCopyWithImpl(this._self, this._then);

  final Attendee _self;
  final $Res Function(Attendee) _then;

/// Create a copy of Attendee
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? email = freezed,Object? status = null,Object? checkedInAt = freezed,Object? erased = null,Object? checkInToken = freezed,}) {
  return _then(Attendee(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RegistrationStatus,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,erased: null == erased ? _self.erased : erased // ignore: cast_nullable_to_non_nullable
as bool,checkInToken: freezed == checkInToken ? _self.checkInToken : checkInToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Attendee].
extension AttendeePatterns on Attendee {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attendee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attendee() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attendee value)  $default,){
final _that = this;
switch (_that) {
case _Attendee():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attendee value)?  $default,){
final _that = this;
switch (_that) {
case _Attendee() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  String? email,  RegistrationStatus status,  DateTime? checkedInAt,  bool erased,  String? checkInToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attendee() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.status,_that.checkedInAt,_that.erased,_that.checkInToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  String? email,  RegistrationStatus status,  DateTime? checkedInAt,  bool erased,  String? checkInToken)  $default,) {final _that = this;
switch (_that) {
case _Attendee():
return $default(_that.id,_that.name,_that.email,_that.status,_that.checkedInAt,_that.erased,_that.checkInToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  String? email,  RegistrationStatus status,  DateTime? checkedInAt,  bool erased,  String? checkInToken)?  $default,) {final _that = this;
switch (_that) {
case _Attendee() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.status,_that.checkedInAt,_that.erased,_that.checkInToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Attendee extends Attendee {
  const _Attendee({required this.id, this.name, this.email, required this.status, this.checkedInAt, this.erased = false, this.checkInToken}): super._();
  factory _Attendee.fromJson(Map<String, dynamic> json) => _$AttendeeFromJson(json);

@override final  String id;
@override final  String? name;
@override final  String? email;
@override final  RegistrationStatus status;
@override final  DateTime? checkedInAt;
@override@JsonKey() final  bool erased;
@override final  String? checkInToken;

/// Create a copy of Attendee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendeeCopyWith<_Attendee> get copyWith => __$AttendeeCopyWithImpl<_Attendee>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendeeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attendee&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.checkedInAt, checkedInAt) || other.checkedInAt == checkedInAt)&&(identical(other.erased, erased) || other.erased == erased)&&(identical(other.checkInToken, checkInToken) || other.checkInToken == checkInToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,status,checkedInAt,erased,checkInToken);
}

@override
String toString() {
    return 'Attendee(id: $id, name: $name, email: $email, status: $status, checkedInAt: $checkedInAt, erased: $erased, checkInToken: $checkInToken)';
}


}

/// @nodoc
abstract mixin class _$AttendeeCopyWith<$Res> implements $AttendeeCopyWith<$Res> {
  factory _$AttendeeCopyWith(_Attendee value, $Res Function(_Attendee) _then) = __$AttendeeCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, String? email, RegistrationStatus status, DateTime? checkedInAt, bool erased, String? checkInToken
});




}
/// @nodoc
class __$AttendeeCopyWithImpl<$Res>
    implements _$AttendeeCopyWith<$Res> {
  __$AttendeeCopyWithImpl(this._self, this._then);

  final _Attendee _self;
  final $Res Function(_Attendee) _then;

/// Create a copy of Attendee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? email = freezed,Object? status = null,Object? checkedInAt = freezed,Object? erased = null,Object? checkInToken = freezed,}) {
  return _then(_Attendee(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RegistrationStatus,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,erased: null == erased ? _self.erased : erased // ignore: cast_nullable_to_non_nullable
as bool,checkInToken: freezed == checkInToken ? _self.checkInToken : checkInToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AttendeeEventRef {

 String get title; String get timezone; int? get capacity; int? get waitlist;
/// Create a copy of AttendeeEventRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendeeEventRefCopyWith<AttendeeEventRef> get copyWith => _$AttendeeEventRefCopyWithImpl<AttendeeEventRef>(this as AttendeeEventRef, _$identity);

  /// Serializes this AttendeeEventRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttendeeEventRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendeeEventRef&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.waitlist, _this.waitlist) || other.waitlist == _this.waitlist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttendeeEventRef;
  return Object.hash(runtimeType,_this.title,_this.timezone,_this.capacity,_this.waitlist);
}

@override
String toString() {
  final _this = this as AttendeeEventRef;
  return 'AttendeeEventRef(title: ${_this.title}, timezone: ${_this.timezone}, capacity: ${_this.capacity}, waitlist: ${_this.waitlist})';
}


}

/// @nodoc
abstract mixin class $AttendeeEventRefCopyWith<$Res>  {
  factory $AttendeeEventRefCopyWith(AttendeeEventRef value, $Res Function(AttendeeEventRef) _then) = _$AttendeeEventRefCopyWithImpl;
@useResult
$Res call({
 String title, String timezone, int? capacity, int? waitlist
});




}
/// @nodoc
class _$AttendeeEventRefCopyWithImpl<$Res>
    implements $AttendeeEventRefCopyWith<$Res> {
  _$AttendeeEventRefCopyWithImpl(this._self, this._then);

  final AttendeeEventRef _self;
  final $Res Function(AttendeeEventRef) _then;

/// Create a copy of AttendeeEventRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? timezone = null,Object? capacity = freezed,Object? waitlist = freezed,}) {
  return _then(AttendeeEventRef(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,waitlist: freezed == waitlist ? _self.waitlist : waitlist // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendeeEventRef].
extension AttendeeEventRefPatterns on AttendeeEventRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendeeEventRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendeeEventRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendeeEventRef value)  $default,){
final _that = this;
switch (_that) {
case _AttendeeEventRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendeeEventRef value)?  $default,){
final _that = this;
switch (_that) {
case _AttendeeEventRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String timezone,  int? capacity,  int? waitlist)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendeeEventRef() when $default != null:
return $default(_that.title,_that.timezone,_that.capacity,_that.waitlist);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String timezone,  int? capacity,  int? waitlist)  $default,) {final _that = this;
switch (_that) {
case _AttendeeEventRef():
return $default(_that.title,_that.timezone,_that.capacity,_that.waitlist);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String timezone,  int? capacity,  int? waitlist)?  $default,) {final _that = this;
switch (_that) {
case _AttendeeEventRef() when $default != null:
return $default(_that.title,_that.timezone,_that.capacity,_that.waitlist);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendeeEventRef implements AttendeeEventRef {
  const _AttendeeEventRef({required this.title, required this.timezone, this.capacity, this.waitlist});
  factory _AttendeeEventRef.fromJson(Map<String, dynamic> json) => _$AttendeeEventRefFromJson(json);

@override final  String title;
@override final  String timezone;
@override final  int? capacity;
@override final  int? waitlist;

/// Create a copy of AttendeeEventRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendeeEventRefCopyWith<_AttendeeEventRef> get copyWith => __$AttendeeEventRefCopyWithImpl<_AttendeeEventRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendeeEventRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendeeEventRef&&(identical(other.title, title) || other.title == title)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.waitlist, waitlist) || other.waitlist == waitlist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,timezone,capacity,waitlist);
}

@override
String toString() {
    return 'AttendeeEventRef(title: $title, timezone: $timezone, capacity: $capacity, waitlist: $waitlist)';
}


}

/// @nodoc
abstract mixin class _$AttendeeEventRefCopyWith<$Res> implements $AttendeeEventRefCopyWith<$Res> {
  factory _$AttendeeEventRefCopyWith(_AttendeeEventRef value, $Res Function(_AttendeeEventRef) _then) = __$AttendeeEventRefCopyWithImpl;
@override @useResult
$Res call({
 String title, String timezone, int? capacity, int? waitlist
});




}
/// @nodoc
class __$AttendeeEventRefCopyWithImpl<$Res>
    implements _$AttendeeEventRefCopyWith<$Res> {
  __$AttendeeEventRefCopyWithImpl(this._self, this._then);

  final _AttendeeEventRef _self;
  final $Res Function(_AttendeeEventRef) _then;

/// Create a copy of AttendeeEventRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? timezone = null,Object? capacity = freezed,Object? waitlist = freezed,}) {
  return _then(_AttendeeEventRef(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,waitlist: freezed == waitlist ? _self.waitlist : waitlist // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AttendeeList {

 AttendeeEventRef get event; List<Attendee> get attendees;
/// Create a copy of AttendeeList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendeeListCopyWith<AttendeeList> get copyWith => _$AttendeeListCopyWithImpl<AttendeeList>(this as AttendeeList, _$identity);

  /// Serializes this AttendeeList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttendeeList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendeeList&&(identical(other.event, _this.event) || other.event == _this.event)&&const DeepCollectionEquality().equals(other.attendees, _this.attendees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttendeeList;
  return Object.hash(runtimeType,_this.event,const DeepCollectionEquality().hash(_this.attendees));
}

@override
String toString() {
  final _this = this as AttendeeList;
  return 'AttendeeList(event: ${_this.event}, attendees: ${_this.attendees})';
}


}

/// @nodoc
abstract mixin class $AttendeeListCopyWith<$Res>  {
  factory $AttendeeListCopyWith(AttendeeList value, $Res Function(AttendeeList) _then) = _$AttendeeListCopyWithImpl;
@useResult
$Res call({
 AttendeeEventRef event, List<Attendee> attendees
});


$AttendeeEventRefCopyWith<$Res> get event;

}
/// @nodoc
class _$AttendeeListCopyWithImpl<$Res>
    implements $AttendeeListCopyWith<$Res> {
  _$AttendeeListCopyWithImpl(this._self, this._then);

  final AttendeeList _self;
  final $Res Function(AttendeeList) _then;

/// Create a copy of AttendeeList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? event = null,Object? attendees = null,}) {
  return _then(AttendeeList(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as AttendeeEventRef,attendees: null == attendees ? _self.attendees : attendees // ignore: cast_nullable_to_non_nullable
as List<Attendee>,
  ));
}
/// Create a copy of AttendeeList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendeeEventRefCopyWith<$Res> get event {
  
  return $AttendeeEventRefCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttendeeList].
extension AttendeeListPatterns on AttendeeList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendeeList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendeeList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendeeList value)  $default,){
final _that = this;
switch (_that) {
case _AttendeeList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendeeList value)?  $default,){
final _that = this;
switch (_that) {
case _AttendeeList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AttendeeEventRef event,  List<Attendee> attendees)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendeeList() when $default != null:
return $default(_that.event,_that.attendees);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AttendeeEventRef event,  List<Attendee> attendees)  $default,) {final _that = this;
switch (_that) {
case _AttendeeList():
return $default(_that.event,_that.attendees);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AttendeeEventRef event,  List<Attendee> attendees)?  $default,) {final _that = this;
switch (_that) {
case _AttendeeList() when $default != null:
return $default(_that.event,_that.attendees);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendeeList implements AttendeeList {
  const _AttendeeList({required this.event,  List<Attendee> attendees = const <Attendee>[]}): _attendees = attendees;
  factory _AttendeeList.fromJson(Map<String, dynamic> json) => _$AttendeeListFromJson(json);

@override final  AttendeeEventRef event;
 final  List<Attendee> _attendees;
@override@JsonKey() List<Attendee> get attendees {
  if (_attendees is EqualUnmodifiableListView) return _attendees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attendees);
}


/// Create a copy of AttendeeList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendeeListCopyWith<_AttendeeList> get copyWith => __$AttendeeListCopyWithImpl<_AttendeeList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendeeListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendeeList&&(identical(other.event, event) || other.event == event)&&const DeepCollectionEquality().equals(other.attendees, _attendees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,event,const DeepCollectionEquality().hash(_attendees));
}

@override
String toString() {
    return 'AttendeeList(event: $event, attendees: $attendees)';
}


}

/// @nodoc
abstract mixin class _$AttendeeListCopyWith<$Res> implements $AttendeeListCopyWith<$Res> {
  factory _$AttendeeListCopyWith(_AttendeeList value, $Res Function(_AttendeeList) _then) = __$AttendeeListCopyWithImpl;
@override @useResult
$Res call({
 AttendeeEventRef event, List<Attendee> attendees
});


@override $AttendeeEventRefCopyWith<$Res> get event;

}
/// @nodoc
class __$AttendeeListCopyWithImpl<$Res>
    implements _$AttendeeListCopyWith<$Res> {
  __$AttendeeListCopyWithImpl(this._self, this._then);

  final _AttendeeList _self;
  final $Res Function(_AttendeeList) _then;

/// Create a copy of AttendeeList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? event = null,Object? attendees = null,}) {
  return _then(_AttendeeList(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as AttendeeEventRef,attendees: null == attendees ? _self._attendees : attendees // ignore: cast_nullable_to_non_nullable
as List<Attendee>,
  ));
}

/// Create a copy of AttendeeList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendeeEventRefCopyWith<$Res> get event {
  
  return $AttendeeEventRefCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
