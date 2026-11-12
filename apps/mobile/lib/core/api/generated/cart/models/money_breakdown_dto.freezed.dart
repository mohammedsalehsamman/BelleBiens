// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_breakdown_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MoneyBreakdownDto {


/// Create a copy of MoneyBreakdownDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoneyBreakdownDtoCopyWith<MoneyBreakdownDto> get copyWith => _$MoneyBreakdownDtoCopyWithImpl<MoneyBreakdownDto>(this as MoneyBreakdownDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MoneyBreakdownDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyBreakdownDto&&(identical(other.assemblyFeeMinor, _this.assemblyFeeMinor) || other.assemblyFeeMinor == _this.assemblyFeeMinor)&&(identical(other.deliveryFeeMinor, _this.deliveryFeeMinor) || other.deliveryFeeMinor == _this.deliveryFeeMinor)&&(identical(other.discountMinor, _this.discountMinor) || other.discountMinor == _this.discountMinor)&&(identical(other.itemsMinor, _this.itemsMinor) || other.itemsMinor == _this.itemsMinor)&&(identical(other.roundingAdjustmentMinor, _this.roundingAdjustmentMinor) || other.roundingAdjustmentMinor == _this.roundingAdjustmentMinor)&&(identical(other.totalMinor, _this.totalMinor) || other.totalMinor == _this.totalMinor)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as MoneyBreakdownDto;
  return Object.hash(runtimeType,_this.assemblyFeeMinor,_this.deliveryFeeMinor,_this.discountMinor,_this.itemsMinor,_this.roundingAdjustmentMinor,_this.totalMinor,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as MoneyBreakdownDto;
  return 'MoneyBreakdownDto(assemblyFeeMinor: ${_this.assemblyFeeMinor}, deliveryFeeMinor: ${_this.deliveryFeeMinor}, discountMinor: ${_this.discountMinor}, itemsMinor: ${_this.itemsMinor}, roundingAdjustmentMinor: ${_this.roundingAdjustmentMinor}, totalMinor: ${_this.totalMinor}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $MoneyBreakdownDtoCopyWith<$Res>  {
  factory $MoneyBreakdownDtoCopyWith(MoneyBreakdownDto value, $Res Function(MoneyBreakdownDto) _then) = _$MoneyBreakdownDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: MoneyBreakdownDto._read_assemblyFeeMinor, toJson: MoneyBreakdownDto._write_assemblyFeeMinor) int assemblyFeeMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: MoneyBreakdownDto._read_deliveryFeeMinor, toJson: MoneyBreakdownDto._write_deliveryFeeMinor) int deliveryFeeMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: MoneyBreakdownDto._read_discountMinor, toJson: MoneyBreakdownDto._write_discountMinor) int discountMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: MoneyBreakdownDto._read_itemsMinor, toJson: MoneyBreakdownDto._write_itemsMinor) int itemsMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: MoneyBreakdownDto._read_roundingAdjustmentMinor, toJson: MoneyBreakdownDto._write_roundingAdjustmentMinor) int roundingAdjustmentMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: MoneyBreakdownDto._read_totalMinor, toJson: MoneyBreakdownDto._write_totalMinor) int totalMinor,@JsonKey(readValue: MoneyBreakdownDto._extras, fromJson: MoneyBreakdownDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$MoneyBreakdownDtoCopyWithImpl<$Res>
    implements $MoneyBreakdownDtoCopyWith<$Res> {
  _$MoneyBreakdownDtoCopyWithImpl(this._self, this._then);

  final MoneyBreakdownDto _self;
  final $Res Function(MoneyBreakdownDto) _then;

/// Create a copy of MoneyBreakdownDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assemblyFeeMinor = null,Object? deliveryFeeMinor = null,Object? discountMinor = null,Object? itemsMinor = null,Object? roundingAdjustmentMinor = null,Object? totalMinor = null,Object? additionalProperties = null,}) {
  return _then(MoneyBreakdownDto(
assemblyFeeMinor: null == assemblyFeeMinor ? _self.assemblyFeeMinor : assemblyFeeMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,itemsMinor: null == itemsMinor ? _self.itemsMinor : itemsMinor // ignore: cast_nullable_to_non_nullable
as int,roundingAdjustmentMinor: null == roundingAdjustmentMinor ? _self.roundingAdjustmentMinor : roundingAdjustmentMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [MoneyBreakdownDto].
extension MoneyBreakdownDtoPatterns on MoneyBreakdownDto {
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
