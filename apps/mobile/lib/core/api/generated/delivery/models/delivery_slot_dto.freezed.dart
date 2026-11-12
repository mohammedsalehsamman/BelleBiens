// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_slot_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeliverySlotDto {


/// Create a copy of DeliverySlotDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliverySlotDtoCopyWith<DeliverySlotDto> get copyWith => _$DeliverySlotDtoCopyWithImpl<DeliverySlotDto>(this as DeliverySlotDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeliverySlotDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliverySlotDto&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.problem, _this.problem) || other.problem == _this.problem)&&(identical(other.start, _this.start) || other.start == _this.start)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as DeliverySlotDto;
  return Object.hash(runtimeType,_this.available,_this.end,_this.problem,_this.start,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as DeliverySlotDto;
  return 'DeliverySlotDto(available: ${_this.available}, end: ${_this.end}, problem: ${_this.problem}, start: ${_this.start}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $DeliverySlotDtoCopyWith<$Res>  {
  factory $DeliverySlotDtoCopyWith(DeliverySlotDto value, $Res Function(DeliverySlotDto) _then) = _$DeliverySlotDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) bool available,@JsonKey(required: true, disallowNullValue: true) String end,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: DeliverySlotDto._read_problem, toJson: DeliverySlotDto._write_problem) SlotProblem? problem,@JsonKey(required: true, disallowNullValue: true) String start,@JsonKey(readValue: DeliverySlotDto._extras, fromJson: DeliverySlotDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$DeliverySlotDtoCopyWithImpl<$Res>
    implements $DeliverySlotDtoCopyWith<$Res> {
  _$DeliverySlotDtoCopyWithImpl(this._self, this._then);

  final DeliverySlotDto _self;
  final $Res Function(DeliverySlotDto) _then;

/// Create a copy of DeliverySlotDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? end = null,Object? problem = freezed,Object? start = null,Object? additionalProperties = null,}) {
  return _then(DeliverySlotDto(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as SlotProblem?,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliverySlotDto].
extension DeliverySlotDtoPatterns on DeliverySlotDto {
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
