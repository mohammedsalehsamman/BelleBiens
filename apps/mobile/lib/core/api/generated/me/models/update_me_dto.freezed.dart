// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_me_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateMeDto {


/// Create a copy of UpdateMeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateMeDtoCopyWith<UpdateMeDto> get copyWith => _$UpdateMeDtoCopyWithImpl<UpdateMeDto>(this as UpdateMeDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UpdateMeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateMeDto&&(identical(other.acceptTerms, _this.acceptTerms) || other.acceptTerms == _this.acceptTerms)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.homeArea, _this.homeArea) || other.homeArea == _this.homeArea)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.marketingOptIn, _this.marketingOptIn) || other.marketingOptIn == _this.marketingOptIn)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.notifyOccasions, _this.notifyOccasions) || other.notifyOccasions == _this.notifyOccasions)&&(identical(other.notifyWhatsapp, _this.notifyWhatsapp) || other.notifyWhatsapp == _this.notifyWhatsapp)&&(identical(other.numerals, _this.numerals) || other.numerals == _this.numerals)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as UpdateMeDto;
  return Object.hash(runtimeType,_this.acceptTerms,_this.email,_this.homeArea,_this.language,_this.marketingOptIn,_this.name,_this.notifyOccasions,_this.notifyWhatsapp,_this.numerals,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as UpdateMeDto;
  return 'UpdateMeDto(acceptTerms: ${_this.acceptTerms}, email: ${_this.email}, homeArea: ${_this.homeArea}, language: ${_this.language}, marketingOptIn: ${_this.marketingOptIn}, name: ${_this.name}, notifyOccasions: ${_this.notifyOccasions}, notifyWhatsapp: ${_this.notifyWhatsapp}, numerals: ${_this.numerals}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $UpdateMeDtoCopyWith<$Res>  {
  factory $UpdateMeDtoCopyWith(UpdateMeDto value, $Res Function(UpdateMeDto) _then) = _$UpdateMeDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) bool? acceptTerms,@JsonKey(disallowNullValue: true, includeIfNull: false) String? email,@JsonKey(disallowNullValue: true, includeIfNull: false) String? homeArea,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: UpdateMeDto._read_language, toJson: UpdateMeDto._write_language) UpdateMeDtoLanguage? language,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? marketingOptIn,@JsonKey(disallowNullValue: true, includeIfNull: false) String? name,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? notifyOccasions,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? notifyWhatsapp,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: UpdateMeDto._read_numerals, toJson: UpdateMeDto._write_numerals) UpdateMeDtoNumerals? numerals,@JsonKey(readValue: UpdateMeDto._extras, fromJson: UpdateMeDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$UpdateMeDtoCopyWithImpl<$Res>
    implements $UpdateMeDtoCopyWith<$Res> {
  _$UpdateMeDtoCopyWithImpl(this._self, this._then);

  final UpdateMeDto _self;
  final $Res Function(UpdateMeDto) _then;

/// Create a copy of UpdateMeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? acceptTerms = freezed,Object? email = freezed,Object? homeArea = freezed,Object? language = freezed,Object? marketingOptIn = freezed,Object? name = freezed,Object? notifyOccasions = freezed,Object? notifyWhatsapp = freezed,Object? numerals = freezed,Object? additionalProperties = null,}) {
  return _then(UpdateMeDto(
acceptTerms: freezed == acceptTerms ? _self.acceptTerms : acceptTerms // ignore: cast_nullable_to_non_nullable
as bool?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,homeArea: freezed == homeArea ? _self.homeArea : homeArea // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as UpdateMeDtoLanguage?,marketingOptIn: freezed == marketingOptIn ? _self.marketingOptIn : marketingOptIn // ignore: cast_nullable_to_non_nullable
as bool?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,notifyOccasions: freezed == notifyOccasions ? _self.notifyOccasions : notifyOccasions // ignore: cast_nullable_to_non_nullable
as bool?,notifyWhatsapp: freezed == notifyWhatsapp ? _self.notifyWhatsapp : notifyWhatsapp // ignore: cast_nullable_to_non_nullable
as bool?,numerals: freezed == numerals ? _self.numerals : numerals // ignore: cast_nullable_to_non_nullable
as UpdateMeDtoNumerals?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateMeDto].
extension UpdateMeDtoPatterns on UpdateMeDto {
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
