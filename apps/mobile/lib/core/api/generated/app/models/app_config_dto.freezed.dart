// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppConfigDto {


/// Create a copy of AppConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigDtoCopyWith<AppConfigDto> get copyWith => _$AppConfigDtoCopyWithImpl<AppConfigDto>(this as AppConfigDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppConfigDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfigDto&&(identical(other.auth, _this.auth) || other.auth == _this.auth)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.features, _this.features) || other.features == _this.features)&&(identical(other.minSupportedVersion, _this.minSupportedVersion) || other.minSupportedVersion == _this.minSupportedVersion)&&(identical(other.payments, _this.payments) || other.payments == _this.payments)&&(identical(other.shop, _this.shop) || other.shop == _this.shop)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as AppConfigDto;
  return Object.hash(runtimeType,_this.auth,_this.currency,_this.features,_this.minSupportedVersion,_this.payments,_this.shop,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as AppConfigDto;
  return 'AppConfigDto(auth: ${_this.auth}, currency: ${_this.currency}, features: ${_this.features}, minSupportedVersion: ${_this.minSupportedVersion}, payments: ${_this.payments}, shop: ${_this.shop}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $AppConfigDtoCopyWith<$Res>  {
  factory $AppConfigDtoCopyWith(AppConfigDto value, $Res Function(AppConfigDto) _then) = _$AppConfigDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) AuthConfigDto auth,@JsonKey(required: true, disallowNullValue: true) CurrencyConfigDto currency,@JsonKey(required: true, disallowNullValue: true) FeaturesConfigDto features,@JsonKey(required: true, disallowNullValue: true) String minSupportedVersion,@JsonKey(required: true, disallowNullValue: true) PaymentsConfigDto payments,@JsonKey(required: true, disallowNullValue: true) ShopConfigDto shop,@JsonKey(readValue: AppConfigDto._extras, fromJson: AppConfigDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$AuthConfigDtoCopyWith<$Res> get auth;$CurrencyConfigDtoCopyWith<$Res> get currency;$FeaturesConfigDtoCopyWith<$Res> get features;$PaymentsConfigDtoCopyWith<$Res> get payments;$ShopConfigDtoCopyWith<$Res> get shop;

}
/// @nodoc
class _$AppConfigDtoCopyWithImpl<$Res>
    implements $AppConfigDtoCopyWith<$Res> {
  _$AppConfigDtoCopyWithImpl(this._self, this._then);

  final AppConfigDto _self;
  final $Res Function(AppConfigDto) _then;

/// Create a copy of AppConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? auth = null,Object? currency = null,Object? features = null,Object? minSupportedVersion = null,Object? payments = null,Object? shop = null,Object? additionalProperties = null,}) {
  return _then(AppConfigDto(
auth: null == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as AuthConfigDto,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as CurrencyConfigDto,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as FeaturesConfigDto,minSupportedVersion: null == minSupportedVersion ? _self.minSupportedVersion : minSupportedVersion // ignore: cast_nullable_to_non_nullable
as String,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as PaymentsConfigDto,shop: null == shop ? _self.shop : shop // ignore: cast_nullable_to_non_nullable
as ShopConfigDto,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of AppConfigDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthConfigDtoCopyWith<$Res> get auth {
  
  return $AuthConfigDtoCopyWith<$Res>(_self.auth, (value) {
    return _then(_self.copyWith(auth: value));
  });
}/// Create a copy of AppConfigDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrencyConfigDtoCopyWith<$Res> get currency {
  
  return $CurrencyConfigDtoCopyWith<$Res>(_self.currency, (value) {
    return _then(_self.copyWith(currency: value));
  });
}/// Create a copy of AppConfigDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeaturesConfigDtoCopyWith<$Res> get features {
  
  return $FeaturesConfigDtoCopyWith<$Res>(_self.features, (value) {
    return _then(_self.copyWith(features: value));
  });
}/// Create a copy of AppConfigDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentsConfigDtoCopyWith<$Res> get payments {
  
  return $PaymentsConfigDtoCopyWith<$Res>(_self.payments, (value) {
    return _then(_self.copyWith(payments: value));
  });
}/// Create a copy of AppConfigDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShopConfigDtoCopyWith<$Res> get shop {
  
  return $ShopConfigDtoCopyWith<$Res>(_self.shop, (value) {
    return _then(_self.copyWith(shop: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppConfigDto].
extension AppConfigDtoPatterns on AppConfigDto {
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
