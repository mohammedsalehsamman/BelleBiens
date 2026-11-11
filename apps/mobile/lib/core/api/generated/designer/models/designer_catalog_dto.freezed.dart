// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'designer_catalog_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DesignerCatalogDto {


/// Create a copy of DesignerCatalogDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DesignerCatalogDtoCopyWith<DesignerCatalogDto> get copyWith => _$DesignerCatalogDtoCopyWithImpl<DesignerCatalogDto>(this as DesignerCatalogDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DesignerCatalogDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DesignerCatalogDto&&(identical(other.date, _this.date) || other.date == _this.date)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.layouts, _this.layouts) || other.layouts == _this.layouts)&&const DeepCollectionEquality().equals(other.occasions, _this.occasions)&&const DeepCollectionEquality().equals(other.palettes, _this.palettes)&&const DeepCollectionEquality().equals(other.sizes, _this.sizes)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as DesignerCatalogDto;
  return Object.hash(runtimeType,_this.date,const DeepCollectionEquality().hash(_this.items),_this.layouts,const DeepCollectionEquality().hash(_this.occasions),const DeepCollectionEquality().hash(_this.palettes),const DeepCollectionEquality().hash(_this.sizes),const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as DesignerCatalogDto;
  return 'DesignerCatalogDto(date: ${_this.date}, items: ${_this.items}, layouts: ${_this.layouts}, occasions: ${_this.occasions}, palettes: ${_this.palettes}, sizes: ${_this.sizes}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $DesignerCatalogDtoCopyWith<$Res>  {
  factory $DesignerCatalogDtoCopyWith(DesignerCatalogDto value, $Res Function(DesignerCatalogDto) _then) = _$DesignerCatalogDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String date,@JsonKey(required: true, disallowNullValue: true) List<DesignerItemDto> items,@JsonKey(required: true, disallowNullValue: true) SlotLayoutsDto layouts,@JsonKey(required: true, disallowNullValue: true) List<OccasionOptionDto> occasions,@JsonKey(required: true, disallowNullValue: true) List<PaletteDto> palettes,@JsonKey(required: true, disallowNullValue: true) List<DesignerSizeDto> sizes,@JsonKey(readValue: DesignerCatalogDto._extras, fromJson: DesignerCatalogDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$SlotLayoutsDtoCopyWith<$Res> get layouts;

}
/// @nodoc
class _$DesignerCatalogDtoCopyWithImpl<$Res>
    implements $DesignerCatalogDtoCopyWith<$Res> {
  _$DesignerCatalogDtoCopyWithImpl(this._self, this._then);

  final DesignerCatalogDto _self;
  final $Res Function(DesignerCatalogDto) _then;

/// Create a copy of DesignerCatalogDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? items = null,Object? layouts = null,Object? occasions = null,Object? palettes = null,Object? sizes = null,Object? additionalProperties = null,}) {
  return _then(DesignerCatalogDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DesignerItemDto>,layouts: null == layouts ? _self.layouts : layouts // ignore: cast_nullable_to_non_nullable
as SlotLayoutsDto,occasions: null == occasions ? _self.occasions : occasions // ignore: cast_nullable_to_non_nullable
as List<OccasionOptionDto>,palettes: null == palettes ? _self.palettes : palettes // ignore: cast_nullable_to_non_nullable
as List<PaletteDto>,sizes: null == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<DesignerSizeDto>,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of DesignerCatalogDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotLayoutsDtoCopyWith<$Res> get layouts {
  
  return $SlotLayoutsDtoCopyWith<$Res>(_self.layouts, (value) {
    return _then(_self.copyWith(layouts: value));
  });
}
}


/// Adds pattern-matching-related methods to [DesignerCatalogDto].
extension DesignerCatalogDtoPatterns on DesignerCatalogDto {
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
