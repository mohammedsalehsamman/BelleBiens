// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddressInputDto {


/// Create a copy of AddressInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressInputDtoCopyWith<AddressInputDto> get copyWith => _$AddressInputDtoCopyWithImpl<AddressInputDto>(this as AddressInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AddressInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressInputDto&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.building, _this.building) || other.building == _this.building)&&(identical(other.callBeforeArrival, _this.callBeforeArrival) || other.callBeforeArrival == _this.callBeforeArrival)&&(identical(other.details, _this.details) || other.details == _this.details)&&(identical(other.floor, _this.floor) || other.floor == _this.floor)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.landmark, _this.landmark) || other.landmark == _this.landmark)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as AddressInputDto;
  return Object.hash(runtimeType,_this.area,_this.building,_this.callBeforeArrival,_this.details,_this.floor,_this.isDefault,_this.label,_this.landmark,_this.latitude,_this.longitude,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as AddressInputDto;
  return 'AddressInputDto(area: ${_this.area}, building: ${_this.building}, callBeforeArrival: ${_this.callBeforeArrival}, details: ${_this.details}, floor: ${_this.floor}, isDefault: ${_this.isDefault}, label: ${_this.label}, landmark: ${_this.landmark}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $AddressInputDtoCopyWith<$Res>  {
  factory $AddressInputDtoCopyWith(AddressInputDto value, $Res Function(AddressInputDto) _then) = _$AddressInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) String? area,@JsonKey(disallowNullValue: true, includeIfNull: false) String? building,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? callBeforeArrival,@JsonKey(disallowNullValue: true, includeIfNull: false) String? details,@JsonKey(disallowNullValue: true, includeIfNull: false) String? floor,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? isDefault,@JsonKey(required: true, disallowNullValue: true) String label,@JsonKey(disallowNullValue: true, includeIfNull: false) String? landmark,@JsonKey(required: true, disallowNullValue: true) num latitude,@JsonKey(required: true, disallowNullValue: true) num longitude,@JsonKey(readValue: AddressInputDto._extras, fromJson: AddressInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$AddressInputDtoCopyWithImpl<$Res>
    implements $AddressInputDtoCopyWith<$Res> {
  _$AddressInputDtoCopyWithImpl(this._self, this._then);

  final AddressInputDto _self;
  final $Res Function(AddressInputDto) _then;

/// Create a copy of AddressInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? area = freezed,Object? building = freezed,Object? callBeforeArrival = freezed,Object? details = freezed,Object? floor = freezed,Object? isDefault = freezed,Object? label = null,Object? landmark = freezed,Object? latitude = null,Object? longitude = null,Object? additionalProperties = null,}) {
  return _then(AddressInputDto(
area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,callBeforeArrival: freezed == callBeforeArrival ? _self.callBeforeArrival : callBeforeArrival // ignore: cast_nullable_to_non_nullable
as bool?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,landmark: freezed == landmark ? _self.landmark : landmark // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressInputDto].
extension AddressInputDtoPatterns on AddressInputDto {
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
