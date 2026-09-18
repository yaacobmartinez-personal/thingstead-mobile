// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Ticket {

 String get id; RegistrationStatus get status; String? get name; String get email; DateTime? get checkedInAt;/// Null once erased; the QR encodes it.
 String? get checkInToken; DateTime get createdAt;/// True once the event has begun — cancelling changes nothing real then.
 bool get started; TicketOrg get org; TicketEvent get event;
/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketCopyWith<Ticket> get copyWith => _$TicketCopyWithImpl<Ticket>(this as Ticket, _$identity);

  /// Serializes this Ticket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Ticket;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ticket&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.checkedInAt, _this.checkedInAt) || other.checkedInAt == _this.checkedInAt)&&(identical(other.checkInToken, _this.checkInToken) || other.checkInToken == _this.checkInToken)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.started, _this.started) || other.started == _this.started)&&(identical(other.org, _this.org) || other.org == _this.org)&&(identical(other.event, _this.event) || other.event == _this.event));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Ticket;
  return Object.hash(runtimeType,_this.id,_this.status,_this.name,_this.email,_this.checkedInAt,_this.checkInToken,_this.createdAt,_this.started,_this.org,_this.event);
}

@override
String toString() {
  final _this = this as Ticket;
  return 'Ticket(id: ${_this.id}, status: ${_this.status}, name: ${_this.name}, email: ${_this.email}, checkedInAt: ${_this.checkedInAt}, checkInToken: ${_this.checkInToken}, createdAt: ${_this.createdAt}, started: ${_this.started}, org: ${_this.org}, event: ${_this.event})';
}


}

/// @nodoc
abstract mixin class $TicketCopyWith<$Res>  {
  factory $TicketCopyWith(Ticket value, $Res Function(Ticket) _then) = _$TicketCopyWithImpl;
@useResult
$Res call({
 String id, RegistrationStatus status, String? name, String email, DateTime? checkedInAt, String? checkInToken, DateTime createdAt, bool started, TicketOrg org, TicketEvent event
});


$TicketOrgCopyWith<$Res> get org;$TicketEventCopyWith<$Res> get event;

}
/// @nodoc
class _$TicketCopyWithImpl<$Res>
    implements $TicketCopyWith<$Res> {
  _$TicketCopyWithImpl(this._self, this._then);

  final Ticket _self;
  final $Res Function(Ticket) _then;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? name = freezed,Object? email = null,Object? checkedInAt = freezed,Object? checkInToken = freezed,Object? createdAt = null,Object? started = null,Object? org = null,Object? event = null,}) {
  return _then(Ticket(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RegistrationStatus,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkInToken: freezed == checkInToken ? _self.checkInToken : checkInToken // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,started: null == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as bool,org: null == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as TicketOrg,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as TicketEvent,
  ));
}
/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketOrgCopyWith<$Res> get org {
  
  return $TicketOrgCopyWith<$Res>(_self.org, (value) {
    return _then(_self.copyWith(org: value));
  });
}/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketEventCopyWith<$Res> get event {
  
  return $TicketEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [Ticket].
extension TicketPatterns on Ticket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ticket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ticket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ticket value)  $default,){
final _that = this;
switch (_that) {
case _Ticket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ticket value)?  $default,){
final _that = this;
switch (_that) {
case _Ticket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  RegistrationStatus status,  String? name,  String email,  DateTime? checkedInAt,  String? checkInToken,  DateTime createdAt,  bool started,  TicketOrg org,  TicketEvent event)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that.id,_that.status,_that.name,_that.email,_that.checkedInAt,_that.checkInToken,_that.createdAt,_that.started,_that.org,_that.event);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  RegistrationStatus status,  String? name,  String email,  DateTime? checkedInAt,  String? checkInToken,  DateTime createdAt,  bool started,  TicketOrg org,  TicketEvent event)  $default,) {final _that = this;
switch (_that) {
case _Ticket():
return $default(_that.id,_that.status,_that.name,_that.email,_that.checkedInAt,_that.checkInToken,_that.createdAt,_that.started,_that.org,_that.event);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  RegistrationStatus status,  String? name,  String email,  DateTime? checkedInAt,  String? checkInToken,  DateTime createdAt,  bool started,  TicketOrg org,  TicketEvent event)?  $default,) {final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that.id,_that.status,_that.name,_that.email,_that.checkedInAt,_that.checkInToken,_that.createdAt,_that.started,_that.org,_that.event);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ticket extends Ticket {
  const _Ticket({required this.id, required this.status, this.name, required this.email, this.checkedInAt, this.checkInToken, required this.createdAt, this.started = false, required this.org, required this.event}): super._();
  factory _Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

@override final  String id;
@override final  RegistrationStatus status;
@override final  String? name;
@override final  String email;
@override final  DateTime? checkedInAt;
/// Null once erased; the QR encodes it.
@override final  String? checkInToken;
@override final  DateTime createdAt;
/// True once the event has begun — cancelling changes nothing real then.
@override@JsonKey() final  bool started;
@override final  TicketOrg org;
@override final  TicketEvent event;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketCopyWith<_Ticket> get copyWith => __$TicketCopyWithImpl<_Ticket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ticket&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.checkedInAt, checkedInAt) || other.checkedInAt == checkedInAt)&&(identical(other.checkInToken, checkInToken) || other.checkInToken == checkInToken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.started, started) || other.started == started)&&(identical(other.org, org) || other.org == org)&&(identical(other.event, event) || other.event == event));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,name,email,checkedInAt,checkInToken,createdAt,started,org,event);
}

