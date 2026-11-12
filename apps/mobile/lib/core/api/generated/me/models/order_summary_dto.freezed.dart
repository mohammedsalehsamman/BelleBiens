// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderSummaryDto {


/// Create a copy of OrderSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSummaryDtoCopyWith<OrderSummaryDto> get copyWith => _$OrderSummaryDtoCopyWithImpl<OrderSummaryDto>(this as OrderSummaryDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderSummaryDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSummaryDto&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.fulfillment, _this.fulfillment) || other.fulfillment == _this.fulfillment)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.itemCount, _this.itemCount) || other.itemCount == _this.itemCount)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.totalMinor, _this.totalMinor) || other.totalMinor == _this.totalMinor)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as OrderSummaryDto;
  return Object.hash(runtimeType,_this.createdAt,_this.fulfillment,_this.imageUrl,_this.itemCount,_this.number,_this.slot,_this.status,_this.totalMinor,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as OrderSummaryDto;
  return 'OrderSummaryDto(createdAt: ${_this.createdAt}, fulfillment: ${_this.fulfillment}, imageUrl: ${_this.imageUrl}, itemCount: ${_this.itemCount}, number: ${_this.number}, slot: ${_this.slot}, status: ${_this.status}, totalMinor: ${_this.totalMinor}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $OrderSummaryDtoCopyWith<$Res>  {
  factory $OrderSummaryDtoCopyWith(OrderSummaryDto value, $Res Function(OrderSummaryDto) _then) = _$OrderSummaryDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: OrderSummaryDto._read_createdAt, toJson: OrderSummaryDto._write_createdAt) DateTime createdAt,@JsonKey(required: true, disallowNullValue: true, fromJson: OrderSummaryDto._read_fulfillment, toJson: OrderSummaryDto._write_fulfillment) Fulfillment fulfillment,@JsonKey(disallowNullValue: true, includeIfNull: false) String? imageUrl,@JsonKey(required: true, disallowNullValue: true, fromJson: OrderSummaryDto._read_itemCount, toJson: OrderSummaryDto._write_itemCount) int itemCount,@JsonKey(required: true, disallowNullValue: true) String number,@JsonKey(required: true, disallowNullValue: true) OrderSlotDto slot,@JsonKey(required: true, disallowNullValue: true, fromJson: OrderSummaryDto._read_status, toJson: OrderSummaryDto._write_status) OrderStatus status,@JsonKey(required: true, disallowNullValue: true, fromJson: OrderSummaryDto._read_totalMinor, toJson: OrderSummaryDto._write_totalMinor) int totalMinor,@JsonKey(readValue: OrderSummaryDto._extras, fromJson: OrderSummaryDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$OrderSlotDtoCopyWith<$Res> get slot;

}
/// @nodoc
class _$OrderSummaryDtoCopyWithImpl<$Res>
    implements $OrderSummaryDtoCopyWith<$Res> {
  _$OrderSummaryDtoCopyWithImpl(this._self, this._then);

  final OrderSummaryDto _self;
  final $Res Function(OrderSummaryDto) _then;

/// Create a copy of OrderSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? createdAt = null,Object? fulfillment = null,Object? imageUrl = freezed,Object? itemCount = null,Object? number = null,Object? slot = null,Object? status = null,Object? totalMinor = null,Object? additionalProperties = null,}) {
  return _then(OrderSummaryDto(
createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fulfillment: null == fulfillment ? _self.fulfillment : fulfillment // ignore: cast_nullable_to_non_nullable
as Fulfillment,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as OrderSlotDto,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of OrderSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderSlotDtoCopyWith<$Res> get slot {
  
  return $OrderSlotDtoCopyWith<$Res>(_self.slot, (value) {
    return _then(_self.copyWith(slot: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderSummaryDto].
extension OrderSummaryDtoPatterns on OrderSummaryDto {
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
