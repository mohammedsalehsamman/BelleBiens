// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_filters_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogFiltersDto {


/// Create a copy of CatalogFiltersDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogFiltersDtoCopyWith<CatalogFiltersDto> get copyWith => _$CatalogFiltersDtoCopyWithImpl<CatalogFiltersDto>(this as CatalogFiltersDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CatalogFiltersDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogFiltersDto&&const DeepCollectionEquality().equals(other.colors, _this.colors)&&const DeepCollectionEquality().equals(other.flowerTypes, _this.flowerTypes)&&const DeepCollectionEquality().equals(other.occasions, _this.occasions)&&(identical(other.price, _this.price) || other.price == _this.price)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as CatalogFiltersDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.colors),const DeepCollectionEquality().hash(_this.flowerTypes),const DeepCollectionEquality().hash(_this.occasions),_this.price,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as CatalogFiltersDto;
  return 'CatalogFiltersDto(colors: ${_this.colors}, flowerTypes: ${_this.flowerTypes}, occasions: ${_this.occasions}, price: ${_this.price}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $CatalogFiltersDtoCopyWith<$Res>  {
  factory $CatalogFiltersDtoCopyWith(CatalogFiltersDto value, $Res Function(CatalogFiltersDto) _then) = _$CatalogFiltersDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) List<VocabularyDto> colors,@JsonKey(required: true, disallowNullValue: true) List<VocabularyDto> flowerTypes,@JsonKey(required: true, disallowNullValue: true) List<VocabularyDto> occasions,@JsonKey(required: true, disallowNullValue: true) PriceRangeDto price,@JsonKey(readValue: CatalogFiltersDto._extras, fromJson: CatalogFiltersDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$PriceRangeDtoCopyWith<$Res> get price;

}
/// @nodoc
class _$CatalogFiltersDtoCopyWithImpl<$Res>
    implements $CatalogFiltersDtoCopyWith<$Res> {
  _$CatalogFiltersDtoCopyWithImpl(this._self, this._then);

  final CatalogFiltersDto _self;
  final $Res Function(CatalogFiltersDto) _then;

/// Create a copy of CatalogFiltersDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? colors = null,Object? flowerTypes = null,Object? occasions = null,Object? price = null,Object? additionalProperties = null,}) {
  return _then(CatalogFiltersDto(
colors: null == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as List<VocabularyDto>,flowerTypes: null == flowerTypes ? _self.flowerTypes : flowerTypes // ignore: cast_nullable_to_non_nullable
as List<VocabularyDto>,occasions: null == occasions ? _self.occasions : occasions // ignore: cast_nullable_to_non_nullable
as List<VocabularyDto>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as PriceRangeDto,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of CatalogFiltersDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceRangeDtoCopyWith<$Res> get price {
  
  return $PriceRangeDtoCopyWith<$Res>(_self.price, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [CatalogFiltersDto].
extension CatalogFiltersDtoPatterns on CatalogFiltersDto {
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
