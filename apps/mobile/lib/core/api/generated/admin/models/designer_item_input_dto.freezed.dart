// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'designer_item_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DesignerItemInputDto {


/// Create a copy of DesignerItemInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DesignerItemInputDtoCopyWith<DesignerItemInputDto> get copyWith => _$DesignerItemInputDtoCopyWithImpl<DesignerItemInputDto>(this as DesignerItemInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DesignerItemInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DesignerItemInputDto&&const DeepCollectionEquality().equals(other.colorTags, _this.colorTags)&&(identical(other.cutoutUrl, _this.cutoutUrl) || other.cutoutUrl == _this.cutoutUrl)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.nameEn, _this.nameEn) || other.nameEn == _this.nameEn)&&const DeepCollectionEquality().equals(other.occasionTags, _this.occasionTags)&&(identical(other.seasonFrom, _this.seasonFrom) || other.seasonFrom == _this.seasonFrom)&&(identical(other.seasonTo, _this.seasonTo) || other.seasonTo == _this.seasonTo)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.stockQuantity, _this.stockQuantity) || other.stockQuantity == _this.stockQuantity)&&(identical(other.swatch, _this.swatch) || other.swatch == _this.swatch)&&(identical(other.type2, _this.type2) || other.type2 == _this.type2)&&(identical(other.unitPriceMinor, _this.unitPriceMinor) || other.unitPriceMinor == _this.unitPriceMinor)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as DesignerItemInputDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.colorTags),_this.cutoutUrl,_this.nameAr,_this.nameEn,const DeepCollectionEquality().hash(_this.occasionTags),_this.seasonFrom,_this.seasonTo,_this.slug,_this.sortOrder,_this.status,_this.stockQuantity,_this.swatch,_this.type2,_this.unitPriceMinor,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as DesignerItemInputDto;
  return 'DesignerItemInputDto(colorTags: ${_this.colorTags}, cutoutUrl: ${_this.cutoutUrl}, nameAr: ${_this.nameAr}, nameEn: ${_this.nameEn}, occasionTags: ${_this.occasionTags}, seasonFrom: ${_this.seasonFrom}, seasonTo: ${_this.seasonTo}, slug: ${_this.slug}, sortOrder: ${_this.sortOrder}, status: ${_this.status}, stockQuantity: ${_this.stockQuantity}, swatch: ${_this.swatch}, type2: ${_this.type2}, unitPriceMinor: ${_this.unitPriceMinor}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $DesignerItemInputDtoCopyWith<$Res>  {
  factory $DesignerItemInputDtoCopyWith(DesignerItemInputDto value, $Res Function(DesignerItemInputDto) _then) = _$DesignerItemInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) List<String>? colorTags,@JsonKey(disallowNullValue: true, includeIfNull: false) String? cutoutUrl,@JsonKey(required: true, disallowNullValue: true) String nameAr,@JsonKey(required: true, disallowNullValue: true) String nameEn,@JsonKey(disallowNullValue: true, includeIfNull: false) List<String>? occasionTags,@JsonKey(disallowNullValue: true, includeIfNull: false) String? seasonFrom,@JsonKey(disallowNullValue: true, includeIfNull: false) String? seasonTo,@JsonKey(required: true, disallowNullValue: true) String slug,@JsonKey(disallowNullValue: true, includeIfNull: false) num? sortOrder,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: DesignerItemInputDto._read_status, toJson: DesignerItemInputDto._write_status) DesignerItemInputDtoStatus? status,@JsonKey(includeIfNull: false) num? stockQuantity,@JsonKey(disallowNullValue: true, includeIfNull: false) String? swatch,@JsonKey(name: "type", required: true, disallowNullValue: true, fromJson: DesignerItemInputDto._read_type2, toJson: DesignerItemInputDto._write_type2) DesignerItemInputDtoType type2,@JsonKey(required: true, disallowNullValue: true) num unitPriceMinor,@JsonKey(readValue: DesignerItemInputDto._extras, fromJson: DesignerItemInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$DesignerItemInputDtoCopyWithImpl<$Res>
    implements $DesignerItemInputDtoCopyWith<$Res> {
  _$DesignerItemInputDtoCopyWithImpl(this._self, this._then);

  final DesignerItemInputDto _self;
  final $Res Function(DesignerItemInputDto) _then;

/// Create a copy of DesignerItemInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? colorTags = freezed,Object? cutoutUrl = freezed,Object? nameAr = null,Object? nameEn = null,Object? occasionTags = freezed,Object? seasonFrom = freezed,Object? seasonTo = freezed,Object? slug = null,Object? sortOrder = freezed,Object? status = freezed,Object? stockQuantity = freezed,Object? swatch = freezed,Object? type2 = null,Object? unitPriceMinor = null,Object? additionalProperties = null,}) {
  return _then(DesignerItemInputDto(
colorTags: freezed == colorTags ? _self.colorTags : colorTags // ignore: cast_nullable_to_non_nullable
as List<String>?,cutoutUrl: freezed == cutoutUrl ? _self.cutoutUrl : cutoutUrl // ignore: cast_nullable_to_non_nullable
as String?,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,occasionTags: freezed == occasionTags ? _self.occasionTags : occasionTags // ignore: cast_nullable_to_non_nullable
as List<String>?,seasonFrom: freezed == seasonFrom ? _self.seasonFrom : seasonFrom // ignore: cast_nullable_to_non_nullable
as String?,seasonTo: freezed == seasonTo ? _self.seasonTo : seasonTo // ignore: cast_nullable_to_non_nullable
as String?,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as num?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DesignerItemInputDtoStatus?,stockQuantity: freezed == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as num?,swatch: freezed == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as String?,type2: null == type2 ? _self.type2 : type2 // ignore: cast_nullable_to_non_nullable
as DesignerItemInputDtoType,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as num,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [DesignerItemInputDto].
extension DesignerItemInputDtoPatterns on DesignerItemInputDto {
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
