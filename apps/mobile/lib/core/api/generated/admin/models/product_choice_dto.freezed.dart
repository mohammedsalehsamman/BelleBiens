// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_choice_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductChoiceDto {


/// Create a copy of ProductChoiceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductChoiceDtoCopyWith<ProductChoiceDto> get copyWith => _$ProductChoiceDtoCopyWithImpl<ProductChoiceDto>(this as ProductChoiceDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductChoiceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductChoiceDto&&(identical(other.inscription, _this.inscription) || other.inscription == _this.inscription)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.referenceImageUrl, _this.referenceImageUrl) || other.referenceImageUrl == _this.referenceImageUrl)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as ProductChoiceDto;
  return Object.hash(runtimeType,_this.inscription,const DeepCollectionEquality().hash(_this.options),_this.referenceImageUrl,_this.slug,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as ProductChoiceDto;
  return 'ProductChoiceDto(inscription: ${_this.inscription}, options: ${_this.options}, referenceImageUrl: ${_this.referenceImageUrl}, slug: ${_this.slug}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $ProductChoiceDtoCopyWith<$Res>  {
  factory $ProductChoiceDtoCopyWith(ProductChoiceDto value, $Res Function(ProductChoiceDto) _then) = _$ProductChoiceDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) String? inscription,@JsonKey(required: true, disallowNullValue: true) List<OptionChoiceDto> options,@JsonKey(disallowNullValue: true, includeIfNull: false) String? referenceImageUrl,@JsonKey(required: true, disallowNullValue: true) String slug,@JsonKey(readValue: ProductChoiceDto._extras, fromJson: ProductChoiceDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$ProductChoiceDtoCopyWithImpl<$Res>
    implements $ProductChoiceDtoCopyWith<$Res> {
  _$ProductChoiceDtoCopyWithImpl(this._self, this._then);

  final ProductChoiceDto _self;
  final $Res Function(ProductChoiceDto) _then;

/// Create a copy of ProductChoiceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inscription = freezed,Object? options = null,Object? referenceImageUrl = freezed,Object? slug = null,Object? additionalProperties = null,}) {
  return _then(ProductChoiceDto(
inscription: freezed == inscription ? _self.inscription : inscription // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<OptionChoiceDto>,referenceImageUrl: freezed == referenceImageUrl ? _self.referenceImageUrl : referenceImageUrl // ignore: cast_nullable_to_non_nullable
as String?,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductChoiceDto].
extension ProductChoiceDtoPatterns on ProductChoiceDto {
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
