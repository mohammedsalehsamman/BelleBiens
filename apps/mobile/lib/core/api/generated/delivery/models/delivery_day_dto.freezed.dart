// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_day_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeliveryDayDto {


/// Create a copy of DeliveryDayDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryDayDtoCopyWith<DeliveryDayDto> get copyWith => _$DeliveryDayDtoCopyWithImpl<DeliveryDayDto>(this as DeliveryDayDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeliveryDayDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryDayDto&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.inDays, _this.inDays) || other.inDays == _this.inDays)&&(identical(other.problem, _this.problem) || other.problem == _this.problem)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as DeliveryDayDto;
  return Object.hash(runtimeType,_this.available,_this.date,_this.inDays,_this.problem,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as DeliveryDayDto;
  return 'DeliveryDayDto(available: ${_this.available}, date: ${_this.date}, inDays: ${_this.inDays}, problem: ${_this.problem}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $DeliveryDayDtoCopyWith<$Res>  {
  factory $DeliveryDayDtoCopyWith(DeliveryDayDto value, $Res Function(DeliveryDayDto) _then) = _$DeliveryDayDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) bool available,@JsonKey(required: true, disallowNullValue: true) String date,@JsonKey(required: true, disallowNullValue: true, fromJson: DeliveryDayDto._read_inDays, toJson: DeliveryDayDto._write_inDays) int inDays,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: DeliveryDayDto._read_problem, toJson: DeliveryDayDto._write_problem) SlotProblem? problem,@JsonKey(readValue: DeliveryDayDto._extras, fromJson: DeliveryDayDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$DeliveryDayDtoCopyWithImpl<$Res>
    implements $DeliveryDayDtoCopyWith<$Res> {
  _$DeliveryDayDtoCopyWithImpl(this._self, this._then);

  final DeliveryDayDto _self;
  final $Res Function(DeliveryDayDto) _then;

/// Create a copy of DeliveryDayDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? date = null,Object? inDays = null,Object? problem = freezed,Object? additionalProperties = null,}) {
  return _then(DeliveryDayDto(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,inDays: null == inDays ? _self.inDays : inDays // ignore: cast_nullable_to_non_nullable
as int,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as SlotProblem?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryDayDto].
extension DeliveryDayDtoPatterns on DeliveryDayDto {
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
