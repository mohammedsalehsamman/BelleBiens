// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payments_config_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentsConfigDto {


/// Create a copy of PaymentsConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentsConfigDtoCopyWith<PaymentsConfigDto> get copyWith => _$PaymentsConfigDtoCopyWithImpl<PaymentsConfigDto>(this as PaymentsConfigDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaymentsConfigDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentsConfigDto&&(identical(other.cash, _this.cash) || other.cash == _this.cash)&&(identical(other.shamcash, _this.shamcash) || other.shamcash == _this.shamcash)&&(identical(other.stripe, _this.stripe) || other.stripe == _this.stripe)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as PaymentsConfigDto;
  return Object.hash(runtimeType,_this.cash,_this.shamcash,_this.stripe,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as PaymentsConfigDto;
  return 'PaymentsConfigDto(cash: ${_this.cash}, shamcash: ${_this.shamcash}, stripe: ${_this.stripe}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $PaymentsConfigDtoCopyWith<$Res>  {
  factory $PaymentsConfigDtoCopyWith(PaymentsConfigDto value, $Res Function(PaymentsConfigDto) _then) = _$PaymentsConfigDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) bool cash,@JsonKey(required: true, disallowNullValue: true) bool shamcash,@JsonKey(required: true, disallowNullValue: true) bool stripe,@JsonKey(readValue: PaymentsConfigDto._extras, fromJson: PaymentsConfigDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$PaymentsConfigDtoCopyWithImpl<$Res>
    implements $PaymentsConfigDtoCopyWith<$Res> {
  _$PaymentsConfigDtoCopyWithImpl(this._self, this._then);

  final PaymentsConfigDto _self;
  final $Res Function(PaymentsConfigDto) _then;

/// Create a copy of PaymentsConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cash = null,Object? shamcash = null,Object? stripe = null,Object? additionalProperties = null,}) {
  return _then(PaymentsConfigDto(
cash: null == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as bool,shamcash: null == shamcash ? _self.shamcash : shamcash // ignore: cast_nullable_to_non_nullable
as bool,stripe: null == stripe ? _self.stripe : stripe // ignore: cast_nullable_to_non_nullable
as bool,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentsConfigDto].
extension PaymentsConfigDtoPatterns on PaymentsConfigDto {
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
