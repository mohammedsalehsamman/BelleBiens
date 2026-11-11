// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_option_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductOptionDto {


/// Create a copy of ProductOptionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductOptionDtoCopyWith<ProductOptionDto> get copyWith => _$ProductOptionDtoCopyWithImpl<ProductOptionDto>(this as ProductOptionDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductOptionDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductOptionDto&&(identical(other.detail, _this.detail) || other.detail == _this.detail)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.priceChangeMinor, _this.priceChangeMinor) || other.priceChangeMinor == _this.priceChangeMinor)&&(identical(other.swatch, _this.swatch) || other.swatch == _this.swatch)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as ProductOptionDto;
  return Object.hash(runtimeType,_this.detail,_this.isDefault,_this.key,_this.name,_this.priceChangeMinor,_this.swatch,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as ProductOptionDto;
  return 'ProductOptionDto(detail: ${_this.detail}, isDefault: ${_this.isDefault}, key: ${_this.key}, name: ${_this.name}, priceChangeMinor: ${_this.priceChangeMinor}, swatch: ${_this.swatch}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $ProductOptionDtoCopyWith<$Res>  {
  factory $ProductOptionDtoCopyWith(ProductOptionDto value, $Res Function(ProductOptionDto) _then) = _$ProductOptionDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto detail,@JsonKey(required: true, disallowNullValue: true) bool isDefault,@JsonKey(required: true, disallowNullValue: true) String key,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto name,@JsonKey(required: true, disallowNullValue: true, fromJson: ProductOptionDto._read_priceChangeMinor, toJson: ProductOptionDto._write_priceChangeMinor) int priceChangeMinor,@JsonKey(required: true) String? swatch,@JsonKey(readValue: ProductOptionDto._extras, fromJson: ProductOptionDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$LocalizedTextDtoCopyWith<$Res> get detail;$LocalizedTextDtoCopyWith<$Res> get name;

}
/// @nodoc
class _$ProductOptionDtoCopyWithImpl<$Res>
    implements $ProductOptionDtoCopyWith<$Res> {
  _$ProductOptionDtoCopyWithImpl(this._self, this._then);

  final ProductOptionDto _self;
  final $Res Function(ProductOptionDto) _then;

/// Create a copy of ProductOptionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? detail = null,Object? isDefault = null,Object? key = null,Object? name = null,Object? priceChangeMinor = null,Object? swatch = freezed,Object? additionalProperties = null,}) {
  return _then(ProductOptionDto(
detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,priceChangeMinor: null == priceChangeMinor ? _self.priceChangeMinor : priceChangeMinor // ignore: cast_nullable_to_non_nullable
as int,swatch: freezed == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as String?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of ProductOptionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get detail {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.detail, (value) {
    return _then(_self.copyWith(detail: value));
  });
}/// Create a copy of ProductOptionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get name {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductOptionDto].
extension ProductOptionDtoPatterns on ProductOptionDto {
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
