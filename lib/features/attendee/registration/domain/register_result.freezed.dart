// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterResult {

 RegisterOutcome get outcome;/// Present for confirmed, waitlisted, and duplicate.
 Ticket? get ticket;
/// Create a copy of RegisterResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterResultCopyWith<RegisterResult> get copyWith => _$RegisterResultCopyWithImpl<RegisterResult>(this as RegisterResult, _$identity);

  /// Serializes this RegisterResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RegisterResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterResult&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.ticket, _this.ticket) || other.ticket == _this.ticket));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RegisterResult;
  return Object.hash(runtimeType,_this.outcome,_this.ticket);
}

@override
String toString() {
  final _this = this as RegisterResult;
  return 'RegisterResult(outcome: ${_this.outcome}, ticket: ${_this.ticket})';
}


}

/// @nodoc
abstract mixin class $RegisterResultCopyWith<$Res>  {
  factory $RegisterResultCopyWith(RegisterResult value, $Res Function(RegisterResult) _then) = _$RegisterResultCopyWithImpl;
@useResult
$Res call({
 RegisterOutcome outcome, Ticket? ticket
});


$TicketCopyWith<$Res>? get ticket;

}
/// @nodoc
class _$RegisterResultCopyWithImpl<$Res>
    implements $RegisterResultCopyWith<$Res> {
  _$RegisterResultCopyWithImpl(this._self, this._then);

  final RegisterResult _self;
  final $Res Function(RegisterResult) _then;

/// Create a copy of RegisterResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outcome = null,Object? ticket = freezed,}) {
  return _then(RegisterResult(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as RegisterOutcome,ticket: freezed == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as Ticket?,
  ));
}
/// Create a copy of RegisterResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketCopyWith<$Res>? get ticket {
    if (_self.ticket == null) {
    return null;
  }

  return $TicketCopyWith<$Res>(_self.ticket!, (value) {
    return _then(_self.copyWith(ticket: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegisterResult].
extension RegisterResultPatterns on RegisterResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterResult value)  $default,){
final _that = this;
switch (_that) {
case _RegisterResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterResult value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RegisterOutcome outcome,  Ticket? ticket)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterResult() when $default != null:
return $default(_that.outcome,_that.ticket);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RegisterOutcome outcome,  Ticket? ticket)  $default,) {final _that = this;
switch (_that) {
case _RegisterResult():
return $default(_that.outcome,_that.ticket);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RegisterOutcome outcome,  Ticket? ticket)?  $default,) {final _that = this;
switch (_that) {
case _RegisterResult() when $default != null:
return $default(_that.outcome,_that.ticket);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterResult extends RegisterResult {
  const _RegisterResult({required this.outcome, this.ticket}): super._();
  factory _RegisterResult.fromJson(Map<String, dynamic> json) => _$RegisterResultFromJson(json);

@override final  RegisterOutcome outcome;
/// Present for confirmed, waitlisted, and duplicate.
@override final  Ticket? ticket;

/// Create a copy of RegisterResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterResultCopyWith<_RegisterResult> get copyWith => __$RegisterResultCopyWithImpl<_RegisterResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterResult&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.ticket, ticket) || other.ticket == ticket));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,outcome,ticket);
}

@override
String toString() {
    return 'RegisterResult(outcome: $outcome, ticket: $ticket)';
}


}

/// @nodoc
abstract mixin class _$RegisterResultCopyWith<$Res> implements $RegisterResultCopyWith<$Res> {
  factory _$RegisterResultCopyWith(_RegisterResult value, $Res Function(_RegisterResult) _then) = __$RegisterResultCopyWithImpl;
@override @useResult
$Res call({
 RegisterOutcome outcome, Ticket? ticket
});


@override $TicketCopyWith<$Res>? get ticket;

}
/// @nodoc
class __$RegisterResultCopyWithImpl<$Res>
    implements _$RegisterResultCopyWith<$Res> {
  __$RegisterResultCopyWithImpl(this._self, this._then);

  final _RegisterResult _self;
  final $Res Function(_RegisterResult) _then;

/// Create a copy of RegisterResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outcome = null,Object? ticket = freezed,}) {
  return _then(_RegisterResult(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as RegisterOutcome,ticket: freezed == ticket ? _self.ticket : ticket // ignore: cast_nullable_to_non_nullable
as Ticket?,
  ));
}

/// Create a copy of RegisterResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketCopyWith<$Res>? get ticket {
    if (_self.ticket == null) {
    return null;
  }

  return $TicketCopyWith<$Res>(_self.ticket!, (value) {
    return _then(_self.copyWith(ticket: value));
  });
}
}

// dart format on
