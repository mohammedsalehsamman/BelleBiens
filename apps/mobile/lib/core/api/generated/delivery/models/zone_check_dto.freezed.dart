// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone_check_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ZoneCheckDto {


/// Create a copy of ZoneCheckDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoneCheckDtoCopyWith<ZoneCheckDto> get copyWith => _$ZoneCheckDtoCopyWithImpl<ZoneCheckDto>(this as ZoneCheckDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ZoneCheckDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZoneCheckDto&&(identical(other.inZone, _this.inZone) || other.inZone == _this.inZone)&&(identical(other.zone, _this.zone) || other.zone == _this.zone)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as ZoneCheckDto;
  return Object.hash(runtimeType,_this.inZone,_this.zone,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as ZoneCheckDto;
  return 'ZoneCheckDto(inZone: ${_this.inZone}, zone: ${_this.zone}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $ZoneCheckDtoCopyWith<$Res>  {
  factory $ZoneCheckDtoCopyWith(ZoneCheckDto value, $Res Function(ZoneCheckDto) _then) = _$ZoneCheckDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) bool inZone,@JsonKey(disallowNullValue: true, includeIfNull: false) ZoneDto? zone,@JsonKey(readValue: ZoneCheckDto._extras, fromJson: ZoneCheckDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$ZoneDtoCopyWith<$Res>? get zone;

}
/// @nodoc
class _$ZoneCheckDtoCopyWithImpl<$Res>
    implements $ZoneCheckDtoCopyWith<$Res> {
  _$ZoneCheckDtoCopyWithImpl(this._self, this._then);

  final ZoneCheckDto _self;
  final $Res Function(ZoneCheckDto) _then;

/// Create a copy of ZoneCheckDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inZone = null,Object? zone = freezed,Object? additionalProperties = null,}) {
  return _then(ZoneCheckDto(
inZone: null == inZone ? _self.inZone : inZone // ignore: cast_nullable_to_non_nullable
as bool,zone: freezed == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as ZoneDto?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of ZoneCheckDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ZoneDtoCopyWith<$Res>? get zone {
    if (_self.zone == null) {
    return null;
  }

  return $ZoneDtoCopyWith<$Res>(_self.zone!, (value) {
    return _then(_self.copyWith(zone: value));
  });
}
}


/// Adds pattern-matching-related methods to [ZoneCheckDto].
extension ZoneCheckDtoPatterns on ZoneCheckDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
