// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_config_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShopConfigDto {


/// Create a copy of ShopConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopConfigDtoCopyWith<ShopConfigDto> get copyWith => _$ShopConfigDtoCopyWithImpl<ShopConfigDto>(this as ShopConfigDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShopConfigDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopConfigDto&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.timeZone, _this.timeZone) || other.timeZone == _this.timeZone)&&(identical(other.whatsapp, _this.whatsapp) || other.whatsapp == _this.whatsapp)&&(identical(other.workingHours, _this.workingHours) || other.workingHours == _this.workingHours)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as ShopConfigDto;
  return Object.hash(runtimeType,_this.mode,_this.timeZone,_this.whatsapp,_this.workingHours,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as ShopConfigDto;
  return 'ShopConfigDto(mode: ${_this.mode}, timeZone: ${_this.timeZone}, whatsapp: ${_this.whatsapp}, workingHours: ${_this.workingHours}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $ShopConfigDtoCopyWith<$Res>  {
  factory $ShopConfigDtoCopyWith(ShopConfigDto value, $Res Function(ShopConfigDto) _then) = _$ShopConfigDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: ShopConfigDto._read_mode, toJson: ShopConfigDto._write_mode) ShopConfigDtoMode mode,@JsonKey(required: true, disallowNullValue: true) String timeZone,@JsonKey(required: true) String? whatsapp,@JsonKey(required: true, disallowNullValue: true) WorkingHoursDto workingHours,@JsonKey(readValue: ShopConfigDto._extras, fromJson: ShopConfigDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$WorkingHoursDtoCopyWith<$Res> get workingHours;

}
/// @nodoc
class _$ShopConfigDtoCopyWithImpl<$Res>
    implements $ShopConfigDtoCopyWith<$Res> {
  _$ShopConfigDtoCopyWithImpl(this._self, this._then);

  final ShopConfigDto _self;
  final $Res Function(ShopConfigDto) _then;

/// Create a copy of ShopConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? timeZone = null,Object? whatsapp = freezed,Object? workingHours = null,Object? additionalProperties = null,}) {
  return _then(ShopConfigDto(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ShopConfigDtoMode,timeZone: null == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as String,whatsapp: freezed == whatsapp ? _self.whatsapp : whatsapp // ignore: cast_nullable_to_non_nullable
as String?,workingHours: null == workingHours ? _self.workingHours : workingHours // ignore: cast_nullable_to_non_nullable
as WorkingHoursDto,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of ShopConfigDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkingHoursDtoCopyWith<$Res> get workingHours {
  
  return $WorkingHoursDtoCopyWith<$Res>(_self.workingHours, (value) {
    return _then(_self.copyWith(workingHours: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShopConfigDto].
extension ShopConfigDtoPatterns on ShopConfigDto {
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
