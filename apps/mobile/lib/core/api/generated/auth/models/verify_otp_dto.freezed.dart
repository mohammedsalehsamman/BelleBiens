// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_otp_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VerifyOtpDto {


/// Create a copy of VerifyOtpDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpDtoCopyWith<VerifyOtpDto> get copyWith => _$VerifyOtpDtoCopyWithImpl<VerifyOtpDto>(this as VerifyOtpDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VerifyOtpDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtpDto&&(identical(other.acceptTerms, _this.acceptTerms) || other.acceptTerms == _this.acceptTerms)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.homeArea, _this.homeArea) || other.homeArea == _this.homeArea)&&(identical(other.marketingOptIn, _this.marketingOptIn) || other.marketingOptIn == _this.marketingOptIn)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as VerifyOtpDto;
  return Object.hash(runtimeType,_this.acceptTerms,_this.code,_this.email,_this.homeArea,_this.marketingOptIn,_this.name,_this.phone,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as VerifyOtpDto;
  return 'VerifyOtpDto(acceptTerms: ${_this.acceptTerms}, code: ${_this.code}, email: ${_this.email}, homeArea: ${_this.homeArea}, marketingOptIn: ${_this.marketingOptIn}, name: ${_this.name}, phone: ${_this.phone}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $VerifyOtpDtoCopyWith<$Res>  {
  factory $VerifyOtpDtoCopyWith(VerifyOtpDto value, $Res Function(VerifyOtpDto) _then) = _$VerifyOtpDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) bool? acceptTerms,@JsonKey(required: true, disallowNullValue: true) String code,@JsonKey(disallowNullValue: true, includeIfNull: false) String? email,@JsonKey(disallowNullValue: true, includeIfNull: false) String? homeArea,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? marketingOptIn,@JsonKey(disallowNullValue: true, includeIfNull: false) String? name,@JsonKey(required: true, disallowNullValue: true) String phone,@JsonKey(readValue: VerifyOtpDto._extras, fromJson: VerifyOtpDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$VerifyOtpDtoCopyWithImpl<$Res>
    implements $VerifyOtpDtoCopyWith<$Res> {
  _$VerifyOtpDtoCopyWithImpl(this._self, this._then);

  final VerifyOtpDto _self;
  final $Res Function(VerifyOtpDto) _then;

/// Create a copy of VerifyOtpDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? acceptTerms = freezed,Object? code = null,Object? email = freezed,Object? homeArea = freezed,Object? marketingOptIn = freezed,Object? name = freezed,Object? phone = null,Object? additionalProperties = null,}) {
  return _then(VerifyOtpDto(
acceptTerms: freezed == acceptTerms ? _self.acceptTerms : acceptTerms // ignore: cast_nullable_to_non_nullable
as bool?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,homeArea: freezed == homeArea ? _self.homeArea : homeArea // ignore: cast_nullable_to_non_nullable
as String?,marketingOptIn: freezed == marketingOptIn ? _self.marketingOptIn : marketingOptIn // ignore: cast_nullable_to_non_nullable
as bool?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [VerifyOtpDto].
extension VerifyOtpDtoPatterns on VerifyOtpDto {
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
