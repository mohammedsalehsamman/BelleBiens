// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_sign_in_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoogleSignInDto {


/// Create a copy of GoogleSignInDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoogleSignInDtoCopyWith<GoogleSignInDto> get copyWith => _$GoogleSignInDtoCopyWithImpl<GoogleSignInDto>(this as GoogleSignInDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GoogleSignInDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoogleSignInDto&&(identical(other.acceptTerms, _this.acceptTerms) || other.acceptTerms == _this.acceptTerms)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.homeArea, _this.homeArea) || other.homeArea == _this.homeArea)&&(identical(other.idToken, _this.idToken) || other.idToken == _this.idToken)&&(identical(other.marketingOptIn, _this.marketingOptIn) || other.marketingOptIn == _this.marketingOptIn)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as GoogleSignInDto;
  return Object.hash(runtimeType,_this.acceptTerms,_this.email,_this.homeArea,_this.idToken,_this.marketingOptIn,_this.name,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as GoogleSignInDto;
  return 'GoogleSignInDto(acceptTerms: ${_this.acceptTerms}, email: ${_this.email}, homeArea: ${_this.homeArea}, idToken: ${_this.idToken}, marketingOptIn: ${_this.marketingOptIn}, name: ${_this.name}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $GoogleSignInDtoCopyWith<$Res>  {
  factory $GoogleSignInDtoCopyWith(GoogleSignInDto value, $Res Function(GoogleSignInDto) _then) = _$GoogleSignInDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) bool? acceptTerms,@JsonKey(disallowNullValue: true, includeIfNull: false) String? email,@JsonKey(disallowNullValue: true, includeIfNull: false) String? homeArea,@JsonKey(required: true, disallowNullValue: true) String idToken,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? marketingOptIn,@JsonKey(disallowNullValue: true, includeIfNull: false) String? name,@JsonKey(readValue: GoogleSignInDto._extras, fromJson: GoogleSignInDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$GoogleSignInDtoCopyWithImpl<$Res>
    implements $GoogleSignInDtoCopyWith<$Res> {
  _$GoogleSignInDtoCopyWithImpl(this._self, this._then);

  final GoogleSignInDto _self;
  final $Res Function(GoogleSignInDto) _then;

/// Create a copy of GoogleSignInDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? acceptTerms = freezed,Object? email = freezed,Object? homeArea = freezed,Object? idToken = null,Object? marketingOptIn = freezed,Object? name = freezed,Object? additionalProperties = null,}) {
  return _then(GoogleSignInDto(
acceptTerms: freezed == acceptTerms ? _self.acceptTerms : acceptTerms // ignore: cast_nullable_to_non_nullable
as bool?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,homeArea: freezed == homeArea ? _self.homeArea : homeArea // ignore: cast_nullable_to_non_nullable
as String?,idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,marketingOptIn: freezed == marketingOptIn ? _self.marketingOptIn : marketingOptIn // ignore: cast_nullable_to_non_nullable
as bool?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [GoogleSignInDto].
extension GoogleSignInDtoPatterns on GoogleSignInDto {
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
