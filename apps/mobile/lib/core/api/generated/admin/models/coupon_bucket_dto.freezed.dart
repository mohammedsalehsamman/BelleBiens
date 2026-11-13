// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_bucket_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CouponBucketDto {


/// Create a copy of CouponBucketDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponBucketDtoCopyWith<CouponBucketDto> get copyWith => _$CouponBucketDtoCopyWithImpl<CouponBucketDto>(this as CouponBucketDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CouponBucketDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouponBucketDto&&(identical(other.discountMinor, _this.discountMinor) || other.discountMinor == _this.discountMinor)&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.orders, _this.orders) || other.orders == _this.orders)&&(identical(other.totalMinor, _this.totalMinor) || other.totalMinor == _this.totalMinor)&&(identical(other.totalUsdCents, _this.totalUsdCents) || other.totalUsdCents == _this.totalUsdCents)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as CouponBucketDto;
  return Object.hash(runtimeType,_this.discountMinor,_this.key,_this.orders,_this.totalMinor,_this.totalUsdCents,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as CouponBucketDto;
  return 'CouponBucketDto(discountMinor: ${_this.discountMinor}, key: ${_this.key}, orders: ${_this.orders}, totalMinor: ${_this.totalMinor}, totalUsdCents: ${_this.totalUsdCents}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $CouponBucketDtoCopyWith<$Res>  {
  factory $CouponBucketDtoCopyWith(CouponBucketDto value, $Res Function(CouponBucketDto) _then) = _$CouponBucketDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: CouponBucketDto._read_discountMinor, toJson: CouponBucketDto._write_discountMinor) int discountMinor,@JsonKey(required: true, disallowNullValue: true) String key,@JsonKey(required: true, disallowNullValue: true, fromJson: CouponBucketDto._read_orders, toJson: CouponBucketDto._write_orders) int orders,@JsonKey(required: true, disallowNullValue: true, fromJson: CouponBucketDto._read_totalMinor, toJson: CouponBucketDto._write_totalMinor) int totalMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: CouponBucketDto._read_totalUsdCents, toJson: CouponBucketDto._write_totalUsdCents) int totalUsdCents,@JsonKey(readValue: CouponBucketDto._extras, fromJson: CouponBucketDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$CouponBucketDtoCopyWithImpl<$Res>
    implements $CouponBucketDtoCopyWith<$Res> {
  _$CouponBucketDtoCopyWithImpl(this._self, this._then);

  final CouponBucketDto _self;
  final $Res Function(CouponBucketDto) _then;

/// Create a copy of CouponBucketDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? discountMinor = null,Object? key = null,Object? orders = null,Object? totalMinor = null,Object? totalUsdCents = null,Object? additionalProperties = null,}) {
  return _then(CouponBucketDto(
discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,totalUsdCents: null == totalUsdCents ? _self.totalUsdCents : totalUsdCents // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [CouponBucketDto].
extension CouponBucketDtoPatterns on CouponBucketDto {
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
