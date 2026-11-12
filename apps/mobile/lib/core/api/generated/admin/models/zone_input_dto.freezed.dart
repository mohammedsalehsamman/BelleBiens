// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ZoneInputDto {


/// Create a copy of ZoneInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoneInputDtoCopyWith<ZoneInputDto> get copyWith => _$ZoneInputDtoCopyWithImpl<ZoneInputDto>(this as ZoneInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ZoneInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZoneInputDto&&(identical(other.active, _this.active) || other.active == _this.active)&&(identical(other.etaAr, _this.etaAr) || other.etaAr == _this.etaAr)&&(identical(other.etaEn, _this.etaEn) || other.etaEn == _this.etaEn)&&(identical(other.feeMinor, _this.feeMinor) || other.feeMinor == _this.feeMinor)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.nameEn, _this.nameEn) || other.nameEn == _this.nameEn)&&const DeepCollectionEquality().equals(other.polygon, _this.polygon)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as ZoneInputDto;
  return Object.hash(runtimeType,_this.active,_this.etaAr,_this.etaEn,_this.feeMinor,_this.nameAr,_this.nameEn,const DeepCollectionEquality().hash(_this.polygon),_this.slug,_this.sortOrder,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as ZoneInputDto;
  return 'ZoneInputDto(active: ${_this.active}, etaAr: ${_this.etaAr}, etaEn: ${_this.etaEn}, feeMinor: ${_this.feeMinor}, nameAr: ${_this.nameAr}, nameEn: ${_this.nameEn}, polygon: ${_this.polygon}, slug: ${_this.slug}, sortOrder: ${_this.sortOrder}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $ZoneInputDtoCopyWith<$Res>  {
  factory $ZoneInputDtoCopyWith(ZoneInputDto value, $Res Function(ZoneInputDto) _then) = _$ZoneInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) bool? active,@JsonKey(disallowNullValue: true, includeIfNull: false) String? etaAr,@JsonKey(disallowNullValue: true, includeIfNull: false) String? etaEn,@JsonKey(required: true, disallowNullValue: true, fromJson: ZoneInputDto._read_feeMinor, toJson: ZoneInputDto._write_feeMinor) int feeMinor,@JsonKey(required: true, disallowNullValue: true) String nameAr,@JsonKey(required: true, disallowNullValue: true) String nameEn,@JsonKey(required: true, disallowNullValue: true) List<List<num>> polygon,@JsonKey(required: true, disallowNullValue: true) String slug,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: ZoneInputDto._read_sortOrder, toJson: ZoneInputDto._write_sortOrder) int? sortOrder,@JsonKey(readValue: ZoneInputDto._extras, fromJson: ZoneInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$ZoneInputDtoCopyWithImpl<$Res>
    implements $ZoneInputDtoCopyWith<$Res> {
  _$ZoneInputDtoCopyWithImpl(this._self, this._then);

  final ZoneInputDto _self;
  final $Res Function(ZoneInputDto) _then;

/// Create a copy of ZoneInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? active = freezed,Object? etaAr = freezed,Object? etaEn = freezed,Object? feeMinor = null,Object? nameAr = null,Object? nameEn = null,Object? polygon = null,Object? slug = null,Object? sortOrder = freezed,Object? additionalProperties = null,}) {
  return _then(ZoneInputDto(
active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,etaAr: freezed == etaAr ? _self.etaAr : etaAr // ignore: cast_nullable_to_non_nullable
as String?,etaEn: freezed == etaEn ? _self.etaEn : etaEn // ignore: cast_nullable_to_non_nullable
as String?,feeMinor: null == feeMinor ? _self.feeMinor : feeMinor // ignore: cast_nullable_to_non_nullable
as int,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,polygon: null == polygon ? _self.polygon : polygon // ignore: cast_nullable_to_non_nullable
as List<List<num>>,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [ZoneInputDto].
extension ZoneInputDtoPatterns on ZoneInputDto {
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
