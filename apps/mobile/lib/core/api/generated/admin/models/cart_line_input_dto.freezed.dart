// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_line_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartLineInputDto {


/// Create a copy of CartLineInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartLineInputDtoCopyWith<CartLineInputDto> get copyWith => _$CartLineInputDtoCopyWithImpl<CartLineInputDto>(this as CartLineInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CartLineInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartLineInputDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.previewUrl, _this.previewUrl) || other.previewUrl == _this.previewUrl)&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.spec, _this.spec) || other.spec == _this.spec)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as CartLineInputDto;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.previewUrl,_this.product,_this.qty,_this.spec,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as CartLineInputDto;
  return 'CartLineInputDto(id: ${_this.id}, kind: ${_this.kind}, previewUrl: ${_this.previewUrl}, product: ${_this.product}, qty: ${_this.qty}, spec: ${_this.spec}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $CartLineInputDtoCopyWith<$Res>  {
  factory $CartLineInputDtoCopyWith(CartLineInputDto value, $Res Function(CartLineInputDto) _then) = _$CartLineInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true, disallowNullValue: true, fromJson: CartLineInputDto._read_kind, toJson: CartLineInputDto._write_kind) CartLineKind kind,@JsonKey(disallowNullValue: true, includeIfNull: false) String? previewUrl,@JsonKey(disallowNullValue: true, includeIfNull: false) ProductChoiceDto? product,@JsonKey(required: true, disallowNullValue: true) num qty,@JsonKey(disallowNullValue: true, includeIfNull: false) CartLineInputDtoSpec? spec,@JsonKey(readValue: CartLineInputDto._extras, fromJson: CartLineInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$ProductChoiceDtoCopyWith<$Res>? get product;$CartLineInputDtoSpecCopyWith<$Res>? get spec;

}
/// @nodoc
class _$CartLineInputDtoCopyWithImpl<$Res>
    implements $CartLineInputDtoCopyWith<$Res> {
  _$CartLineInputDtoCopyWithImpl(this._self, this._then);

  final CartLineInputDto _self;
  final $Res Function(CartLineInputDto) _then;

/// Create a copy of CartLineInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? previewUrl = freezed,Object? product = freezed,Object? qty = null,Object? spec = freezed,Object? additionalProperties = null,}) {
  return _then(CartLineInputDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CartLineKind,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductChoiceDto?,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as num,spec: freezed == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as CartLineInputDtoSpec?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of CartLineInputDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductChoiceDtoCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductChoiceDtoCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of CartLineInputDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CartLineInputDtoSpecCopyWith<$Res>? get spec {
    if (_self.spec == null) {
    return null;
  }

  return $CartLineInputDtoSpecCopyWith<$Res>(_self.spec!, (value) {
    return _then(_self.copyWith(spec: value));
  });
}
}


/// Adds pattern-matching-related methods to [CartLineInputDto].
extension CartLineInputDtoPatterns on CartLineInputDto {
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
