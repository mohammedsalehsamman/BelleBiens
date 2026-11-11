// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slot_layouts_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SlotLayoutsDto {


/// Create a copy of SlotLayoutsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotLayoutsDtoCopyWith<SlotLayoutsDto> get copyWith => _$SlotLayoutsDtoCopyWithImpl<SlotLayoutsDto>(this as SlotLayoutsDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SlotLayoutsDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotLayoutsDto&&(identical(other.height, _this.height) || other.height == _this.height)&&const DeepCollectionEquality().equals(other.sizes, _this.sizes)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.width, _this.width) || other.width == _this.width)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as SlotLayoutsDto;
  return Object.hash(runtimeType,_this.height,const DeepCollectionEquality().hash(_this.sizes),_this.version,_this.width,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as SlotLayoutsDto;
  return 'SlotLayoutsDto(height: ${_this.height}, sizes: ${_this.sizes}, version: ${_this.version}, width: ${_this.width}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $SlotLayoutsDtoCopyWith<$Res>  {
  factory $SlotLayoutsDtoCopyWith(SlotLayoutsDto value, $Res Function(SlotLayoutsDto) _then) = _$SlotLayoutsDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: SlotLayoutsDto._read_height, toJson: SlotLayoutsDto._write_height) int height,@JsonKey(required: true, disallowNullValue: true) List<SizeLayoutDto> sizes,@JsonKey(required: true, disallowNullValue: true, fromJson: SlotLayoutsDto._read_version, toJson: SlotLayoutsDto._write_version) int version,@JsonKey(required: true, disallowNullValue: true, fromJson: SlotLayoutsDto._read_width, toJson: SlotLayoutsDto._write_width) int width,@JsonKey(readValue: SlotLayoutsDto._extras, fromJson: SlotLayoutsDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$SlotLayoutsDtoCopyWithImpl<$Res>
    implements $SlotLayoutsDtoCopyWith<$Res> {
  _$SlotLayoutsDtoCopyWithImpl(this._self, this._then);

  final SlotLayoutsDto _self;
  final $Res Function(SlotLayoutsDto) _then;

/// Create a copy of SlotLayoutsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? height = null,Object? sizes = null,Object? version = null,Object? width = null,Object? additionalProperties = null,}) {
  return _then(SlotLayoutsDto(
height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,sizes: null == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<SizeLayoutDto>,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [SlotLayoutsDto].
extension SlotLayoutsDtoPatterns on SlotLayoutsDto {
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