@override
String toString() {
    return 'Ticket(id: $id, status: $status, name: $name, email: $email, checkedInAt: $checkedInAt, checkInToken: $checkInToken, createdAt: $createdAt, started: $started, org: $org, event: $event)';
}


}

/// @nodoc
abstract mixin class _$TicketCopyWith<$Res> implements $TicketCopyWith<$Res> {
  factory _$TicketCopyWith(_Ticket value, $Res Function(_Ticket) _then) = __$TicketCopyWithImpl;
@override @useResult
$Res call({
 String id, RegistrationStatus status, String? name, String email, DateTime? checkedInAt, String? checkInToken, DateTime createdAt, bool started, TicketOrg org, TicketEvent event
});


@override $TicketOrgCopyWith<$Res> get org;@override $TicketEventCopyWith<$Res> get event;

}
/// @nodoc
class __$TicketCopyWithImpl<$Res>
    implements _$TicketCopyWith<$Res> {
  __$TicketCopyWithImpl(this._self, this._then);

  final _Ticket _self;
  final $Res Function(_Ticket) _then;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? name = freezed,Object? email = null,Object? checkedInAt = freezed,Object? checkInToken = freezed,Object? createdAt = null,Object? started = null,Object? org = null,Object? event = null,}) {
  return _then(_Ticket(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RegistrationStatus,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkInToken: freezed == checkInToken ? _self.checkInToken : checkInToken // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,started: null == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as bool,org: null == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as TicketOrg,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as TicketEvent,
  ));
}

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketOrgCopyWith<$Res> get org {
  
  return $TicketOrgCopyWith<$Res>(_self.org, (value) {
    return _then(_self.copyWith(org: value));
  });
}/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketEventCopyWith<$Res> get event {
  
  return $TicketEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// @nodoc
mixin _$TicketOrg {

 String get slug; String get name;
/// Create a copy of TicketOrg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketOrgCopyWith<TicketOrg> get copyWith => _$TicketOrgCopyWithImpl<TicketOrg>(this as TicketOrg, _$identity);

  /// Serializes this TicketOrg to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TicketOrg;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketOrg&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TicketOrg;
  return Object.hash(runtimeType,_this.slug,_this.name);
}

@override
String toString() {
  final _this = this as TicketOrg;
  return 'TicketOrg(slug: ${_this.slug}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $TicketOrgCopyWith<$Res>  {
  factory $TicketOrgCopyWith(TicketOrg value, $Res Function(TicketOrg) _then) = _$TicketOrgCopyWithImpl;
@useResult
$Res call({
 String slug, String name
});




}
/// @nodoc
class _$TicketOrgCopyWithImpl<$Res>
    implements $TicketOrgCopyWith<$Res> {
  _$TicketOrgCopyWithImpl(this._self, this._then);

  final TicketOrg _self;
  final $Res Function(TicketOrg) _then;

/// Create a copy of TicketOrg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? name = null,}) {
  return _then(TicketOrg(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketOrg].
extension TicketOrgPatterns on TicketOrg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketOrg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketOrg() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketOrg value)  $default,){
final _that = this;
switch (_that) {
case _TicketOrg():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketOrg value)?  $default,){
final _that = this;
switch (_that) {
case _TicketOrg() when $default != null:
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
case _TicketOrg() when $default != null:
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
case _TicketOrg():
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
case _TicketOrg() when $default != null:
return $default(_that.slug,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TicketOrg implements TicketOrg {
  const _TicketOrg({required this.slug, required this.name});
  factory _TicketOrg.fromJson(Map<String, dynamic> json) => _$TicketOrgFromJson(json);

@override final  String slug;
@override final  String name;

/// Create a copy of TicketOrg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketOrgCopyWith<_TicketOrg> get copyWith => __$TicketOrgCopyWithImpl<_TicketOrg>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketOrgToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketOrg&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slug,name);
}

@override
String toString() {
    return 'TicketOrg(slug: $slug, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TicketOrgCopyWith<$Res> implements $TicketOrgCopyWith<$Res> {
  factory _$TicketOrgCopyWith(_TicketOrg value, $Res Function(_TicketOrg) _then) = __$TicketOrgCopyWithImpl;
@override @useResult
$Res call({
 String slug, String name
});




}
/// @nodoc
class __$TicketOrgCopyWithImpl<$Res>
    implements _$TicketOrgCopyWith<$Res> {
  __$TicketOrgCopyWithImpl(this._self, this._then);

  final _TicketOrg _self;
  final $Res Function(_TicketOrg) _then;

/// Create a copy of TicketOrg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? name = null,}) {
  return _then(_TicketOrg(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TicketEvent {

 String get slug; String get title; DateTime get startsAt; DateTime? get endsAt; String get timezone;
/// Create a copy of TicketEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketEventCopyWith<TicketEvent> get copyWith => _$TicketEventCopyWithImpl<TicketEvent>(this as TicketEvent, _$identity);

  /// Serializes this TicketEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TicketEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketEvent&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TicketEvent;
  return Object.hash(runtimeType,_this.slug,_this.title,_this.startsAt,_this.endsAt,_this.timezone);
}

@override
String toString() {
  final _this = this as TicketEvent;
  return 'TicketEvent(slug: ${_this.slug}, title: ${_this.title}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $TicketEventCopyWith<$Res>  {
  factory $TicketEventCopyWith(TicketEvent value, $Res Function(TicketEvent) _then) = _$TicketEventCopyWithImpl;
@useResult
$Res call({
 String slug, String title, DateTime startsAt, DateTime? endsAt, String timezone
});




}
/// @nodoc
class _$TicketEventCopyWithImpl<$Res>
    implements $TicketEventCopyWith<$Res> {
  _$TicketEventCopyWithImpl(this._self, this._then);

  final TicketEvent _self;
  final $Res Function(TicketEvent) _then;

/// Create a copy of TicketEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? title = null,Object? startsAt = null,Object? endsAt = freezed,Object? timezone = null,}) {
  return _then(TicketEvent(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketEvent].
extension TicketEventPatterns on TicketEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketEvent value)  $default,){
final _that = this;
switch (_that) {
case _TicketEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketEvent value)?  $default,){
final _that = this;
switch (_that) {
case _TicketEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String title,  DateTime startsAt,  DateTime? endsAt,  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketEvent() when $default != null:
return $default(_that.slug,_that.title,_that.startsAt,_that.endsAt,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String title,  DateTime startsAt,  DateTime? endsAt,  String timezone)  $default,) {final _that = this;
switch (_that) {
case _TicketEvent():
return $default(_that.slug,_that.title,_that.startsAt,_that.endsAt,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String title,  DateTime startsAt,  DateTime? endsAt,  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _TicketEvent() when $default != null:
return $default(_that.slug,_that.title,_that.startsAt,_that.endsAt,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TicketEvent implements TicketEvent {
  const _TicketEvent({required this.slug, required this.title, required this.startsAt, this.endsAt, required this.timezone});
  factory _TicketEvent.fromJson(Map<String, dynamic> json) => _$TicketEventFromJson(json);

@override final  String slug;
@override final  String title;
@override final  DateTime startsAt;
@override final  DateTime? endsAt;
@override final  String timezone;

/// Create a copy of TicketEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketEventCopyWith<_TicketEvent> get copyWith => __$TicketEventCopyWithImpl<_TicketEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketEvent&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slug,title,startsAt,endsAt,timezone);
}

@override
String toString() {
    return 'TicketEvent(slug: $slug, title: $title, startsAt: $startsAt, endsAt: $endsAt, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$TicketEventCopyWith<$Res> implements $TicketEventCopyWith<$Res> {
  factory _$TicketEventCopyWith(_TicketEvent value, $Res Function(_TicketEvent) _then) = __$TicketEventCopyWithImpl;
@override @useResult
$Res call({
 String slug, String title, DateTime startsAt, DateTime? endsAt, String timezone
});




}
/// @nodoc
class __$TicketEventCopyWithImpl<$Res>
    implements _$TicketEventCopyWith<$Res> {
  __$TicketEventCopyWithImpl(this._self, this._then);

  final _TicketEvent _self;
  final $Res Function(_TicketEvent) _then;

/// Create a copy of TicketEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? title = null,Object? startsAt = null,Object? endsAt = freezed,Object? timezone = null,}) {
  return _then(_TicketEvent(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
