// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_stem_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyStemInputDto {


/// Create a copy of DailyStemInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyStemInputDtoCopyWith<DailyStemInputDto> get copyWith => _$DailyStemInputDtoCopyWithImpl<DailyStemInputDto>(this as DailyStemInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailyStemInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyStemInputDto&&(identical(other.limited, _this.limited) || other.limited == _this.limited)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as DailyStemInputDto;
  return Object.hash(runtimeType,_this.limited,_this.quantity,_this.slug,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as DailyStemInputDto;
  return 'DailyStemInputDto(limited: ${_this.limited}, quantity: ${_this.quantity}, slug: ${_this.slug}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $DailyStemInputDtoCopyWith<$Res>  {
  factory $DailyStemInputDtoCopyWith(DailyStemInputDto value, $Res Function(DailyStemInputDto) _then) = _$DailyStemInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) bool? limited,@JsonKey(required: true, disallowNullValue: true) num quantity,@JsonKey(required: true, disallowNullValue: true) String slug,@JsonKey(readValue: DailyStemInputDto._extras, fromJson: DailyStemInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$DailyStemInputDtoCopyWithImpl<$Res>
    implements $DailyStemInputDtoCopyWith<$Res> {
  _$DailyStemInputDtoCopyWithImpl(this._self, this._then);

  final DailyStemInputDto _self;
  final $Res Function(DailyStemInputDto) _then;

/// Create a copy of DailyStemInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? limited = freezed,Object? quantity = null,Object? slug = null,Object? additionalProperties = null,}) {
  return _then(DailyStemInputDto(
limited: freezed == limited ? _self.limited : limited // ignore: cast_nullable_to_non_nullable
as bool?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyStemInputDto].
extension DailyStemInputDtoPatterns on DailyStemInputDto {
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
