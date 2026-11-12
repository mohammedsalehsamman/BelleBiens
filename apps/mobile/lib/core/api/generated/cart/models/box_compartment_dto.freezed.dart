// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'box_compartment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoxCompartmentDto {


/// Create a copy of BoxCompartmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoxCompartmentDtoCopyWith<BoxCompartmentDto> get copyWith => _$BoxCompartmentDtoCopyWithImpl<BoxCompartmentDto>(this as BoxCompartmentDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BoxCompartmentDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoxCompartmentDto&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.index, _this.index) || other.index == _this.index)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as BoxCompartmentDto;
  return Object.hash(runtimeType,_this.capacity,_this.index,_this.kind,_this.name,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as BoxCompartmentDto;
  return 'BoxCompartmentDto(capacity: ${_this.capacity}, index: ${_this.index}, kind: ${_this.kind}, name: ${_this.name}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $BoxCompartmentDtoCopyWith<$Res>  {
  factory $BoxCompartmentDtoCopyWith(BoxCompartmentDto value, $Res Function(BoxCompartmentDto) _then) = _$BoxCompartmentDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: BoxCompartmentDto._read_capacity, toJson: BoxCompartmentDto._write_capacity) int capacity,@JsonKey(required: true, disallowNullValue: true, fromJson: BoxCompartmentDto._read_index, toJson: BoxCompartmentDto._write_index) int index,@JsonKey(required: true, disallowNullValue: true, fromJson: BoxCompartmentDto._read_kind, toJson: BoxCompartmentDto._write_kind) BoxPartKind kind,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto name,@JsonKey(readValue: BoxCompartmentDto._extras, fromJson: BoxCompartmentDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$LocalizedTextDtoCopyWith<$Res> get name;

}
/// @nodoc
class _$BoxCompartmentDtoCopyWithImpl<$Res>
    implements $BoxCompartmentDtoCopyWith<$Res> {
  _$BoxCompartmentDtoCopyWithImpl(this._self, this._then);

  final BoxCompartmentDto _self;
  final $Res Function(BoxCompartmentDto) _then;

/// Create a copy of BoxCompartmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? capacity = null,Object? index = null,Object? kind = null,Object? name = null,Object? additionalProperties = null,}) {
  return _then(BoxCompartmentDto(
capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BoxPartKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of BoxCompartmentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get name {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}
}


/// Adds pattern-matching-related methods to [BoxCompartmentDto].
extension BoxCompartmentDtoPatterns on BoxCompartmentDto {
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
