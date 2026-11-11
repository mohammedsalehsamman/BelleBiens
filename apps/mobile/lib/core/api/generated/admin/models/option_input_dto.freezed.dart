// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OptionInputDto {


/// Create a copy of OptionInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionInputDtoCopyWith<OptionInputDto> get copyWith => _$OptionInputDtoCopyWithImpl<OptionInputDto>(this as OptionInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OptionInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptionInputDto&&(identical(other.detailAr, _this.detailAr) || other.detailAr == _this.detailAr)&&(identical(other.detailEn, _this.detailEn) || other.detailEn == _this.detailEn)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.nameEn, _this.nameEn) || other.nameEn == _this.nameEn)&&(identical(other.priceChangeMinor, _this.priceChangeMinor) || other.priceChangeMinor == _this.priceChangeMinor)&&(identical(other.swatch, _this.swatch) || other.swatch == _this.swatch)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as OptionInputDto;
  return Object.hash(runtimeType,_this.detailAr,_this.detailEn,_this.isDefault,_this.key,_this.nameAr,_this.nameEn,_this.priceChangeMinor,_this.swatch,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as OptionInputDto;
  return 'OptionInputDto(detailAr: ${_this.detailAr}, detailEn: ${_this.detailEn}, isDefault: ${_this.isDefault}, key: ${_this.key}, nameAr: ${_this.nameAr}, nameEn: ${_this.nameEn}, priceChangeMinor: ${_this.priceChangeMinor}, swatch: ${_this.swatch}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $OptionInputDtoCopyWith<$Res>  {
  factory $OptionInputDtoCopyWith(OptionInputDto value, $Res Function(OptionInputDto) _then) = _$OptionInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) String? detailAr,@JsonKey(disallowNullValue: true, includeIfNull: false) String? detailEn,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? isDefault,@JsonKey(required: true, disallowNullValue: true) String key,@JsonKey(required: true, disallowNullValue: true) String nameAr,@JsonKey(required: true, disallowNullValue: true) String nameEn,@JsonKey(disallowNullValue: true, includeIfNull: false) num? priceChangeMinor,@JsonKey(disallowNullValue: true, includeIfNull: false) String? swatch,@JsonKey(readValue: OptionInputDto._extras, fromJson: OptionInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$OptionInputDtoCopyWithImpl<$Res>
    implements $OptionInputDtoCopyWith<$Res> {
  _$OptionInputDtoCopyWithImpl(this._self, this._then);

  final OptionInputDto _self;
  final $Res Function(OptionInputDto) _then;

/// Create a copy of OptionInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? detailAr = freezed,Object? detailEn = freezed,Object? isDefault = freezed,Object? key = null,Object? nameAr = null,Object? nameEn = null,Object? priceChangeMinor = freezed,Object? swatch = freezed,Object? additionalProperties = null,}) {
  return _then(OptionInputDto(
detailAr: freezed == detailAr ? _self.detailAr : detailAr // ignore: cast_nullable_to_non_nullable
as String?,detailEn: freezed == detailEn ? _self.detailEn : detailEn // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,priceChangeMinor: freezed == priceChangeMinor ? _self.priceChangeMinor : priceChangeMinor // ignore: cast_nullable_to_non_nullable
as num?,swatch: freezed == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as String?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [OptionInputDto].
extension OptionInputDtoPatterns on OptionInputDto {
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
