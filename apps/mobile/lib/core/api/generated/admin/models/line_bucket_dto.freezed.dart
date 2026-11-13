// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'line_bucket_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LineBucketDto {


/// Create a copy of LineBucketDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LineBucketDtoCopyWith<LineBucketDto> get copyWith => _$LineBucketDtoCopyWithImpl<LineBucketDto>(this as LineBucketDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LineBucketDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineBucketDto&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.titleAr, _this.titleAr) || other.titleAr == _this.titleAr)&&(identical(other.titleEn, _this.titleEn) || other.titleEn == _this.titleEn)&&(identical(other.totalMinor, _this.totalMinor) || other.totalMinor == _this.totalMinor)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as LineBucketDto;
  return Object.hash(runtimeType,_this.key,_this.qty,_this.titleAr,_this.titleEn,_this.totalMinor,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as LineBucketDto;
  return 'LineBucketDto(key: ${_this.key}, qty: ${_this.qty}, titleAr: ${_this.titleAr}, titleEn: ${_this.titleEn}, totalMinor: ${_this.totalMinor}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $LineBucketDtoCopyWith<$Res>  {
  factory $LineBucketDtoCopyWith(LineBucketDto value, $Res Function(LineBucketDto) _then) = _$LineBucketDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String key,@JsonKey(required: true, disallowNullValue: true, fromJson: LineBucketDto._read_qty, toJson: LineBucketDto._write_qty) int qty,@JsonKey(required: true, disallowNullValue: true) String titleAr,@JsonKey(required: true, disallowNullValue: true) String titleEn,@JsonKey(required: true, disallowNullValue: true, fromJson: LineBucketDto._read_totalMinor, toJson: LineBucketDto._write_totalMinor) int totalMinor,@JsonKey(readValue: LineBucketDto._extras, fromJson: LineBucketDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$LineBucketDtoCopyWithImpl<$Res>
    implements $LineBucketDtoCopyWith<$Res> {
  _$LineBucketDtoCopyWithImpl(this._self, this._then);

  final LineBucketDto _self;
  final $Res Function(LineBucketDto) _then;

/// Create a copy of LineBucketDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? qty = null,Object? titleAr = null,Object? titleEn = null,Object? totalMinor = null,Object? additionalProperties = null,}) {
  return _then(LineBucketDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,titleAr: null == titleAr ? _self.titleAr : titleAr // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [LineBucketDto].
extension LineBucketDtoPatterns on LineBucketDto {
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
