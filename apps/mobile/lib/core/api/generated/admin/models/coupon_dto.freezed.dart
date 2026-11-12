// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CouponDto {


/// Create a copy of CouponDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponDtoCopyWith<CouponDto> get copyWith => _$CouponDtoCopyWithImpl<CouponDto>(this as CouponDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CouponDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouponDto&&(identical(other.active, _this.active) || other.active == _this.active)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.maxRedemptions, _this.maxRedemptions) || other.maxRedemptions == _this.maxRedemptions)&&(identical(other.minOrderMinor, _this.minOrderMinor) || other.minOrderMinor == _this.minOrderMinor)&&(identical(other.redemptions, _this.redemptions) || other.redemptions == _this.redemptions)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.type2, _this.type2) || other.type2 == _this.type2)&&(identical(other.value, _this.value) || other.value == _this.value)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as CouponDto;
  return Object.hash(runtimeType,_this.active,_this.code,_this.endsAt,_this.id,_this.maxRedemptions,_this.minOrderMinor,_this.redemptions,_this.startsAt,_this.type2,_this.value,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as CouponDto;
  return 'CouponDto(active: ${_this.active}, code: ${_this.code}, endsAt: ${_this.endsAt}, id: ${_this.id}, maxRedemptions: ${_this.maxRedemptions}, minOrderMinor: ${_this.minOrderMinor}, redemptions: ${_this.redemptions}, startsAt: ${_this.startsAt}, type2: ${_this.type2}, value: ${_this.value}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $CouponDtoCopyWith<$Res>  {
  factory $CouponDtoCopyWith(CouponDto value, $Res Function(CouponDto) _then) = _$CouponDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) bool? active,@JsonKey(required: true, disallowNullValue: true) String code,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: CouponDto._read_endsAt, toJson: CouponDto._write_endsAt) DateTime? endsAt,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(disallowNullValue: true, includeIfNull: false) num? maxRedemptions,@JsonKey(disallowNullValue: true, includeIfNull: false) num? minOrderMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: CouponDto._read_redemptions, toJson: CouponDto._write_redemptions) int redemptions,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: CouponDto._read_startsAt, toJson: CouponDto._write_startsAt) DateTime? startsAt,@JsonKey(name: "type", required: true, disallowNullValue: true, fromJson: CouponDto._read_type2, toJson: CouponDto._write_type2) CouponDtoType type2,@JsonKey(required: true, disallowNullValue: true) num value,@JsonKey(readValue: CouponDto._extras, fromJson: CouponDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$CouponDtoCopyWithImpl<$Res>
    implements $CouponDtoCopyWith<$Res> {
  _$CouponDtoCopyWithImpl(this._self, this._then);

  final CouponDto _self;
  final $Res Function(CouponDto) _then;

/// Create a copy of CouponDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? active = freezed,Object? code = null,Object? endsAt = freezed,Object? id = null,Object? maxRedemptions = freezed,Object? minOrderMinor = freezed,Object? redemptions = null,Object? startsAt = freezed,Object? type2 = null,Object? value = null,Object? additionalProperties = null,}) {
  return _then(CouponDto(
active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,maxRedemptions: freezed == maxRedemptions ? _self.maxRedemptions : maxRedemptions // ignore: cast_nullable_to_non_nullable
as num?,minOrderMinor: freezed == minOrderMinor ? _self.minOrderMinor : minOrderMinor // ignore: cast_nullable_to_non_nullable
as num?,redemptions: null == redemptions ? _self.redemptions : redemptions // ignore: cast_nullable_to_non_nullable
as int,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,type2: null == type2 ? _self.type2 : type2 // ignore: cast_nullable_to_non_nullable
as CouponDtoType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [CouponDto].
extension CouponDtoPatterns on CouponDto {
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
