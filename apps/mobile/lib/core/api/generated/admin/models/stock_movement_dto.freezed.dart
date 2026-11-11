// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_movement_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockMovementDto {


/// Create a copy of StockMovementDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMovementDtoCopyWith<StockMovementDto> get copyWith => _$StockMovementDtoCopyWithImpl<StockMovementDto>(this as StockMovementDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StockMovementDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMovementDto&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.delta, _this.delta) || other.delta == _this.delta)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.quantityAfter, _this.quantityAfter) || other.quantityAfter == _this.quantityAfter)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as StockMovementDto;
  return Object.hash(runtimeType,_this.createdAt,_this.delta,_this.id,_this.quantityAfter,_this.reason,_this.slug,_this.target,_this.userId,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as StockMovementDto;
  return 'StockMovementDto(createdAt: ${_this.createdAt}, delta: ${_this.delta}, id: ${_this.id}, quantityAfter: ${_this.quantityAfter}, reason: ${_this.reason}, slug: ${_this.slug}, target: ${_this.target}, userId: ${_this.userId}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $StockMovementDtoCopyWith<$Res>  {
  factory $StockMovementDtoCopyWith(StockMovementDto value, $Res Function(StockMovementDto) _then) = _$StockMovementDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: StockMovementDto._read_createdAt, toJson: StockMovementDto._write_createdAt) DateTime createdAt,@JsonKey(required: true, disallowNullValue: true) num delta,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true, disallowNullValue: true) num quantityAfter,@JsonKey(required: true, disallowNullValue: true) String reason,@JsonKey(required: true, disallowNullValue: true) String slug,@JsonKey(required: true, disallowNullValue: true, fromJson: StockMovementDto._read_target, toJson: StockMovementDto._write_target) StockMovementDtoTarget target,@JsonKey(required: true) String? userId,@JsonKey(readValue: StockMovementDto._extras, fromJson: StockMovementDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$StockMovementDtoCopyWithImpl<$Res>
    implements $StockMovementDtoCopyWith<$Res> {
  _$StockMovementDtoCopyWithImpl(this._self, this._then);

  final StockMovementDto _self;
  final $Res Function(StockMovementDto) _then;

/// Create a copy of StockMovementDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? createdAt = null,Object? delta = null,Object? id = null,Object? quantityAfter = null,Object? reason = null,Object? slug = null,Object? target = null,Object? userId = freezed,Object? additionalProperties = null,}) {
  return _then(StockMovementDto(
createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as num,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,quantityAfter: null == quantityAfter ? _self.quantityAfter : quantityAfter // ignore: cast_nullable_to_non_nullable
as num,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as StockMovementDtoTarget,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [StockMovementDto].
extension StockMovementDtoPatterns on StockMovementDto {
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
