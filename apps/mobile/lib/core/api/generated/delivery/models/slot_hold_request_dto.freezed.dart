// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slot_hold_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SlotHoldRequestDto {


/// Create a copy of SlotHoldRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotHoldRequestDtoCopyWith<SlotHoldRequestDto> get copyWith => _$SlotHoldRequestDtoCopyWithImpl<SlotHoldRequestDto>(this as SlotHoldRequestDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SlotHoldRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotHoldRequestDto&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.leadTimeHours, _this.leadTimeHours) || other.leadTimeHours == _this.leadTimeHours)&&(identical(other.start, _this.start) || other.start == _this.start)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as SlotHoldRequestDto;
  return Object.hash(runtimeType,_this.date,_this.leadTimeHours,_this.start,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as SlotHoldRequestDto;
  return 'SlotHoldRequestDto(date: ${_this.date}, leadTimeHours: ${_this.leadTimeHours}, start: ${_this.start}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $SlotHoldRequestDtoCopyWith<$Res>  {
  factory $SlotHoldRequestDtoCopyWith(SlotHoldRequestDto value, $Res Function(SlotHoldRequestDto) _then) = _$SlotHoldRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String date,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: SlotHoldRequestDto._read_leadTimeHours, toJson: SlotHoldRequestDto._write_leadTimeHours) int? leadTimeHours,@JsonKey(required: true, disallowNullValue: true) String start,@JsonKey(readValue: SlotHoldRequestDto._extras, fromJson: SlotHoldRequestDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$SlotHoldRequestDtoCopyWithImpl<$Res>
    implements $SlotHoldRequestDtoCopyWith<$Res> {
  _$SlotHoldRequestDtoCopyWithImpl(this._self, this._then);

  final SlotHoldRequestDto _self;
  final $Res Function(SlotHoldRequestDto) _then;

/// Create a copy of SlotHoldRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? leadTimeHours = freezed,Object? start = null,Object? additionalProperties = null,}) {
  return _then(SlotHoldRequestDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,leadTimeHours: freezed == leadTimeHours ? _self.leadTimeHours : leadTimeHours // ignore: cast_nullable_to_non_nullable
as int?,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [SlotHoldRequestDto].
extension SlotHoldRequestDtoPatterns on SlotHoldRequestDto {
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
