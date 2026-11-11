// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductDetailDto {


/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailDtoCopyWith<ProductDetailDto> get copyWith => _$ProductDetailDtoCopyWithImpl<ProductDetailDto>(this as ProductDetailDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductDetailDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailDto&&const DeepCollectionEquality().equals(other.allergens, _this.allergens)&&(identical(other.available, _this.available) || other.available == _this.available)&&const DeepCollectionEquality().equals(other.badges, _this.badges)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.categorySlug, _this.categorySlug) || other.categorySlug == _this.categorySlug)&&const DeepCollectionEquality().equals(other.colors, _this.colors)&&(identical(other.customizable, _this.customizable) || other.customizable == _this.customizable)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.earliestDeliveryInDays, _this.earliestDeliveryInDays) || other.earliestDeliveryInDays == _this.earliestDeliveryInDays)&&const DeepCollectionEquality().equals(other.flowerTypes, _this.flowerTypes)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&const DeepCollectionEquality().equals(other.images, _this.images)&&(identical(other.isFavorite, _this.isFavorite) || other.isFavorite == _this.isFavorite)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.leadTimeHours, _this.leadTimeHours) || other.leadTimeHours == _this.leadTimeHours)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.occasions, _this.occasions)&&const DeepCollectionEquality().equals(other.optionGroups, _this.optionGroups)&&const DeepCollectionEquality().equals(other.pairings, _this.pairings)&&(identical(other.priceFrom, _this.priceFrom) || other.priceFrom == _this.priceFrom)&&(identical(other.priceMinor, _this.priceMinor) || other.priceMinor == _this.priceMinor)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.stockLeft, _this.stockLeft) || other.stockLeft == _this.stockLeft)&&(identical(other.subtitle, _this.subtitle) || other.subtitle == _this.subtitle)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as ProductDetailDto;
  return Object.hashAll([runtimeType,const DeepCollectionEquality().hash(_this.allergens),_this.available,const DeepCollectionEquality().hash(_this.badges),_this.category,_this.categorySlug,const DeepCollectionEquality().hash(_this.colors),_this.customizable,_this.description,_this.earliestDeliveryInDays,const DeepCollectionEquality().hash(_this.flowerTypes),_this.id,_this.imageUrl,const DeepCollectionEquality().hash(_this.images),_this.isFavorite,_this.kind,_this.leadTimeHours,_this.name,const DeepCollectionEquality().hash(_this.occasions),const DeepCollectionEquality().hash(_this.optionGroups),const DeepCollectionEquality().hash(_this.pairings),_this.priceFrom,_this.priceMinor,_this.slug,_this.stockLeft,_this.subtitle,const DeepCollectionEquality().hash(_this.additionalProperties)]);
}

