// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_zone_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminZoneDto {


/// Create a copy of AdminZoneDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminZoneDtoCopyWith<AdminZoneDto> get copyWith => _$AdminZoneDtoCopyWithImpl<AdminZoneDto>(this as AdminZoneDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdminZoneDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminZoneDto&&(identical(other.active, _this.active) || other.active == _this.active)&&(identical(other.eta, _this.eta) || other.eta == _this.eta)&&(identical(other.feeMinor, _this.feeMinor) || other.feeMinor == _this.feeMinor)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.polygon, _this.polygon)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as AdminZoneDto;
  return Object.hash(runtimeType,_this.active,_this.eta,_this.feeMinor,_this.id,_this.name,const DeepCollectionEquality().hash(_this.polygon),_this.slug,_this.sortOrder,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as AdminZoneDto;
  return 'AdminZoneDto(active: ${_this.active}, eta: ${_this.eta}, feeMinor: ${_this.feeMinor}, id: ${_this.id}, name: ${_this.name}, polygon: ${_this.polygon}, slug: ${_this.slug}, sortOrder: ${_this.sortOrder}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $AdminZoneDtoCopyWith<$Res>  {
  factory $AdminZoneDtoCopyWith(AdminZoneDto value, $Res Function(AdminZoneDto) _then) = _$AdminZoneDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) bool active,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto eta,@JsonKey(required: true, disallowNullValue: true, fromJson: AdminZoneDto._read_feeMinor, toJson: AdminZoneDto._write_feeMinor) int feeMinor,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto name,@JsonKey(required: true, disallowNullValue: true) List<List<num>> polygon,@JsonKey(required: true, disallowNullValue: true) String slug,@JsonKey(required: true, disallowNullValue: true, fromJson: AdminZoneDto._read_sortOrder, toJson: AdminZoneDto._write_sortOrder) int sortOrder,@JsonKey(readValue: AdminZoneDto._extras, fromJson: AdminZoneDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$LocalizedTextDtoCopyWith<$Res> get eta;$LocalizedTextDtoCopyWith<$Res> get name;

}
/// @nodoc
class _$AdminZoneDtoCopyWithImpl<$Res>
    implements $AdminZoneDtoCopyWith<$Res> {
  _$AdminZoneDtoCopyWithImpl(this._self, this._then);

  final AdminZoneDto _self;
  final $Res Function(AdminZoneDto) _then;

/// Create a copy of AdminZoneDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? active = null,Object? eta = null,Object? feeMinor = null,Object? id = null,Object? name = null,Object? polygon = null,Object? slug = null,Object? sortOrder = null,Object? additionalProperties = null,}) {
  return _then(AdminZoneDto(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,eta: null == eta ? _self.eta : eta // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,feeMinor: null == feeMinor ? _self.feeMinor : feeMinor // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,polygon: null == polygon ? _self.polygon : polygon // ignore: cast_nullable_to_non_nullable
as List<List<num>>,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of AdminZoneDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get eta {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.eta, (value) {
    return _then(_self.copyWith(eta: value));
  });
}/// Create a copy of AdminZoneDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get name {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminZoneDto].
extension AdminZoneDtoPatterns on AdminZoneDto {
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
