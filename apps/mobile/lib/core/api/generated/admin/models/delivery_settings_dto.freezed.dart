// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_settings_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeliverySettingsDto {


/// Create a copy of DeliverySettingsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliverySettingsDtoCopyWith<DeliverySettingsDto> get copyWith => _$DeliverySettingsDtoCopyWithImpl<DeliverySettingsDto>(this as DeliverySettingsDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeliverySettingsDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliverySettingsDto&&const DeepCollectionEquality().equals(other.closedDays, _this.closedDays)&&(identical(other.slotHoldMinutes, _this.slotHoldMinutes) || other.slotHoldMinutes == _this.slotHoldMinutes)&&const DeepCollectionEquality().equals(other.slots, _this.slots)&&(identical(other.windowDays, _this.windowDays) || other.windowDays == _this.windowDays)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as DeliverySettingsDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.closedDays),_this.slotHoldMinutes,const DeepCollectionEquality().hash(_this.slots),_this.windowDays,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as DeliverySettingsDto;
  return 'DeliverySettingsDto(closedDays: ${_this.closedDays}, slotHoldMinutes: ${_this.slotHoldMinutes}, slots: ${_this.slots}, windowDays: ${_this.windowDays}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $DeliverySettingsDtoCopyWith<$Res>  {
  factory $DeliverySettingsDtoCopyWith(DeliverySettingsDto value, $Res Function(DeliverySettingsDto) _then) = _$DeliverySettingsDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) List<String> closedDays,@JsonKey(required: true, disallowNullValue: true, fromJson: DeliverySettingsDto._read_slotHoldMinutes, toJson: DeliverySettingsDto._write_slotHoldMinutes) int slotHoldMinutes,@JsonKey(required: true, disallowNullValue: true) List<SlotTemplateDto> slots,@JsonKey(required: true, disallowNullValue: true, fromJson: DeliverySettingsDto._read_windowDays, toJson: DeliverySettingsDto._write_windowDays) int windowDays,@JsonKey(readValue: DeliverySettingsDto._extras, fromJson: DeliverySettingsDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$DeliverySettingsDtoCopyWithImpl<$Res>
    implements $DeliverySettingsDtoCopyWith<$Res> {
  _$DeliverySettingsDtoCopyWithImpl(this._self, this._then);

  final DeliverySettingsDto _self;
  final $Res Function(DeliverySettingsDto) _then;

/// Create a copy of DeliverySettingsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? closedDays = null,Object? slotHoldMinutes = null,Object? slots = null,Object? windowDays = null,Object? additionalProperties = null,}) {
  return _then(DeliverySettingsDto(
closedDays: null == closedDays ? _self.closedDays : closedDays // ignore: cast_nullable_to_non_nullable
as List<String>,slotHoldMinutes: null == slotHoldMinutes ? _self.slotHoldMinutes : slotHoldMinutes // ignore: cast_nullable_to_non_nullable
as int,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<SlotTemplateDto>,windowDays: null == windowDays ? _self.windowDays : windowDays // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliverySettingsDto].
extension DeliverySettingsDtoPatterns on DeliverySettingsDto {
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
