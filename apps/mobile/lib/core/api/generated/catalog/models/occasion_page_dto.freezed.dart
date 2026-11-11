// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'occasion_page_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OccasionPageDto {


/// Create a copy of OccasionPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OccasionPageDtoCopyWith<OccasionPageDto> get copyWith => _$OccasionPageDtoCopyWithImpl<OccasionPageDto>(this as OccasionPageDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OccasionPageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OccasionPageDto&&(identical(other.occasion, _this.occasion) || other.occasion == _this.occasion)&&const DeepCollectionEquality().equals(other.products, _this.products)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as OccasionPageDto;
  return Object.hash(runtimeType,_this.occasion,const DeepCollectionEquality().hash(_this.products),const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as OccasionPageDto;
  return 'OccasionPageDto(occasion: ${_this.occasion}, products: ${_this.products}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $OccasionPageDtoCopyWith<$Res>  {
  factory $OccasionPageDtoCopyWith(OccasionPageDto value, $Res Function(OccasionPageDto) _then) = _$OccasionPageDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) OccasionDto occasion,@JsonKey(required: true, disallowNullValue: true) List<ProductCardDto> products,@JsonKey(readValue: OccasionPageDto._extras, fromJson: OccasionPageDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$OccasionDtoCopyWith<$Res> get occasion;

}
/// @nodoc
class _$OccasionPageDtoCopyWithImpl<$Res>
    implements $OccasionPageDtoCopyWith<$Res> {
  _$OccasionPageDtoCopyWithImpl(this._self, this._then);

  final OccasionPageDto _self;
  final $Res Function(OccasionPageDto) _then;

/// Create a copy of OccasionPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? occasion = null,Object? products = null,Object? additionalProperties = null,}) {
  return _then(OccasionPageDto(
occasion: null == occasion ? _self.occasion : occasion // ignore: cast_nullable_to_non_nullable
as OccasionDto,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of OccasionPageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OccasionDtoCopyWith<$Res> get occasion {
  
  return $OccasionDtoCopyWith<$Res>(_self.occasion, (value) {
    return _then(_self.copyWith(occasion: value));
  });
}
}


/// Adds pattern-matching-related methods to [OccasionPageDto].
extension OccasionPageDtoPatterns on OccasionPageDto {
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
