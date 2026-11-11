// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_adjustment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockAdjustmentDto {


/// Create a copy of StockAdjustmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockAdjustmentDtoCopyWith<StockAdjustmentDto> get copyWith => _$StockAdjustmentDtoCopyWithImpl<StockAdjustmentDto>(this as StockAdjustmentDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StockAdjustmentDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockAdjustmentDto&&(identical(other.delta, _this.delta) || other.delta == _this.delta)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.target, _this.target) || other.target == _this.target)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as StockAdjustmentDto;
  return Object.hash(runtimeType,_this.delta,_this.reason,_this.slug,_this.target,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as StockAdjustmentDto;
  return 'StockAdjustmentDto(delta: ${_this.delta}, reason: ${_this.reason}, slug: ${_this.slug}, target: ${_this.target}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $StockAdjustmentDtoCopyWith<$Res>  {
  factory $StockAdjustmentDtoCopyWith(StockAdjustmentDto value, $Res Function(StockAdjustmentDto) _then) = _$StockAdjustmentDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) num delta,@JsonKey(required: true, disallowNullValue: true) String reason,@JsonKey(required: true, disallowNullValue: true) String slug,@JsonKey(required: true, disallowNullValue: true, fromJson: StockAdjustmentDto._read_target, toJson: StockAdjustmentDto._write_target) StockAdjustmentDtoTarget target,@JsonKey(readValue: StockAdjustmentDto._extras, fromJson: StockAdjustmentDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$StockAdjustmentDtoCopyWithImpl<$Res>
    implements $StockAdjustmentDtoCopyWith<$Res> {
  _$StockAdjustmentDtoCopyWithImpl(this._self, this._then);

  final StockAdjustmentDto _self;
  final $Res Function(StockAdjustmentDto) _then;

/// Create a copy of StockAdjustmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? delta = null,Object? reason = null,Object? slug = null,Object? target = null,Object? additionalProperties = null,}) {
  return _then(StockAdjustmentDto(
delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as num,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as StockAdjustmentDtoTarget,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [StockAdjustmentDto].
extension StockAdjustmentDtoPatterns on StockAdjustmentDto {
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
