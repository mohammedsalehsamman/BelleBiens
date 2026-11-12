// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_quote_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartQuoteRequestDto {


/// Create a copy of CartQuoteRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartQuoteRequestDtoCopyWith<CartQuoteRequestDto> get copyWith => _$CartQuoteRequestDtoCopyWithImpl<CartQuoteRequestDto>(this as CartQuoteRequestDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CartQuoteRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartQuoteRequestDto&&(identical(other.couponCode, _this.couponCode) || other.couponCode == _this.couponCode)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.zone, _this.zone) || other.zone == _this.zone)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as CartQuoteRequestDto;
  return Object.hash(runtimeType,_this.couponCode,const DeepCollectionEquality().hash(_this.lines),_this.zone,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as CartQuoteRequestDto;
  return 'CartQuoteRequestDto(couponCode: ${_this.couponCode}, lines: ${_this.lines}, zone: ${_this.zone}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $CartQuoteRequestDtoCopyWith<$Res>  {
  factory $CartQuoteRequestDtoCopyWith(CartQuoteRequestDto value, $Res Function(CartQuoteRequestDto) _then) = _$CartQuoteRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) String? couponCode,@JsonKey(required: true, disallowNullValue: true) List<CartLineInputDto> lines,@JsonKey(disallowNullValue: true, includeIfNull: false) String? zone,@JsonKey(readValue: CartQuoteRequestDto._extras, fromJson: CartQuoteRequestDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$CartQuoteRequestDtoCopyWithImpl<$Res>
    implements $CartQuoteRequestDtoCopyWith<$Res> {
  _$CartQuoteRequestDtoCopyWithImpl(this._self, this._then);

  final CartQuoteRequestDto _self;
  final $Res Function(CartQuoteRequestDto) _then;

/// Create a copy of CartQuoteRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? couponCode = freezed,Object? lines = null,Object? zone = freezed,Object? additionalProperties = null,}) {
  return _then(CartQuoteRequestDto(
couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<CartLineInputDto>,zone: freezed == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as String?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [CartQuoteRequestDto].
extension CartQuoteRequestDtoPatterns on CartQuoteRequestDto {
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
