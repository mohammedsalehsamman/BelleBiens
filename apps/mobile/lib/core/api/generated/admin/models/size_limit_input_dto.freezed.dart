// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'size_limit_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SizeLimitInputDto {


/// Create a copy of SizeLimitInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeLimitInputDtoCopyWith<SizeLimitInputDto> get copyWith => _$SizeLimitInputDtoCopyWithImpl<SizeLimitInputDto>(this as SizeLimitInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SizeLimitInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeLimitInputDto&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.maxStems, _this.maxStems) || other.maxStems == _this.maxStems)&&(identical(other.minStems, _this.minStems) || other.minStems == _this.minStems)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as SizeLimitInputDto;
  return Object.hash(runtimeType,_this.key,_this.maxStems,_this.minStems,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as SizeLimitInputDto;
  return 'SizeLimitInputDto(key: ${_this.key}, maxStems: ${_this.maxStems}, minStems: ${_this.minStems}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $SizeLimitInputDtoCopyWith<$Res>  {
  factory $SizeLimitInputDtoCopyWith(SizeLimitInputDto value, $Res Function(SizeLimitInputDto) _then) = _$SizeLimitInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: SizeLimitInputDto._read_key, toJson: SizeLimitInputDto._write_key) SizeLimitInputDtoKey key,@JsonKey(required: true, disallowNullValue: true) num maxStems,@JsonKey(required: true, disallowNullValue: true) num minStems,@JsonKey(readValue: SizeLimitInputDto._extras, fromJson: SizeLimitInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$SizeLimitInputDtoCopyWithImpl<$Res>
    implements $SizeLimitInputDtoCopyWith<$Res> {
  _$SizeLimitInputDtoCopyWithImpl(this._self, this._then);

  final SizeLimitInputDto _self;
  final $Res Function(SizeLimitInputDto) _then;

/// Create a copy of SizeLimitInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? maxStems = null,Object? minStems = null,Object? additionalProperties = null,}) {
  return _then(SizeLimitInputDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as SizeLimitInputDtoKey,maxStems: null == maxStems ? _self.maxStems : maxStems // ignore: cast_nullable_to_non_nullable
as num,minStems: null == minStems ? _self.minStems : minStems // ignore: cast_nullable_to_non_nullable
as num,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [SizeLimitInputDto].
extension SizeLimitInputDtoPatterns on SizeLimitInputDto {
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
