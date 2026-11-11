// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency_config_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CurrencyConfigDto {


/// Create a copy of CurrencyConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrencyConfigDtoCopyWith<CurrencyConfigDto> get copyWith => _$CurrencyConfigDtoCopyWithImpl<CurrencyConfigDto>(this as CurrencyConfigDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CurrencyConfigDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrencyConfigDto&&(identical(other.base2, _this.base2) || other.base2 == _this.base2)&&(identical(other.usdRate, _this.usdRate) || other.usdRate == _this.usdRate)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as CurrencyConfigDto;
  return Object.hash(runtimeType,_this.base2,_this.usdRate,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as CurrencyConfigDto;
  return 'CurrencyConfigDto(base2: ${_this.base2}, usdRate: ${_this.usdRate}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $CurrencyConfigDtoCopyWith<$Res>  {
  factory $CurrencyConfigDtoCopyWith(CurrencyConfigDto value, $Res Function(CurrencyConfigDto) _then) = _$CurrencyConfigDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "base", required: true, disallowNullValue: true) String base2,@JsonKey(required: true, disallowNullValue: true) String usdRate,@JsonKey(readValue: CurrencyConfigDto._extras, fromJson: CurrencyConfigDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$CurrencyConfigDtoCopyWithImpl<$Res>
    implements $CurrencyConfigDtoCopyWith<$Res> {
  _$CurrencyConfigDtoCopyWithImpl(this._self, this._then);

  final CurrencyConfigDto _self;
  final $Res Function(CurrencyConfigDto) _then;

/// Create a copy of CurrencyConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? base2 = null,Object? usdRate = null,Object? additionalProperties = null,}) {
  return _then(CurrencyConfigDto(
base2: null == base2 ? _self.base2 : base2 // ignore: cast_nullable_to_non_nullable
as String,usdRate: null == usdRate ? _self.usdRate : usdRate // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrencyConfigDto].
extension CurrencyConfigDtoPatterns on CurrencyConfigDto {
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
