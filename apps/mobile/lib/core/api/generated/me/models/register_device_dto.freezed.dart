// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_device_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterDeviceDto {


/// Create a copy of RegisterDeviceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterDeviceDtoCopyWith<RegisterDeviceDto> get copyWith => _$RegisterDeviceDtoCopyWithImpl<RegisterDeviceDto>(this as RegisterDeviceDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RegisterDeviceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterDeviceDto&&(identical(other.appVersion, _this.appVersion) || other.appVersion == _this.appVersion)&&(identical(other.locale, _this.locale) || other.locale == _this.locale)&&(identical(other.platform, _this.platform) || other.platform == _this.platform)&&(identical(other.pushToken, _this.pushToken) || other.pushToken == _this.pushToken)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as RegisterDeviceDto;
  return Object.hash(runtimeType,_this.appVersion,_this.locale,_this.platform,_this.pushToken,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as RegisterDeviceDto;
  return 'RegisterDeviceDto(appVersion: ${_this.appVersion}, locale: ${_this.locale}, platform: ${_this.platform}, pushToken: ${_this.pushToken}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $RegisterDeviceDtoCopyWith<$Res>  {
  factory $RegisterDeviceDtoCopyWith(RegisterDeviceDto value, $Res Function(RegisterDeviceDto) _then) = _$RegisterDeviceDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) String? appVersion,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: RegisterDeviceDto._read_locale, toJson: RegisterDeviceDto._write_locale) RegisterDeviceDtoLocale? locale,@JsonKey(required: true, disallowNullValue: true, fromJson: RegisterDeviceDto._read_platform, toJson: RegisterDeviceDto._write_platform) RegisterDeviceDtoPlatform platform,@JsonKey(required: true, disallowNullValue: true) String pushToken,@JsonKey(readValue: RegisterDeviceDto._extras, fromJson: RegisterDeviceDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$RegisterDeviceDtoCopyWithImpl<$Res>
    implements $RegisterDeviceDtoCopyWith<$Res> {
  _$RegisterDeviceDtoCopyWithImpl(this._self, this._then);

  final RegisterDeviceDto _self;
  final $Res Function(RegisterDeviceDto) _then;

/// Create a copy of RegisterDeviceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appVersion = freezed,Object? locale = freezed,Object? platform = null,Object? pushToken = null,Object? additionalProperties = null,}) {
  return _then(RegisterDeviceDto(
appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as RegisterDeviceDtoLocale?,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as RegisterDeviceDtoPlatform,pushToken: null == pushToken ? _self.pushToken : pushToken // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterDeviceDto].
extension RegisterDeviceDtoPatterns on RegisterDeviceDto {
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
