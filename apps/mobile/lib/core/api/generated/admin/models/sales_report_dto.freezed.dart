// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_report_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SalesReportDto {


/// Create a copy of SalesReportDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesReportDtoCopyWith<SalesReportDto> get copyWith => _$SalesReportDtoCopyWithImpl<SalesReportDto>(this as SalesReportDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SalesReportDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesReportDto&&const DeepCollectionEquality().equals(other.byCategory, _this.byCategory)&&const DeepCollectionEquality().equals(other.byPaymentMethod, _this.byPaymentMethod)&&const DeepCollectionEquality().equals(other.byProduct, _this.byProduct)&&const DeepCollectionEquality().equals(other.byZone, _this.byZone)&&const DeepCollectionEquality().equals(other.coupons, _this.coupons)&&(identical(other.orders, _this.orders) || other.orders == _this.orders)&&const DeepCollectionEquality().equals(other.periods, _this.periods)&&(identical(other.totalMinor, _this.totalMinor) || other.totalMinor == _this.totalMinor)&&(identical(other.totalUsdCents, _this.totalUsdCents) || other.totalUsdCents == _this.totalUsdCents)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as SalesReportDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.byCategory),const DeepCollectionEquality().hash(_this.byPaymentMethod),const DeepCollectionEquality().hash(_this.byProduct),const DeepCollectionEquality().hash(_this.byZone),const DeepCollectionEquality().hash(_this.coupons),_this.orders,const DeepCollectionEquality().hash(_this.periods),_this.totalMinor,_this.totalUsdCents,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as SalesReportDto;
  return 'SalesReportDto(byCategory: ${_this.byCategory}, byPaymentMethod: ${_this.byPaymentMethod}, byProduct: ${_this.byProduct}, byZone: ${_this.byZone}, coupons: ${_this.coupons}, orders: ${_this.orders}, periods: ${_this.periods}, totalMinor: ${_this.totalMinor}, totalUsdCents: ${_this.totalUsdCents}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $SalesReportDtoCopyWith<$Res>  {
  factory $SalesReportDtoCopyWith(SalesReportDto value, $Res Function(SalesReportDto) _then) = _$SalesReportDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) List<LineBucketDto> byCategory,@JsonKey(required: true, disallowNullValue: true) List<BucketDto> byPaymentMethod,@JsonKey(required: true, disallowNullValue: true) List<LineBucketDto> byProduct,@JsonKey(required: true, disallowNullValue: true) List<BucketDto> byZone,@JsonKey(required: true, disallowNullValue: true) List<CouponBucketDto> coupons,@JsonKey(required: true, disallowNullValue: true, fromJson: SalesReportDto._read_orders, toJson: SalesReportDto._write_orders) int orders,@JsonKey(required: true, disallowNullValue: true) List<BucketDto> periods,@JsonKey(required: true, disallowNullValue: true, fromJson: SalesReportDto._read_totalMinor, toJson: SalesReportDto._write_totalMinor) int totalMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: SalesReportDto._read_totalUsdCents, toJson: SalesReportDto._write_totalUsdCents) int totalUsdCents,@JsonKey(readValue: SalesReportDto._extras, fromJson: SalesReportDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$SalesReportDtoCopyWithImpl<$Res>
    implements $SalesReportDtoCopyWith<$Res> {
  _$SalesReportDtoCopyWithImpl(this._self, this._then);

  final SalesReportDto _self;
  final $Res Function(SalesReportDto) _then;

/// Create a copy of SalesReportDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? byCategory = null,Object? byPaymentMethod = null,Object? byProduct = null,Object? byZone = null,Object? coupons = null,Object? orders = null,Object? periods = null,Object? totalMinor = null,Object? totalUsdCents = null,Object? additionalProperties = null,}) {
  return _then(SalesReportDto(
byCategory: null == byCategory ? _self.byCategory : byCategory // ignore: cast_nullable_to_non_nullable
as List<LineBucketDto>,byPaymentMethod: null == byPaymentMethod ? _self.byPaymentMethod : byPaymentMethod // ignore: cast_nullable_to_non_nullable
as List<BucketDto>,byProduct: null == byProduct ? _self.byProduct : byProduct // ignore: cast_nullable_to_non_nullable
as List<LineBucketDto>,byZone: null == byZone ? _self.byZone : byZone // ignore: cast_nullable_to_non_nullable
as List<BucketDto>,coupons: null == coupons ? _self.coupons : coupons // ignore: cast_nullable_to_non_nullable
as List<CouponBucketDto>,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,periods: null == periods ? _self.periods : periods // ignore: cast_nullable_to_non_nullable
as List<BucketDto>,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,totalUsdCents: null == totalUsdCents ? _self.totalUsdCents : totalUsdCents // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesReportDto].
extension SalesReportDtoPatterns on SalesReportDto {
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
