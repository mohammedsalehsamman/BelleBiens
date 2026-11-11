// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_product_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateProductDto {


/// Create a copy of UpdateProductDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProductDtoCopyWith<UpdateProductDto> get copyWith => _$UpdateProductDtoCopyWithImpl<UpdateProductDto>(this as UpdateProductDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UpdateProductDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProductDto&&const DeepCollectionEquality().equals(other.allergens, _this.allergens)&&(identical(other.basePriceMinor, _this.basePriceMinor) || other.basePriceMinor == _this.basePriceMinor)&&(identical(other.bestSeller, _this.bestSeller) || other.bestSeller == _this.bestSeller)&&(identical(other.categorySlug, _this.categorySlug) || other.categorySlug == _this.categorySlug)&&const DeepCollectionEquality().equals(other.colors, _this.colors)&&(identical(other.dailyOnly, _this.dailyOnly) || other.dailyOnly == _this.dailyOnly)&&(identical(other.descriptionAr, _this.descriptionAr) || other.descriptionAr == _this.descriptionAr)&&(identical(other.descriptionEn, _this.descriptionEn) || other.descriptionEn == _this.descriptionEn)&&(identical(other.designerTemplate, _this.designerTemplate) || other.designerTemplate == _this.designerTemplate)&&const DeepCollectionEquality().equals(other.flowerTypes, _this.flowerTypes)&&const DeepCollectionEquality().equals(other.images, _this.images)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.leadTimeHours, _this.leadTimeHours) || other.leadTimeHours == _this.leadTimeHours)&&(identical(other.limited, _this.limited) || other.limited == _this.limited)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.nameEn, _this.nameEn) || other.nameEn == _this.nameEn)&&const DeepCollectionEquality().equals(other.occasions, _this.occasions)&&const DeepCollectionEquality().equals(other.optionGroups, _this.optionGroups)&&const DeepCollectionEquality().equals(other.pairings, _this.pairings)&&(identical(other.popularity, _this.popularity) || other.popularity == _this.popularity)&&(identical(other.seasonal, _this.seasonal) || other.seasonal == _this.seasonal)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.stockQuantity, _this.stockQuantity) || other.stockQuantity == _this.stockQuantity)&&(identical(other.subtitleAr, _this.subtitleAr) || other.subtitleAr == _this.subtitleAr)&&(identical(other.subtitleEn, _this.subtitleEn) || other.subtitleEn == _this.subtitleEn)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as UpdateProductDto;
  return Object.hashAll([runtimeType,const DeepCollectionEquality().hash(_this.allergens),_this.basePriceMinor,_this.bestSeller,_this.categorySlug,const DeepCollectionEquality().hash(_this.colors),_this.dailyOnly,_this.descriptionAr,_this.descriptionEn,_this.designerTemplate,const DeepCollectionEquality().hash(_this.flowerTypes),const DeepCollectionEquality().hash(_this.images),_this.kind,_this.leadTimeHours,_this.limited,_this.nameAr,_this.nameEn,const DeepCollectionEquality().hash(_this.occasions),const DeepCollectionEquality().hash(_this.optionGroups),const DeepCollectionEquality().hash(_this.pairings),_this.popularity,_this.seasonal,_this.slug,_this.status,_this.stockQuantity,_this.subtitleAr,_this.subtitleEn,const DeepCollectionEquality().hash(_this.additionalProperties)]);
}

