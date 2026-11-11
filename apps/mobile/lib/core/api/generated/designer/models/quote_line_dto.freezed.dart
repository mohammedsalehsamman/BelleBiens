// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_line_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuoteLineDto {


/// Create a copy of QuoteLineDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteLineDtoCopyWith<QuoteLineDto> get copyWith => _$QuoteLineDtoCopyWithImpl<QuoteLineDto>(this as QuoteLineDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuoteLineDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteLineDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.totalMinor, _this.totalMinor) || other.totalMinor == _this.totalMinor)&&(identical(other.type2, _this.type2) || other.type2 == _this.type2)&&(identical(other.unitPriceMinor, _this.unitPriceMinor) || other.unitPriceMinor == _this.unitPriceMinor)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as QuoteLineDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.qty,_this.totalMinor,_this.type2,_this.unitPriceMinor,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as QuoteLineDto;
  return 'QuoteLineDto(id: ${_this.id}, name: ${_this.name}, qty: ${_this.qty}, totalMinor: ${_this.totalMinor}, type2: ${_this.type2}, unitPriceMinor: ${_this.unitPriceMinor}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $QuoteLineDtoCopyWith<$Res>  {
  factory $QuoteLineDtoCopyWith(QuoteLineDto value, $Res Function(QuoteLineDto) _then) = _$QuoteLineDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto name,@JsonKey(required: true, disallowNullValue: true, fromJson: QuoteLineDto._read_qty, toJson: QuoteLineDto._write_qty) int qty,@JsonKey(required: true, disallowNullValue: true, fromJson: QuoteLineDto._read_totalMinor, toJson: QuoteLineDto._write_totalMinor) int totalMinor,@JsonKey(name: "type", required: true, disallowNullValue: true, fromJson: QuoteLineDto._read_type2, toJson: QuoteLineDto._write_type2) DesignerPart type2,@JsonKey(required: true, disallowNullValue: true, fromJson: QuoteLineDto._read_unitPriceMinor, toJson: QuoteLineDto._write_unitPriceMinor) int unitPriceMinor,@JsonKey(readValue: QuoteLineDto._extras, fromJson: QuoteLineDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$LocalizedTextDtoCopyWith<$Res> get name;

}
/// @nodoc
class _$QuoteLineDtoCopyWithImpl<$Res>
    implements $QuoteLineDtoCopyWith<$Res> {
  _$QuoteLineDtoCopyWithImpl(this._self, this._then);

  final QuoteLineDto _self;
  final $Res Function(QuoteLineDto) _then;

/// Create a copy of QuoteLineDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? qty = null,Object? totalMinor = null,Object? type2 = null,Object? unitPriceMinor = null,Object? additionalProperties = null,}) {
  return _then(QuoteLineDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,type2: null == type2 ? _self.type2 : type2 // ignore: cast_nullable_to_non_nullable
as DesignerPart,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of QuoteLineDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get name {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuoteLineDto].
extension QuoteLineDtoPatterns on QuoteLineDto {
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
