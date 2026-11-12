// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_mode_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShopModeDto {


/// Create a copy of ShopModeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopModeDtoCopyWith<ShopModeDto> get copyWith => _$ShopModeDtoCopyWithImpl<ShopModeDto>(this as ShopModeDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShopModeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopModeDto&&(identical(other.acceptsFrom, _this.acceptsFrom) || other.acceptsFrom == _this.acceptsFrom)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as ShopModeDto;
  return Object.hash(runtimeType,_this.acceptsFrom,_this.message,_this.mode,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as ShopModeDto;
  return 'ShopModeDto(acceptsFrom: ${_this.acceptsFrom}, message: ${_this.message}, mode: ${_this.mode}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $ShopModeDtoCopyWith<$Res>  {
  factory $ShopModeDtoCopyWith(ShopModeDto value, $Res Function(ShopModeDto) _then) = _$ShopModeDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) String? acceptsFrom,@JsonKey(disallowNullValue: true, includeIfNull: false) MessageInputDto? message,@JsonKey(required: true, disallowNullValue: true, fromJson: ShopModeDto._read_mode, toJson: ShopModeDto._write_mode) ShopModeDtoMode mode,@JsonKey(readValue: ShopModeDto._extras, fromJson: ShopModeDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$MessageInputDtoCopyWith<$Res>? get message;

}
/// @nodoc
class _$ShopModeDtoCopyWithImpl<$Res>
    implements $ShopModeDtoCopyWith<$Res> {
  _$ShopModeDtoCopyWithImpl(this._self, this._then);

  final ShopModeDto _self;
  final $Res Function(ShopModeDto) _then;

/// Create a copy of ShopModeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? acceptsFrom = freezed,Object? message = freezed,Object? mode = null,Object? additionalProperties = null,}) {
  return _then(ShopModeDto(
acceptsFrom: freezed == acceptsFrom ? _self.acceptsFrom : acceptsFrom // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as MessageInputDto?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ShopModeDtoMode,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of ShopModeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageInputDtoCopyWith<$Res>? get message {
    if (_self.message == null) {
    return null;
  }

  return $MessageInputDtoCopyWith<$Res>(_self.message!, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShopModeDto].
extension ShopModeDtoPatterns on ShopModeDto {
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
