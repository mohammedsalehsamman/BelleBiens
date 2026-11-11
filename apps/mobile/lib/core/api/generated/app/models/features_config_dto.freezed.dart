// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'features_config_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeaturesConfigDto {


/// Create a copy of FeaturesConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeaturesConfigDtoCopyWith<FeaturesConfigDto> get copyWith => _$FeaturesConfigDtoCopyWithImpl<FeaturesConfigDto>(this as FeaturesConfigDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FeaturesConfigDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeaturesConfigDto&&(identical(other.aiPreview, _this.aiPreview) || other.aiPreview == _this.aiPreview)&&(identical(other.designer3d, _this.designer3d) || other.designer3d == _this.designer3d)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as FeaturesConfigDto;
  return Object.hash(runtimeType,_this.aiPreview,_this.designer3d,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as FeaturesConfigDto;
  return 'FeaturesConfigDto(aiPreview: ${_this.aiPreview}, designer3d: ${_this.designer3d}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $FeaturesConfigDtoCopyWith<$Res>  {
  factory $FeaturesConfigDtoCopyWith(FeaturesConfigDto value, $Res Function(FeaturesConfigDto) _then) = _$FeaturesConfigDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) bool aiPreview,@JsonKey(required: true, disallowNullValue: true) bool designer3d,@JsonKey(readValue: FeaturesConfigDto._extras, fromJson: FeaturesConfigDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$FeaturesConfigDtoCopyWithImpl<$Res>
    implements $FeaturesConfigDtoCopyWith<$Res> {
  _$FeaturesConfigDtoCopyWithImpl(this._self, this._then);

  final FeaturesConfigDto _self;
  final $Res Function(FeaturesConfigDto) _then;

/// Create a copy of FeaturesConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aiPreview = null,Object? designer3d = null,Object? additionalProperties = null,}) {
  return _then(FeaturesConfigDto(
aiPreview: null == aiPreview ? _self.aiPreview : aiPreview // ignore: cast_nullable_to_non_nullable
as bool,designer3d: null == designer3d ? _self.designer3d : designer3d // ignore: cast_nullable_to_non_nullable
as bool,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [FeaturesConfigDto].
extension FeaturesConfigDtoPatterns on FeaturesConfigDto {
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
