// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone_with_area_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ZoneWithAreaDto {


/// Create a copy of ZoneWithAreaDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoneWithAreaDtoCopyWith<ZoneWithAreaDto> get copyWith => _$ZoneWithAreaDtoCopyWithImpl<ZoneWithAreaDto>(this as ZoneWithAreaDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ZoneWithAreaDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZoneWithAreaDto&&(identical(other.eta, _this.eta) || other.eta == _this.eta)&&(identical(other.feeMinor, _this.feeMinor) || other.feeMinor == _this.feeMinor)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.polygon, _this.polygon)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as ZoneWithAreaDto;
  return Object.hash(runtimeType,_this.eta,_this.feeMinor,_this.name,const DeepCollectionEquality().hash(_this.polygon),_this.slug,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as ZoneWithAreaDto;
  return 'ZoneWithAreaDto(eta: ${_this.eta}, feeMinor: ${_this.feeMinor}, name: ${_this.name}, polygon: ${_this.polygon}, slug: ${_this.slug}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $ZoneWithAreaDtoCopyWith<$Res>  {
  factory $ZoneWithAreaDtoCopyWith(ZoneWithAreaDto value, $Res Function(ZoneWithAreaDto) _then) = _$ZoneWithAreaDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto eta,@JsonKey(required: true, disallowNullValue: true, fromJson: ZoneWithAreaDto._read_feeMinor, toJson: ZoneWithAreaDto._write_feeMinor) int feeMinor,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto name,@JsonKey(required: true, disallowNullValue: true) List<List<num>> polygon,@JsonKey(required: true, disallowNullValue: true) String slug,@JsonKey(readValue: ZoneWithAreaDto._extras, fromJson: ZoneWithAreaDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$LocalizedTextDtoCopyWith<$Res> get eta;$LocalizedTextDtoCopyWith<$Res> get name;

}
/// @nodoc
class _$ZoneWithAreaDtoCopyWithImpl<$Res>
    implements $ZoneWithAreaDtoCopyWith<$Res> {
  _$ZoneWithAreaDtoCopyWithImpl(this._self, this._then);

  final ZoneWithAreaDto _self;
  final $Res Function(ZoneWithAreaDto) _then;

/// Create a copy of ZoneWithAreaDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eta = null,Object? feeMinor = null,Object? name = null,Object? polygon = null,Object? slug = null,Object? additionalProperties = null,}) {
  return _then(ZoneWithAreaDto(
eta: null == eta ? _self.eta : eta // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,feeMinor: null == feeMinor ? _self.feeMinor : feeMinor // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,polygon: null == polygon ? _self.polygon : polygon // ignore: cast_nullable_to_non_nullable
as List<List<num>>,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of ZoneWithAreaDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get eta {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.eta, (value) {
    return _then(_self.copyWith(eta: value));
  });
}/// Create a copy of ZoneWithAreaDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get name {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}
}


/// Adds pattern-matching-related methods to [ZoneWithAreaDto].
extension ZoneWithAreaDtoPatterns on ZoneWithAreaDto {
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
