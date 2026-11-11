// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BranchDto {


/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchDtoCopyWith<BranchDto> get copyWith => _$BranchDtoCopyWithImpl<BranchDto>(this as BranchDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BranchDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchDto&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.instagram, _this.instagram) || other.instagram == _this.instagram)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.pages, _this.pages)&&const DeepCollectionEquality().equals(other.partners, _this.partners)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.whatsapp, _this.whatsapp) || other.whatsapp == _this.whatsapp)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as BranchDto;
  return Object.hash(runtimeType,_this.address,_this.code,_this.instagram,_this.latitude,_this.longitude,_this.name,const DeepCollectionEquality().hash(_this.pages),const DeepCollectionEquality().hash(_this.partners),_this.phone,_this.status,_this.whatsapp,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as BranchDto;
  return 'BranchDto(address: ${_this.address}, code: ${_this.code}, instagram: ${_this.instagram}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, name: ${_this.name}, pages: ${_this.pages}, partners: ${_this.partners}, phone: ${_this.phone}, status: ${_this.status}, whatsapp: ${_this.whatsapp}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $BranchDtoCopyWith<$Res>  {
  factory $BranchDtoCopyWith(BranchDto value, $Res Function(BranchDto) _then) = _$BranchDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto address,@JsonKey(required: true, disallowNullValue: true) String code,@JsonKey(required: true) String? instagram,@JsonKey(required: true) num? latitude,@JsonKey(required: true) num? longitude,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto name,@JsonKey(required: true, disallowNullValue: true) List<PageLinkDto> pages,@JsonKey(required: true, disallowNullValue: true) List<String> partners,@JsonKey(required: true) String? phone,@JsonKey(required: true, disallowNullValue: true) ShopStatusDto status,@JsonKey(required: true) String? whatsapp,@JsonKey(readValue: BranchDto._extras, fromJson: BranchDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$LocalizedTextDtoCopyWith<$Res> get address;$LocalizedTextDtoCopyWith<$Res> get name;$ShopStatusDtoCopyWith<$Res> get status;

}
/// @nodoc
class _$BranchDtoCopyWithImpl<$Res>
    implements $BranchDtoCopyWith<$Res> {
  _$BranchDtoCopyWithImpl(this._self, this._then);

  final BranchDto _self;
  final $Res Function(BranchDto) _then;

/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = null,Object? code = null,Object? instagram = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? name = null,Object? pages = null,Object? partners = null,Object? phone = freezed,Object? status = null,Object? whatsapp = freezed,Object? additionalProperties = null,}) {
  return _then(BranchDto(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,instagram: freezed == instagram ? _self.instagram : instagram // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as num?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as num?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<PageLinkDto>,partners: null == partners ? _self.partners : partners // ignore: cast_nullable_to_non_nullable
as List<String>,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShopStatusDto,whatsapp: freezed == whatsapp ? _self.whatsapp : whatsapp // ignore: cast_nullable_to_non_nullable
as String?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get address {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get name {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShopStatusDtoCopyWith<$Res> get status {
  
  return $ShopStatusDtoCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [BranchDto].
extension BranchDtoPatterns on BranchDto {
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
