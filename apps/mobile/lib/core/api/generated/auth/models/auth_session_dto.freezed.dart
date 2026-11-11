// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthSessionDto {


/// Create a copy of AuthSessionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionDtoCopyWith<AuthSessionDto> get copyWith => _$AuthSessionDtoCopyWithImpl<AuthSessionDto>(this as AuthSessionDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AuthSessionDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionDto&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.accessTokenExpiresIn, _this.accessTokenExpiresIn) || other.accessTokenExpiresIn == _this.accessTokenExpiresIn)&&(identical(other.isNewUser, _this.isNewUser) || other.isNewUser == _this.isNewUser)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.refreshTokenExpiresAt, _this.refreshTokenExpiresAt) || other.refreshTokenExpiresAt == _this.refreshTokenExpiresAt)&&(identical(other.user, _this.user) || other.user == _this.user)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as AuthSessionDto;
  return Object.hash(runtimeType,_this.accessToken,_this.accessTokenExpiresIn,_this.isNewUser,_this.refreshToken,_this.refreshTokenExpiresAt,_this.user,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as AuthSessionDto;
  return 'AuthSessionDto(accessToken: ${_this.accessToken}, accessTokenExpiresIn: ${_this.accessTokenExpiresIn}, isNewUser: ${_this.isNewUser}, refreshToken: ${_this.refreshToken}, refreshTokenExpiresAt: ${_this.refreshTokenExpiresAt}, user: ${_this.user}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $AuthSessionDtoCopyWith<$Res>  {
  factory $AuthSessionDtoCopyWith(AuthSessionDto value, $Res Function(AuthSessionDto) _then) = _$AuthSessionDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String accessToken,@JsonKey(required: true, disallowNullValue: true) num accessTokenExpiresIn,@JsonKey(required: true, disallowNullValue: true) bool isNewUser,@JsonKey(required: true, disallowNullValue: true) String refreshToken,@JsonKey(required: true, disallowNullValue: true, fromJson: AuthSessionDto._read_refreshTokenExpiresAt, toJson: AuthSessionDto._write_refreshTokenExpiresAt) DateTime refreshTokenExpiresAt,@JsonKey(required: true, disallowNullValue: true) MeDto user,@JsonKey(readValue: AuthSessionDto._extras, fromJson: AuthSessionDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$MeDtoCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthSessionDtoCopyWithImpl<$Res>
    implements $AuthSessionDtoCopyWith<$Res> {
  _$AuthSessionDtoCopyWithImpl(this._self, this._then);

  final AuthSessionDto _self;
  final $Res Function(AuthSessionDto) _then;

/// Create a copy of AuthSessionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? accessTokenExpiresIn = null,Object? isNewUser = null,Object? refreshToken = null,Object? refreshTokenExpiresAt = null,Object? user = null,Object? additionalProperties = null,}) {
  return _then(AuthSessionDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,accessTokenExpiresIn: null == accessTokenExpiresIn ? _self.accessTokenExpiresIn : accessTokenExpiresIn // ignore: cast_nullable_to_non_nullable
as num,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,refreshTokenExpiresAt: null == refreshTokenExpiresAt ? _self.refreshTokenExpiresAt : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MeDto,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of AuthSessionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeDtoCopyWith<$Res> get user {
  
  return $MeDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthSessionDto].
extension AuthSessionDtoPatterns on AuthSessionDto {
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
