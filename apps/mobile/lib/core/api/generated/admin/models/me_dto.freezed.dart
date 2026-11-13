// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeDto {


/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeDtoCopyWith<MeDto> get copyWith => _$MeDtoCopyWithImpl<MeDto>(this as MeDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeDto&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.homeArea, _this.homeArea) || other.homeArea == _this.homeArea)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.marketingOptIn, _this.marketingOptIn) || other.marketingOptIn == _this.marketingOptIn)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.notifyOccasions, _this.notifyOccasions) || other.notifyOccasions == _this.notifyOccasions)&&(identical(other.notifyWhatsapp, _this.notifyWhatsapp) || other.notifyWhatsapp == _this.notifyWhatsapp)&&(identical(other.numerals, _this.numerals) || other.numerals == _this.numerals)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.profileComplete, _this.profileComplete) || other.profileComplete == _this.profileComplete)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.termsAccepted, _this.termsAccepted) || other.termsAccepted == _this.termsAccepted)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as MeDto;
  return Object.hash(runtimeType,_this.createdAt,_this.email,_this.homeArea,_this.id,_this.language,_this.marketingOptIn,_this.name,_this.notifyOccasions,_this.notifyWhatsapp,_this.numerals,_this.phone,_this.profileComplete,_this.role,_this.termsAccepted,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as MeDto;
  return 'MeDto(createdAt: ${_this.createdAt}, email: ${_this.email}, homeArea: ${_this.homeArea}, id: ${_this.id}, language: ${_this.language}, marketingOptIn: ${_this.marketingOptIn}, name: ${_this.name}, notifyOccasions: ${_this.notifyOccasions}, notifyWhatsapp: ${_this.notifyWhatsapp}, numerals: ${_this.numerals}, phone: ${_this.phone}, profileComplete: ${_this.profileComplete}, role: ${_this.role}, termsAccepted: ${_this.termsAccepted}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $MeDtoCopyWith<$Res>  {
  factory $MeDtoCopyWith(MeDto value, $Res Function(MeDto) _then) = _$MeDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: MeDto._read_createdAt, toJson: MeDto._write_createdAt) DateTime createdAt,@JsonKey(required: true) String? email,@JsonKey(required: true) String? homeArea,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true, disallowNullValue: true, fromJson: MeDto._read_language, toJson: MeDto._write_language) MeDtoLanguage language,@JsonKey(required: true, disallowNullValue: true) bool marketingOptIn,@JsonKey(required: true, disallowNullValue: true) String name,@JsonKey(required: true, disallowNullValue: true) bool notifyOccasions,@JsonKey(required: true, disallowNullValue: true) bool notifyWhatsapp,@JsonKey(required: true, disallowNullValue: true, fromJson: MeDto._read_numerals, toJson: MeDto._write_numerals) MeDtoNumerals numerals,@JsonKey(required: true) String? phone,@JsonKey(required: true, disallowNullValue: true) bool profileComplete,@JsonKey(required: true, disallowNullValue: true, fromJson: MeDto._read_role, toJson: MeDto._write_role) MeDtoRole role,@JsonKey(required: true, disallowNullValue: true) bool termsAccepted,@JsonKey(readValue: MeDto._extras, fromJson: MeDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$MeDtoCopyWithImpl<$Res>
    implements $MeDtoCopyWith<$Res> {
  _$MeDtoCopyWithImpl(this._self, this._then);

  final MeDto _self;
  final $Res Function(MeDto) _then;

/// Create a copy of MeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? createdAt = null,Object? email = freezed,Object? homeArea = freezed,Object? id = null,Object? language = null,Object? marketingOptIn = null,Object? name = null,Object? notifyOccasions = null,Object? notifyWhatsapp = null,Object? numerals = null,Object? phone = freezed,Object? profileComplete = null,Object? role = null,Object? termsAccepted = null,Object? additionalProperties = null,}) {
  return _then(MeDto(
createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,homeArea: freezed == homeArea ? _self.homeArea : homeArea // ignore: cast_nullable_to_non_nullable
as String?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as MeDtoLanguage,marketingOptIn: null == marketingOptIn ? _self.marketingOptIn : marketingOptIn // ignore: cast_nullable_to_non_nullable
as bool,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notifyOccasions: null == notifyOccasions ? _self.notifyOccasions : notifyOccasions // ignore: cast_nullable_to_non_nullable
as bool,notifyWhatsapp: null == notifyWhatsapp ? _self.notifyWhatsapp : notifyWhatsapp // ignore: cast_nullable_to_non_nullable
as bool,numerals: null == numerals ? _self.numerals : numerals // ignore: cast_nullable_to_non_nullable
as MeDtoNumerals,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,profileComplete: null == profileComplete ? _self.profileComplete : profileComplete // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MeDtoRole,termsAccepted: null == termsAccepted ? _self.termsAccepted : termsAccepted // ignore: cast_nullable_to_non_nullable
as bool,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [MeDto].
extension MeDtoPatterns on MeDto {
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
