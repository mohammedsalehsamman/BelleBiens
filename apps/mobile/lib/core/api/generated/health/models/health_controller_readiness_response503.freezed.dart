// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_controller_readiness_response503.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthControllerReadinessResponse503 {


/// Create a copy of HealthControllerReadinessResponse503
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthControllerReadinessResponse503CopyWith<HealthControllerReadinessResponse503> get copyWith => _$HealthControllerReadinessResponse503CopyWithImpl<HealthControllerReadinessResponse503>(this as HealthControllerReadinessResponse503, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HealthControllerReadinessResponse503;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthControllerReadinessResponse503&&const DeepCollectionEquality().equals(other.details, _this.details)&&const DeepCollectionEquality().equals(other.error, _this.error)&&const DeepCollectionEquality().equals(other.info, _this.info)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as HealthControllerReadinessResponse503;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.details),const DeepCollectionEquality().hash(_this.error),const DeepCollectionEquality().hash(_this.info),_this.status,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as HealthControllerReadinessResponse503;
  return 'HealthControllerReadinessResponse503(details: ${_this.details}, error: ${_this.error}, info: ${_this.info}, status: ${_this.status}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $HealthControllerReadinessResponse503CopyWith<$Res>  {
  factory $HealthControllerReadinessResponse503CopyWith(HealthControllerReadinessResponse503 value, $Res Function(HealthControllerReadinessResponse503) _then) = _$HealthControllerReadinessResponse503CopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) Map<String, HealthControllerReadinessResponse503DetailsValue>? details,@JsonKey(includeIfNull: false) Map<String, HealthControllerReadinessResponse503ErrorValue>? error,@JsonKey(includeIfNull: false) Map<String, HealthControllerReadinessResponse503InfoValue>? info,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: HealthControllerReadinessResponse503._read_status, toJson: HealthControllerReadinessResponse503._write_status) HealthControllerReadinessResponse503Status? status,@JsonKey(readValue: HealthControllerReadinessResponse503._extras, fromJson: HealthControllerReadinessResponse503._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$HealthControllerReadinessResponse503CopyWithImpl<$Res>
    implements $HealthControllerReadinessResponse503CopyWith<$Res> {
  _$HealthControllerReadinessResponse503CopyWithImpl(this._self, this._then);

  final HealthControllerReadinessResponse503 _self;
  final $Res Function(HealthControllerReadinessResponse503) _then;

/// Create a copy of HealthControllerReadinessResponse503
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? details = freezed,Object? error = freezed,Object? info = freezed,Object? status = freezed,Object? additionalProperties = null,}) {
  return _then(HealthControllerReadinessResponse503(
details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as Map<String, HealthControllerReadinessResponse503DetailsValue>?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Map<String, HealthControllerReadinessResponse503ErrorValue>?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Map<String, HealthControllerReadinessResponse503InfoValue>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthControllerReadinessResponse503Status?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthControllerReadinessResponse503].
extension HealthControllerReadinessResponse503Patterns on HealthControllerReadinessResponse503 {
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
