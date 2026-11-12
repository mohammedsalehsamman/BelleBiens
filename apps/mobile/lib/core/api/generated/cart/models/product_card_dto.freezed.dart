// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductCardDto {


/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCardDtoCopyWith<ProductCardDto> get copyWith => _$ProductCardDtoCopyWithImpl<ProductCardDto>(this as ProductCardDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductCardDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductCardDto&&(identical(other.available, _this.available) || other.available == _this.available)&&const DeepCollectionEquality().equals(other.badges, _this.badges)&&(identical(other.categorySlug, _this.categorySlug) || other.categorySlug == _this.categorySlug)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.leadTimeHours, _this.leadTimeHours) || other.leadTimeHours == _this.leadTimeHours)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.priceFrom, _this.priceFrom) || other.priceFrom == _this.priceFrom)&&(identical(other.priceMinor, _this.priceMinor) || other.priceMinor == _this.priceMinor)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.stockLeft, _this.stockLeft) || other.stockLeft == _this.stockLeft)&&(identical(other.subtitle, _this.subtitle) || other.subtitle == _this.subtitle)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as ProductCardDto;
  return Object.hash(runtimeType,_this.available,const DeepCollectionEquality().hash(_this.badges),_this.categorySlug,_this.id,_this.imageUrl,_this.kind,_this.leadTimeHours,_this.name,_this.priceFrom,_this.priceMinor,_this.slug,_this.stockLeft,_this.subtitle,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as ProductCardDto;
  return 'ProductCardDto(available: ${_this.available}, badges: ${_this.badges}, categorySlug: ${_this.categorySlug}, id: ${_this.id}, imageUrl: ${_this.imageUrl}, kind: ${_this.kind}, leadTimeHours: ${_this.leadTimeHours}, name: ${_this.name}, priceFrom: ${_this.priceFrom}, priceMinor: ${_this.priceMinor}, slug: ${_this.slug}, stockLeft: ${_this.stockLeft}, subtitle: ${_this.subtitle}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $ProductCardDtoCopyWith<$Res>  {
  factory $ProductCardDtoCopyWith(ProductCardDto value, $Res Function(ProductCardDto) _then) = _$ProductCardDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) bool available,@JsonKey(required: true, disallowNullValue: true, fromJson: ProductCardDto._read_badges, toJson: ProductCardDto._write_badges) List<ProductBadge> badges,@JsonKey(required: true, disallowNullValue: true) String categorySlug,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true) String? imageUrl,@JsonKey(required: true, disallowNullValue: true, fromJson: ProductCardDto._read_kind, toJson: ProductCardDto._write_kind) ProductKind kind,@JsonKey(required: true, disallowNullValue: true, fromJson: ProductCardDto._read_leadTimeHours, toJson: ProductCardDto._write_leadTimeHours) int leadTimeHours,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto name,@JsonKey(required: true, disallowNullValue: true) bool priceFrom,@JsonKey(required: true, disallowNullValue: true, fromJson: ProductCardDto._read_priceMinor, toJson: ProductCardDto._write_priceMinor) int priceMinor,@JsonKey(required: true, disallowNullValue: true) String slug,@JsonKey(required: true, fromJson: ProductCardDto._read_stockLeft, toJson: ProductCardDto._write_stockLeft) int? stockLeft,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto subtitle,@JsonKey(readValue: ProductCardDto._extras, fromJson: ProductCardDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$LocalizedTextDtoCopyWith<$Res> get name;$LocalizedTextDtoCopyWith<$Res> get subtitle;

}
/// @nodoc
class _$ProductCardDtoCopyWithImpl<$Res>
    implements $ProductCardDtoCopyWith<$Res> {
  _$ProductCardDtoCopyWithImpl(this._self, this._then);

  final ProductCardDto _self;
  final $Res Function(ProductCardDto) _then;

/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? badges = null,Object? categorySlug = null,Object? id = null,Object? imageUrl = freezed,Object? kind = null,Object? leadTimeHours = null,Object? name = null,Object? priceFrom = null,Object? priceMinor = null,Object? slug = null,Object? stockLeft = freezed,Object? subtitle = null,Object? additionalProperties = null,}) {
  return _then(ProductCardDto(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<ProductBadge>,categorySlug: null == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProductKind,leadTimeHours: null == leadTimeHours ? _self.leadTimeHours : leadTimeHours // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,priceFrom: null == priceFrom ? _self.priceFrom : priceFrom // ignore: cast_nullable_to_non_nullable
as bool,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,stockLeft: freezed == stockLeft ? _self.stockLeft : stockLeft // ignore: cast_nullable_to_non_nullable
as int?,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get name {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get subtitle {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.subtitle, (value) {
    return _then(_self.copyWith(subtitle: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductCardDto].
extension ProductCardDtoPatterns on ProductCardDto {
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
