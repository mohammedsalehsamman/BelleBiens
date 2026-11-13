// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'low_stock_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LowStockDto {


/// Create a copy of LowStockDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LowStockDtoCopyWith<LowStockDto> get copyWith => _$LowStockDtoCopyWithImpl<LowStockDto>(this as LowStockDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LowStockDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LowStockDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.left, _this.left) || other.left == _this.left)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.nameEn, _this.nameEn) || other.nameEn == _this.nameEn)&&(identical(other.source, _this.source) || other.source == _this.source)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as LowStockDto;
  return Object.hash(runtimeType,_this.id,_this.left,_this.nameAr,_this.nameEn,_this.source,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as LowStockDto;
  return 'LowStockDto(id: ${_this.id}, left: ${_this.left}, nameAr: ${_this.nameAr}, nameEn: ${_this.nameEn}, source: ${_this.source}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $LowStockDtoCopyWith<$Res>  {
  factory $LowStockDtoCopyWith(LowStockDto value, $Res Function(LowStockDto) _then) = _$LowStockDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true, disallowNullValue: true, fromJson: LowStockDto._read_left, toJson: LowStockDto._write_left) int left,@JsonKey(required: true, disallowNullValue: true) String nameAr,@JsonKey(required: true, disallowNullValue: true) String nameEn,@JsonKey(required: true, disallowNullValue: true, fromJson: LowStockDto._read_source, toJson: LowStockDto._write_source) LowStockDtoSource source,@JsonKey(readValue: LowStockDto._extras, fromJson: LowStockDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$LowStockDtoCopyWithImpl<$Res>
    implements $LowStockDtoCopyWith<$Res> {
  _$LowStockDtoCopyWithImpl(this._self, this._then);

  final LowStockDto _self;
  final $Res Function(LowStockDto) _then;

/// Create a copy of LowStockDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? left = null,Object? nameAr = null,Object? nameEn = null,Object? source = null,Object? additionalProperties = null,}) {
  return _then(LowStockDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as int,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as LowStockDtoSource,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [LowStockDto].
extension LowStockDtoPatterns on LowStockDto {
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
