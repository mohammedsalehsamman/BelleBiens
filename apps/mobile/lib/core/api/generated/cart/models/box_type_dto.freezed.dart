// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'box_type_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoxTypeDto {


/// Create a copy of BoxTypeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoxTypeDtoCopyWith<BoxTypeDto> get copyWith => _$BoxTypeDtoCopyWithImpl<BoxTypeDto>(this as BoxTypeDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BoxTypeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoxTypeDto&&(identical(other.basePriceMinor, _this.basePriceMinor) || other.basePriceMinor == _this.basePriceMinor)&&const DeepCollectionEquality().equals(other.compartments, _this.compartments)&&(identical(other.detail, _this.detail) || other.detail == _this.detail)&&(identical(other.fromPriceMinor, _this.fromPriceMinor) || other.fromPriceMinor == _this.fromPriceMinor)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as BoxTypeDto;
  return Object.hash(runtimeType,_this.basePriceMinor,const DeepCollectionEquality().hash(_this.compartments),_this.detail,_this.fromPriceMinor,_this.id,_this.name,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as BoxTypeDto;
  return 'BoxTypeDto(basePriceMinor: ${_this.basePriceMinor}, compartments: ${_this.compartments}, detail: ${_this.detail}, fromPriceMinor: ${_this.fromPriceMinor}, id: ${_this.id}, name: ${_this.name}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $BoxTypeDtoCopyWith<$Res>  {
  factory $BoxTypeDtoCopyWith(BoxTypeDto value, $Res Function(BoxTypeDto) _then) = _$BoxTypeDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: BoxTypeDto._read_basePriceMinor, toJson: BoxTypeDto._write_basePriceMinor) int basePriceMinor,@JsonKey(required: true, disallowNullValue: true) List<BoxCompartmentDto> compartments,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto detail,@JsonKey(required: true, disallowNullValue: true, fromJson: BoxTypeDto._read_fromPriceMinor, toJson: BoxTypeDto._write_fromPriceMinor) int fromPriceMinor,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto name,@JsonKey(readValue: BoxTypeDto._extras, fromJson: BoxTypeDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$LocalizedTextDtoCopyWith<$Res> get detail;$LocalizedTextDtoCopyWith<$Res> get name;

}
/// @nodoc
class _$BoxTypeDtoCopyWithImpl<$Res>
    implements $BoxTypeDtoCopyWith<$Res> {
  _$BoxTypeDtoCopyWithImpl(this._self, this._then);

  final BoxTypeDto _self;
  final $Res Function(BoxTypeDto) _then;

/// Create a copy of BoxTypeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? basePriceMinor = null,Object? compartments = null,Object? detail = null,Object? fromPriceMinor = null,Object? id = null,Object? name = null,Object? additionalProperties = null,}) {
  return _then(BoxTypeDto(
basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,compartments: null == compartments ? _self.compartments : compartments // ignore: cast_nullable_to_non_nullable
as List<BoxCompartmentDto>,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,fromPriceMinor: null == fromPriceMinor ? _self.fromPriceMinor : fromPriceMinor // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of BoxTypeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get detail {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.detail, (value) {
    return _then(_self.copyWith(detail: value));
  });
}/// Create a copy of BoxTypeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get name {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}
}


/// Adds pattern-matching-related methods to [BoxTypeDto].
extension BoxTypeDtoPatterns on BoxTypeDto {
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
