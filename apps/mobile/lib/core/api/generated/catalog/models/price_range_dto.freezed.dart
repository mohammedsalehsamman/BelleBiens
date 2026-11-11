// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_range_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PriceRangeDto {


/// Create a copy of PriceRangeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceRangeDtoCopyWith<PriceRangeDto> get copyWith => _$PriceRangeDtoCopyWithImpl<PriceRangeDto>(this as PriceRangeDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PriceRangeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceRangeDto&&(identical(other.maxMinor, _this.maxMinor) || other.maxMinor == _this.maxMinor)&&(identical(other.minMinor, _this.minMinor) || other.minMinor == _this.minMinor)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as PriceRangeDto;
  return Object.hash(runtimeType,_this.maxMinor,_this.minMinor,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as PriceRangeDto;
  return 'PriceRangeDto(maxMinor: ${_this.maxMinor}, minMinor: ${_this.minMinor}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $PriceRangeDtoCopyWith<$Res>  {
  factory $PriceRangeDtoCopyWith(PriceRangeDto value, $Res Function(PriceRangeDto) _then) = _$PriceRangeDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: PriceRangeDto._read_maxMinor, toJson: PriceRangeDto._write_maxMinor) int maxMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: PriceRangeDto._read_minMinor, toJson: PriceRangeDto._write_minMinor) int minMinor,@JsonKey(readValue: PriceRangeDto._extras, fromJson: PriceRangeDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$PriceRangeDtoCopyWithImpl<$Res>
    implements $PriceRangeDtoCopyWith<$Res> {
  _$PriceRangeDtoCopyWithImpl(this._self, this._then);

  final PriceRangeDto _self;
  final $Res Function(PriceRangeDto) _then;

/// Create a copy of PriceRangeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maxMinor = null,Object? minMinor = null,Object? additionalProperties = null,}) {
  return _then(PriceRangeDto(
maxMinor: null == maxMinor ? _self.maxMinor : maxMinor // ignore: cast_nullable_to_non_nullable
as int,minMinor: null == minMinor ? _self.minMinor : minMinor // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceRangeDto].
extension PriceRangeDtoPatterns on PriceRangeDto {
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