@override
String toString() {
  final _this = this as UpdateProductDto;
  return 'UpdateProductDto(allergens: ${_this.allergens}, basePriceMinor: ${_this.basePriceMinor}, bestSeller: ${_this.bestSeller}, categorySlug: ${_this.categorySlug}, colors: ${_this.colors}, dailyOnly: ${_this.dailyOnly}, descriptionAr: ${_this.descriptionAr}, descriptionEn: ${_this.descriptionEn}, designerTemplate: ${_this.designerTemplate}, flowerTypes: ${_this.flowerTypes}, images: ${_this.images}, kind: ${_this.kind}, leadTimeHours: ${_this.leadTimeHours}, limited: ${_this.limited}, nameAr: ${_this.nameAr}, nameEn: ${_this.nameEn}, occasions: ${_this.occasions}, optionGroups: ${_this.optionGroups}, pairings: ${_this.pairings}, popularity: ${_this.popularity}, seasonal: ${_this.seasonal}, slug: ${_this.slug}, status: ${_this.status}, stockQuantity: ${_this.stockQuantity}, subtitleAr: ${_this.subtitleAr}, subtitleEn: ${_this.subtitleEn}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $UpdateProductDtoCopyWith<$Res>  {
  factory $UpdateProductDtoCopyWith(UpdateProductDto value, $Res Function(UpdateProductDto) _then) = _$UpdateProductDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) List<String>? allergens,@JsonKey(disallowNullValue: true, includeIfNull: false) num? basePriceMinor,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? bestSeller,@JsonKey(disallowNullValue: true, includeIfNull: false) String? categorySlug,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: UpdateProductDto._read_colors, toJson: UpdateProductDto._write_colors) List<UpdateProductDtoColorsItem>? colors,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? dailyOnly,@JsonKey(disallowNullValue: true, includeIfNull: false) String? descriptionAr,@JsonKey(disallowNullValue: true, includeIfNull: false) String? descriptionEn,@JsonKey(includeIfNull: false) UpdateProductDtoDesignerTemplate? designerTemplate,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: UpdateProductDto._read_flowerTypes, toJson: UpdateProductDto._write_flowerTypes) List<UpdateProductDtoFlowerTypesItem>? flowerTypes,@JsonKey(disallowNullValue: true, includeIfNull: false) List<ImageInputDto>? images,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: UpdateProductDto._read_kind, toJson: UpdateProductDto._write_kind) UpdateProductDtoKind? kind,@JsonKey(disallowNullValue: true, includeIfNull: false) num? leadTimeHours,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? limited,@JsonKey(disallowNullValue: true, includeIfNull: false) String? nameAr,@JsonKey(disallowNullValue: true, includeIfNull: false) String? nameEn,@JsonKey(disallowNullValue: true, includeIfNull: false) List<String>? occasions,@JsonKey(disallowNullValue: true, includeIfNull: false) List<OptionGroupInputDto>? optionGroups,@JsonKey(disallowNullValue: true, includeIfNull: false) List<String>? pairings,@JsonKey(disallowNullValue: true, includeIfNull: false) num? popularity,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? seasonal,@JsonKey(disallowNullValue: true, includeIfNull: false) String? slug,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: UpdateProductDto._read_status, toJson: UpdateProductDto._write_status) UpdateProductDtoStatus? status,@JsonKey(includeIfNull: false) num? stockQuantity,@JsonKey(disallowNullValue: true, includeIfNull: false) String? subtitleAr,@JsonKey(disallowNullValue: true, includeIfNull: false) String? subtitleEn,@JsonKey(readValue: UpdateProductDto._extras, fromJson: UpdateProductDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$UpdateProductDtoDesignerTemplateCopyWith<$Res>? get designerTemplate;

}
/// @nodoc
class _$UpdateProductDtoCopyWithImpl<$Res>
    implements $UpdateProductDtoCopyWith<$Res> {
  _$UpdateProductDtoCopyWithImpl(this._self, this._then);

  final UpdateProductDto _self;
  final $Res Function(UpdateProductDto) _then;

/// Create a copy of UpdateProductDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allergens = freezed,Object? basePriceMinor = freezed,Object? bestSeller = freezed,Object? categorySlug = freezed,Object? colors = freezed,Object? dailyOnly = freezed,Object? descriptionAr = freezed,Object? descriptionEn = freezed,Object? designerTemplate = freezed,Object? flowerTypes = freezed,Object? images = freezed,Object? kind = freezed,Object? leadTimeHours = freezed,Object? limited = freezed,Object? nameAr = freezed,Object? nameEn = freezed,Object? occasions = freezed,Object? optionGroups = freezed,Object? pairings = freezed,Object? popularity = freezed,Object? seasonal = freezed,Object? slug = freezed,Object? status = freezed,Object? stockQuantity = freezed,Object? subtitleAr = freezed,Object? subtitleEn = freezed,Object? additionalProperties = null,}) {
  return _then(UpdateProductDto(
allergens: freezed == allergens ? _self.allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<String>?,basePriceMinor: freezed == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as num?,bestSeller: freezed == bestSeller ? _self.bestSeller : bestSeller // ignore: cast_nullable_to_non_nullable
as bool?,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,colors: freezed == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as List<UpdateProductDtoColorsItem>?,dailyOnly: freezed == dailyOnly ? _self.dailyOnly : dailyOnly // ignore: cast_nullable_to_non_nullable
as bool?,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,descriptionEn: freezed == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String?,designerTemplate: freezed == designerTemplate ? _self.designerTemplate : designerTemplate // ignore: cast_nullable_to_non_nullable
as UpdateProductDtoDesignerTemplate?,flowerTypes: freezed == flowerTypes ? _self.flowerTypes : flowerTypes // ignore: cast_nullable_to_non_nullable
as List<UpdateProductDtoFlowerTypesItem>?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ImageInputDto>?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as UpdateProductDtoKind?,leadTimeHours: freezed == leadTimeHours ? _self.leadTimeHours : leadTimeHours // ignore: cast_nullable_to_non_nullable
as num?,limited: freezed == limited ? _self.limited : limited // ignore: cast_nullable_to_non_nullable
as bool?,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,occasions: freezed == occasions ? _self.occasions : occasions // ignore: cast_nullable_to_non_nullable
as List<String>?,optionGroups: freezed == optionGroups ? _self.optionGroups : optionGroups // ignore: cast_nullable_to_non_nullable
as List<OptionGroupInputDto>?,pairings: freezed == pairings ? _self.pairings : pairings // ignore: cast_nullable_to_non_nullable
as List<String>?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as num?,seasonal: freezed == seasonal ? _self.seasonal : seasonal // ignore: cast_nullable_to_non_nullable
as bool?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UpdateProductDtoStatus?,stockQuantity: freezed == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as num?,subtitleAr: freezed == subtitleAr ? _self.subtitleAr : subtitleAr // ignore: cast_nullable_to_non_nullable
as String?,subtitleEn: freezed == subtitleEn ? _self.subtitleEn : subtitleEn // ignore: cast_nullable_to_non_nullable
as String?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of UpdateProductDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateProductDtoDesignerTemplateCopyWith<$Res>? get designerTemplate {
    if (_self.designerTemplate == null) {
    return null;
  }

  return $UpdateProductDtoDesignerTemplateCopyWith<$Res>(_self.designerTemplate!, (value) {
    return _then(_self.copyWith(designerTemplate: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateProductDto].
extension UpdateProductDtoPatterns on UpdateProductDto {
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
