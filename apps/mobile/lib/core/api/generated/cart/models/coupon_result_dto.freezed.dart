// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CouponResultDto {


/// Create a copy of CouponResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponResultDtoCopyWith<CouponResultDto> get copyWith => _$CouponResultDtoCopyWithImpl<CouponResultDto>(this as CouponResultDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CouponResultDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouponResultDto&&(identical(other.applied, _this.applied) || other.applied == _this.applied)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.minOrderMinor, _this.minOrderMinor) || other.minOrderMinor == _this.minOrderMinor)&&(identical(other.problem, _this.problem) || other.problem == _this.problem)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as CouponResultDto;
  return Object.hash(runtimeType,_this.applied,_this.code,_this.minOrderMinor,_this.problem,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as CouponResultDto;
  return 'CouponResultDto(applied: ${_this.applied}, code: ${_this.code}, minOrderMinor: ${_this.minOrderMinor}, problem: ${_this.problem}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $CouponResultDtoCopyWith<$Res>  {
  factory $CouponResultDtoCopyWith(CouponResultDto value, $Res Function(CouponResultDto) _then) = _$CouponResultDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) bool applied,@JsonKey(required: true, disallowNullValue: true) String code,@JsonKey(required: true, disallowNullValue: true, fromJson: CouponResultDto._read_minOrderMinor, toJson: CouponResultDto._write_minOrderMinor) int minOrderMinor,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: CouponResultDto._read_problem, toJson: CouponResultDto._write_problem) CouponProblem? problem,@JsonKey(readValue: CouponResultDto._extras, fromJson: CouponResultDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$CouponResultDtoCopyWithImpl<$Res>
    implements $CouponResultDtoCopyWith<$Res> {
  _$CouponResultDtoCopyWithImpl(this._self, this._then);

  final CouponResultDto _self;
  final $Res Function(CouponResultDto) _then;

/// Create a copy of CouponResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? applied = null,Object? code = null,Object? minOrderMinor = null,Object? problem = freezed,Object? additionalProperties = null,}) {
  return _then(CouponResultDto(
applied: null == applied ? _self.applied : applied // ignore: cast_nullable_to_non_nullable
as bool,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,minOrderMinor: null == minOrderMinor ? _self.minOrderMinor : minOrderMinor // ignore: cast_nullable_to_non_nullable
as int,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as CouponProblem?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [CouponResultDto].
extension CouponResultDtoPatterns on CouponResultDto {
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