@override
String toString() {
  final _this = this as ProductDetailDto;
  return 'ProductDetailDto(allergens: ${_this.allergens}, available: ${_this.available}, badges: ${_this.badges}, category: ${_this.category}, categorySlug: ${_this.categorySlug}, colors: ${_this.colors}, customizable: ${_this.customizable}, description: ${_this.description}, earliestDeliveryInDays: ${_this.earliestDeliveryInDays}, flowerTypes: ${_this.flowerTypes}, id: ${_this.id}, imageUrl: ${_this.imageUrl}, images: ${_this.images}, isFavorite: ${_this.isFavorite}, kind: ${_this.kind}, leadTimeHours: ${_this.leadTimeHours}, name: ${_this.name}, occasions: ${_this.occasions}, optionGroups: ${_this.optionGroups}, pairings: ${_this.pairings}, priceFrom: ${_this.priceFrom}, priceMinor: ${_this.priceMinor}, slug: ${_this.slug}, stockLeft: ${_this.stockLeft}, subtitle: ${_this.subtitle}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $ProductDetailDtoCopyWith<$Res>  {
  factory $ProductDetailDtoCopyWith(ProductDetailDto value, $Res Function(ProductDetailDto) _then) = _$ProductDetailDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) List<String> allergens,@JsonKey(required: true, disallowNullValue: true) bool available,@JsonKey(required: true, disallowNullValue: true, fromJson: ProductDetailDto._read_badges, toJson: ProductDetailDto._write_badges) List<ProductBadge> badges,@JsonKey(required: true, disallowNullValue: true) CategoryRefDto category,@JsonKey(required: true, disallowNullValue: true) String categorySlug,@JsonKey(required: true, disallowNullValue: true) List<String> colors,@JsonKey(required: true, disallowNullValue: true) bool customizable,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto description,@JsonKey(required: true, disallowNullValue: true, fromJson: ProductDetailDto._read_earliestDeliveryInDays, toJson: ProductDetailDto._write_earliestDeliveryInDays) int earliestDeliveryInDays,@JsonKey(required: true, disallowNullValue: true) List<String> flowerTypes,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true) String? imageUrl,@JsonKey(required: true, disallowNullValue: true) List<ProductImageDto> images,@JsonKey(required: true, disallowNullValue: true) bool isFavorite,@JsonKey(required: true, disallowNullValue: true, fromJson: ProductDetailDto._read_kind, toJson: ProductDetailDto._write_kind) ProductKind kind,@JsonKey(required: true, disallowNullValue: true, fromJson: ProductDetailDto._read_leadTimeHours, toJson: ProductDetailDto._write_leadTimeHours) int leadTimeHours,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto name,@JsonKey(required: true, disallowNullValue: true) List<String> occasions,@JsonKey(required: true, disallowNullValue: true) List<ProductOptionGroupDto> optionGroups,@JsonKey(required: true, disallowNullValue: true) List<ProductCardDto> pairings,@JsonKey(required: true, disallowNullValue: true) bool priceFrom,@JsonKey(required: true, disallowNullValue: true, fromJson: ProductDetailDto._read_priceMinor, toJson: ProductDetailDto._write_priceMinor) int priceMinor,@JsonKey(required: true, disallowNullValue: true) String slug,@JsonKey(required: true, fromJson: ProductDetailDto._read_stockLeft, toJson: ProductDetailDto._write_stockLeft) int? stockLeft,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto subtitle,@JsonKey(readValue: ProductDetailDto._extras, fromJson: ProductDetailDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$CategoryRefDtoCopyWith<$Res> get category;$LocalizedTextDtoCopyWith<$Res> get description;$LocalizedTextDtoCopyWith<$Res> get name;$LocalizedTextDtoCopyWith<$Res> get subtitle;

}
/// @nodoc
class _$ProductDetailDtoCopyWithImpl<$Res>
    implements $ProductDetailDtoCopyWith<$Res> {
  _$ProductDetailDtoCopyWithImpl(this._self, this._then);

  final ProductDetailDto _self;
  final $Res Function(ProductDetailDto) _then;

/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allergens = null,Object? available = null,Object? badges = null,Object? category = null,Object? categorySlug = null,Object? colors = null,Object? customizable = null,Object? description = null,Object? earliestDeliveryInDays = null,Object? flowerTypes = null,Object? id = null,Object? imageUrl = freezed,Object? images = null,Object? isFavorite = null,Object? kind = null,Object? leadTimeHours = null,Object? name = null,Object? occasions = null,Object? optionGroups = null,Object? pairings = null,Object? priceFrom = null,Object? priceMinor = null,Object? slug = null,Object? stockLeft = freezed,Object? subtitle = null,Object? additionalProperties = null,}) {
  return _then(ProductDetailDto(
allergens: null == allergens ? _self.allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<String>,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<ProductBadge>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryRefDto,categorySlug: null == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String,colors: null == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as List<String>,customizable: null == customizable ? _self.customizable : customizable // ignore: cast_nullable_to_non_nullable
as bool,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,earliestDeliveryInDays: null == earliestDeliveryInDays ? _self.earliestDeliveryInDays : earliestDeliveryInDays // ignore: cast_nullable_to_non_nullable
as int,flowerTypes: null == flowerTypes ? _self.flowerTypes : flowerTypes // ignore: cast_nullable_to_non_nullable
as List<String>,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImageDto>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProductKind,leadTimeHours: null == leadTimeHours ? _self.leadTimeHours : leadTimeHours // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,occasions: null == occasions ? _self.occasions : occasions // ignore: cast_nullable_to_non_nullable
as List<String>,optionGroups: null == optionGroups ? _self.optionGroups : optionGroups // ignore: cast_nullable_to_non_nullable
as List<ProductOptionGroupDto>,pairings: null == pairings ? _self.pairings : pairings // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>,priceFrom: null == priceFrom ? _self.priceFrom : priceFrom // ignore: cast_nullable_to_non_nullable
as bool,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,stockLeft: freezed == stockLeft ? _self.stockLeft : stockLeft // ignore: cast_nullable_to_non_nullable
as int?,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryRefDtoCopyWith<$Res> get category {
  
  return $CategoryRefDtoCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get description {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get name {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of ProductDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get subtitle {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.subtitle, (value) {
    return _then(_self.copyWith(subtitle: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductDetailDto].
extension ProductDetailDtoPatterns on ProductDetailDto {
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
