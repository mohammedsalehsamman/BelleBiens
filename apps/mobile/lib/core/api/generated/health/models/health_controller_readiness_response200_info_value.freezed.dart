// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_controller_readiness_response200_info_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthControllerReadinessResponse200InfoValue {


/// Create a copy of HealthControllerReadinessResponse200InfoValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthControllerReadinessResponse200InfoValueCopyWith<HealthControllerReadinessResponse200InfoValue> get copyWith => _$HealthControllerReadinessResponse200InfoValueCopyWithImpl<HealthControllerReadinessResponse200InfoValue>(this as HealthControllerReadinessResponse200InfoValue, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HealthControllerReadinessResponse200InfoValue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthControllerReadinessResponse200InfoValue&&(identical(other.responseTime, _this.responseTime) || other.responseTime == _this.responseTime)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as HealthControllerReadinessResponse200InfoValue;
  return Object.hash(runtimeType,_this.responseTime,_this.status,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as HealthControllerReadinessResponse200InfoValue;
  return 'HealthControllerReadinessResponse200InfoValue(responseTime: ${_this.responseTime}, status: ${_this.status}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $HealthControllerReadinessResponse200InfoValueCopyWith<$Res>  {
  factory $HealthControllerReadinessResponse200InfoValueCopyWith(HealthControllerReadinessResponse200InfoValue value, $Res Function(HealthControllerReadinessResponse200InfoValue) _then) = _$HealthControllerReadinessResponse200InfoValueCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) num? responseTime,@JsonKey(required: true, disallowNullValue: true, fromJson: HealthControllerReadinessResponse200InfoValue._read_status, toJson: HealthControllerReadinessResponse200InfoValue._write_status) HealthControllerReadinessResponse200InfoValueStatus status,@JsonKey(readValue: HealthControllerReadinessResponse200InfoValue._extras, fromJson: HealthControllerReadinessResponse200InfoValue._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$HealthControllerReadinessResponse200InfoValueCopyWithImpl<$Res>
    implements $HealthControllerReadinessResponse200InfoValueCopyWith<$Res> {
  _$HealthControllerReadinessResponse200InfoValueCopyWithImpl(this._self, this._then);

  final HealthControllerReadinessResponse200InfoValue _self;
  final $Res Function(HealthControllerReadinessResponse200InfoValue) _then;

/// Create a copy of HealthControllerReadinessResponse200InfoValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? responseTime = freezed,Object? status = null,Object? additionalProperties = null,}) {
  return _then(HealthControllerReadinessResponse200InfoValue(
responseTime: freezed == responseTime ? _self.responseTime : responseTime // ignore: cast_nullable_to_non_nullable
as num?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthControllerReadinessResponse200InfoValueStatus,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthControllerReadinessResponse200InfoValue].
extension HealthControllerReadinessResponse200InfoValuePatterns on HealthControllerReadinessResponse200InfoValue {
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
