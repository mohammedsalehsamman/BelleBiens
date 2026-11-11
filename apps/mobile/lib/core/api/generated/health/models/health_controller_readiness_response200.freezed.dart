// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_controller_readiness_response200.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthControllerReadinessResponse200 {


/// Create a copy of HealthControllerReadinessResponse200
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthControllerReadinessResponse200CopyWith<HealthControllerReadinessResponse200> get copyWith => _$HealthControllerReadinessResponse200CopyWithImpl<HealthControllerReadinessResponse200>(this as HealthControllerReadinessResponse200, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HealthControllerReadinessResponse200;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthControllerReadinessResponse200&&const DeepCollectionEquality().equals(other.details, _this.details)&&const DeepCollectionEquality().equals(other.error, _this.error)&&const DeepCollectionEquality().equals(other.info, _this.info)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as HealthControllerReadinessResponse200;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.details),const DeepCollectionEquality().hash(_this.error),const DeepCollectionEquality().hash(_this.info),_this.status,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as HealthControllerReadinessResponse200;
  return 'HealthControllerReadinessResponse200(details: ${_this.details}, error: ${_this.error}, info: ${_this.info}, status: ${_this.status}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $HealthControllerReadinessResponse200CopyWith<$Res>  {
  factory $HealthControllerReadinessResponse200CopyWith(HealthControllerReadinessResponse200 value, $Res Function(HealthControllerReadinessResponse200) _then) = _$HealthControllerReadinessResponse200CopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) Map<String, HealthControllerReadinessResponse200DetailsValue>? details,@JsonKey(includeIfNull: false) Map<String, HealthControllerReadinessResponse200ErrorValue>? error,@JsonKey(includeIfNull: false) Map<String, HealthControllerReadinessResponse200InfoValue>? info,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: HealthControllerReadinessResponse200._read_status, toJson: HealthControllerReadinessResponse200._write_status) HealthControllerReadinessResponse200Status? status,@JsonKey(readValue: HealthControllerReadinessResponse200._extras, fromJson: HealthControllerReadinessResponse200._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$HealthControllerReadinessResponse200CopyWithImpl<$Res>
    implements $HealthControllerReadinessResponse200CopyWith<$Res> {
  _$HealthControllerReadinessResponse200CopyWithImpl(this._self, this._then);

  final HealthControllerReadinessResponse200 _self;
  final $Res Function(HealthControllerReadinessResponse200) _then;

/// Create a copy of HealthControllerReadinessResponse200
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? details = freezed,Object? error = freezed,Object? info = freezed,Object? status = freezed,Object? additionalProperties = null,}) {
  return _then(HealthControllerReadinessResponse200(
details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as Map<String, HealthControllerReadinessResponse200DetailsValue>?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Map<String, HealthControllerReadinessResponse200ErrorValue>?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Map<String, HealthControllerReadinessResponse200InfoValue>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthControllerReadinessResponse200Status?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthControllerReadinessResponse200].
extension HealthControllerReadinessResponse200Patterns on HealthControllerReadinessResponse200 {
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
