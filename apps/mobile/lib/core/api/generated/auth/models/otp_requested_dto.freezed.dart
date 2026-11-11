// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_requested_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpRequestedDto {


/// Create a copy of OtpRequestedDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpRequestedDtoCopyWith<OtpRequestedDto> get copyWith => _$OtpRequestedDtoCopyWithImpl<OtpRequestedDto>(this as OtpRequestedDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OtpRequestedDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpRequestedDto&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.codeLength, _this.codeLength) || other.codeLength == _this.codeLength)&&(identical(other.expiresInSeconds, _this.expiresInSeconds) || other.expiresInSeconds == _this.expiresInSeconds)&&(identical(other.maskedPhone, _this.maskedPhone) || other.maskedPhone == _this.maskedPhone)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.resendAfterSeconds, _this.resendAfterSeconds) || other.resendAfterSeconds == _this.resendAfterSeconds)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as OtpRequestedDto;
  return Object.hash(runtimeType,_this.channel,_this.codeLength,_this.expiresInSeconds,_this.maskedPhone,_this.phone,_this.resendAfterSeconds,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as OtpRequestedDto;
  return 'OtpRequestedDto(channel: ${_this.channel}, codeLength: ${_this.codeLength}, expiresInSeconds: ${_this.expiresInSeconds}, maskedPhone: ${_this.maskedPhone}, phone: ${_this.phone}, resendAfterSeconds: ${_this.resendAfterSeconds}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $OtpRequestedDtoCopyWith<$Res>  {
  factory $OtpRequestedDtoCopyWith(OtpRequestedDto value, $Res Function(OtpRequestedDto) _then) = _$OtpRequestedDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: OtpRequestedDto._read_channel, toJson: OtpRequestedDto._write_channel) OtpRequestedDtoChannel channel,@JsonKey(required: true, disallowNullValue: true) num codeLength,@JsonKey(required: true, disallowNullValue: true) num expiresInSeconds,@JsonKey(required: true, disallowNullValue: true) String maskedPhone,@JsonKey(required: true, disallowNullValue: true) String phone,@JsonKey(required: true, disallowNullValue: true) num resendAfterSeconds,@JsonKey(readValue: OtpRequestedDto._extras, fromJson: OtpRequestedDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$OtpRequestedDtoCopyWithImpl<$Res>
    implements $OtpRequestedDtoCopyWith<$Res> {
  _$OtpRequestedDtoCopyWithImpl(this._self, this._then);

  final OtpRequestedDto _self;
  final $Res Function(OtpRequestedDto) _then;

/// Create a copy of OtpRequestedDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channel = null,Object? codeLength = null,Object? expiresInSeconds = null,Object? maskedPhone = null,Object? phone = null,Object? resendAfterSeconds = null,Object? additionalProperties = null,}) {
  return _then(OtpRequestedDto(
channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as OtpRequestedDtoChannel,codeLength: null == codeLength ? _self.codeLength : codeLength // ignore: cast_nullable_to_non_nullable
as num,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as num,maskedPhone: null == maskedPhone ? _self.maskedPhone : maskedPhone // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,resendAfterSeconds: null == resendAfterSeconds ? _self.resendAfterSeconds : resendAfterSeconds // ignore: cast_nullable_to_non_nullable
as num,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpRequestedDto].
extension OtpRequestedDtoPatterns on OtpRequestedDto {
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
