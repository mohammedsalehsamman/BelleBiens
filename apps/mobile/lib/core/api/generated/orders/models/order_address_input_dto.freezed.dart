// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_address_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderAddressInputDto {


/// Create a copy of OrderAddressInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderAddressInputDtoCopyWith<OrderAddressInputDto> get copyWith => _$OrderAddressInputDtoCopyWithImpl<OrderAddressInputDto>(this as OrderAddressInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderAddressInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderAddressInputDto&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.building, _this.building) || other.building == _this.building)&&(identical(other.details, _this.details) || other.details == _this.details)&&(identical(other.floor, _this.floor) || other.floor == _this.floor)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.landmark, _this.landmark) || other.landmark == _this.landmark)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.save, _this.save) || other.save == _this.save)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as OrderAddressInputDto;
  return Object.hash(runtimeType,_this.area,_this.building,_this.details,_this.floor,_this.label,_this.landmark,_this.latitude,_this.longitude,_this.save,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as OrderAddressInputDto;
  return 'OrderAddressInputDto(area: ${_this.area}, building: ${_this.building}, details: ${_this.details}, floor: ${_this.floor}, label: ${_this.label}, landmark: ${_this.landmark}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, save: ${_this.save}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $OrderAddressInputDtoCopyWith<$Res>  {
  factory $OrderAddressInputDtoCopyWith(OrderAddressInputDto value, $Res Function(OrderAddressInputDto) _then) = _$OrderAddressInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) String? area,@JsonKey(disallowNullValue: true, includeIfNull: false) String? building,@JsonKey(disallowNullValue: true, includeIfNull: false) String? details,@JsonKey(disallowNullValue: true, includeIfNull: false) String? floor,@JsonKey(disallowNullValue: true, includeIfNull: false) String? label,@JsonKey(disallowNullValue: true, includeIfNull: false) String? landmark,@JsonKey(required: true, disallowNullValue: true) num latitude,@JsonKey(required: true, disallowNullValue: true) num longitude,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? save,@JsonKey(readValue: OrderAddressInputDto._extras, fromJson: OrderAddressInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$OrderAddressInputDtoCopyWithImpl<$Res>
    implements $OrderAddressInputDtoCopyWith<$Res> {
  _$OrderAddressInputDtoCopyWithImpl(this._self, this._then);

  final OrderAddressInputDto _self;
  final $Res Function(OrderAddressInputDto) _then;

/// Create a copy of OrderAddressInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? area = freezed,Object? building = freezed,Object? details = freezed,Object? floor = freezed,Object? label = freezed,Object? landmark = freezed,Object? latitude = null,Object? longitude = null,Object? save = freezed,Object? additionalProperties = null,}) {
  return _then(OrderAddressInputDto(
area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,landmark: freezed == landmark ? _self.landmark : landmark // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num,save: freezed == save ? _self.save : save // ignore: cast_nullable_to_non_nullable
as bool?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderAddressInputDto].
extension OrderAddressInputDtoPatterns on OrderAddressInputDto {
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
