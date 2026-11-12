// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CouponInputDto {


/// Create a copy of CouponInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponInputDtoCopyWith<CouponInputDto> get copyWith => _$CouponInputDtoCopyWithImpl<CouponInputDto>(this as CouponInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CouponInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouponInputDto&&(identical(other.active, _this.active) || other.active == _this.active)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.maxRedemptions, _this.maxRedemptions) || other.maxRedemptions == _this.maxRedemptions)&&(identical(other.minOrderMinor, _this.minOrderMinor) || other.minOrderMinor == _this.minOrderMinor)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.type2, _this.type2) || other.type2 == _this.type2)&&(identical(other.value, _this.value) || other.value == _this.value)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as CouponInputDto;
  return Object.hash(runtimeType,_this.active,_this.code,_this.endsAt,_this.maxRedemptions,_this.minOrderMinor,_this.startsAt,_this.type2,_this.value,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as CouponInputDto;
  return 'CouponInputDto(active: ${_this.active}, code: ${_this.code}, endsAt: ${_this.endsAt}, maxRedemptions: ${_this.maxRedemptions}, minOrderMinor: ${_this.minOrderMinor}, startsAt: ${_this.startsAt}, type2: ${_this.type2}, value: ${_this.value}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $CouponInputDtoCopyWith<$Res>  {
  factory $CouponInputDtoCopyWith(CouponInputDto value, $Res Function(CouponInputDto) _then) = _$CouponInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) bool? active,@JsonKey(required: true, disallowNullValue: true) String code,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: CouponInputDto._read_endsAt, toJson: CouponInputDto._write_endsAt) DateTime? endsAt,@JsonKey(disallowNullValue: true, includeIfNull: false) num? maxRedemptions,@JsonKey(disallowNullValue: true, includeIfNull: false) num? minOrderMinor,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: CouponInputDto._read_startsAt, toJson: CouponInputDto._write_startsAt) DateTime? startsAt,@JsonKey(name: "type", required: true, disallowNullValue: true, fromJson: CouponInputDto._read_type2, toJson: CouponInputDto._write_type2) CouponInputDtoType type2,@JsonKey(required: true, disallowNullValue: true) num value,@JsonKey(readValue: CouponInputDto._extras, fromJson: CouponInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$CouponInputDtoCopyWithImpl<$Res>
    implements $CouponInputDtoCopyWith<$Res> {
  _$CouponInputDtoCopyWithImpl(this._self, this._then);

  final CouponInputDto _self;
  final $Res Function(CouponInputDto) _then;

/// Create a copy of CouponInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? active = freezed,Object? code = null,Object? endsAt = freezed,Object? maxRedemptions = freezed,Object? minOrderMinor = freezed,Object? startsAt = freezed,Object? type2 = null,Object? value = null,Object? additionalProperties = null,}) {
  return _then(CouponInputDto(
active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,maxRedemptions: freezed == maxRedemptions ? _self.maxRedemptions : maxRedemptions // ignore: cast_nullable_to_non_nullable
as num?,minOrderMinor: freezed == minOrderMinor ? _self.minOrderMinor : minOrderMinor // ignore: cast_nullable_to_non_nullable
as num?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,type2: null == type2 ? _self.type2 : type2 // ignore: cast_nullable_to_non_nullable
as CouponInputDtoType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [CouponInputDto].
extension CouponInputDtoPatterns on CouponInputDto {
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
