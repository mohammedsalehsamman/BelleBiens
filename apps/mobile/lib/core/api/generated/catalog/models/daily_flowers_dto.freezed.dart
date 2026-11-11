// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_flowers_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyFlowersDto {


/// Create a copy of DailyFlowersDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyFlowersDtoCopyWith<DailyFlowersDto> get copyWith => _$DailyFlowersDtoCopyWithImpl<DailyFlowersDto>(this as DailyFlowersDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailyFlowersDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyFlowersDto&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&const DeepCollectionEquality().equals(other.products, _this.products)&&const DeepCollectionEquality().equals(other.stems, _this.stems)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as DailyFlowersDto;
  return Object.hash(runtimeType,_this.date,_this.expiresAt,const DeepCollectionEquality().hash(_this.products),const DeepCollectionEquality().hash(_this.stems),const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as DailyFlowersDto;
  return 'DailyFlowersDto(date: ${_this.date}, expiresAt: ${_this.expiresAt}, products: ${_this.products}, stems: ${_this.stems}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $DailyFlowersDtoCopyWith<$Res>  {
  factory $DailyFlowersDtoCopyWith(DailyFlowersDto value, $Res Function(DailyFlowersDto) _then) = _$DailyFlowersDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String date,@JsonKey(required: true, disallowNullValue: true) String expiresAt,@JsonKey(required: true, disallowNullValue: true) List<ProductCardDto> products,@JsonKey(required: true, disallowNullValue: true) List<DailyStemDto> stems,@JsonKey(readValue: DailyFlowersDto._extras, fromJson: DailyFlowersDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$DailyFlowersDtoCopyWithImpl<$Res>
    implements $DailyFlowersDtoCopyWith<$Res> {
  _$DailyFlowersDtoCopyWithImpl(this._self, this._then);

  final DailyFlowersDto _self;
  final $Res Function(DailyFlowersDto) _then;

/// Create a copy of DailyFlowersDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? expiresAt = null,Object? products = null,Object? stems = null,Object? additionalProperties = null,}) {
  return _then(DailyFlowersDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>,stems: null == stems ? _self.stems : stems // ignore: cast_nullable_to_non_nullable
as List<DailyStemDto>,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyFlowersDto].
extension DailyFlowersDtoPatterns on DailyFlowersDto {
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
