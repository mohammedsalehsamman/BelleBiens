// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_line_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderLineDto {


/// Create a copy of OrderLineDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineDtoCopyWith<OrderLineDto> get copyWith => _$OrderLineDtoCopyWithImpl<OrderLineDto>(this as OrderLineDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderLineDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLineDto&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.totalMinor, _this.totalMinor) || other.totalMinor == _this.totalMinor)&&(identical(other.unitPriceMinor, _this.unitPriceMinor) || other.unitPriceMinor == _this.unitPriceMinor)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as OrderLineDto;
  return Object.hash(runtimeType,_this.imageUrl,_this.kind,_this.position,_this.qty,_this.summary,_this.title,_this.totalMinor,_this.unitPriceMinor,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as OrderLineDto;
  return 'OrderLineDto(imageUrl: ${_this.imageUrl}, kind: ${_this.kind}, position: ${_this.position}, qty: ${_this.qty}, summary: ${_this.summary}, title: ${_this.title}, totalMinor: ${_this.totalMinor}, unitPriceMinor: ${_this.unitPriceMinor}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $OrderLineDtoCopyWith<$Res>  {
  factory $OrderLineDtoCopyWith(OrderLineDto value, $Res Function(OrderLineDto) _then) = _$OrderLineDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) String? imageUrl,@JsonKey(required: true, disallowNullValue: true) String kind,@JsonKey(required: true, disallowNullValue: true, fromJson: OrderLineDto._read_position, toJson: OrderLineDto._write_position) int position,@JsonKey(required: true, disallowNullValue: true, fromJson: OrderLineDto._read_qty, toJson: OrderLineDto._write_qty) int qty,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto summary,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto title,@JsonKey(required: true, disallowNullValue: true, fromJson: OrderLineDto._read_totalMinor, toJson: OrderLineDto._write_totalMinor) int totalMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: OrderLineDto._read_unitPriceMinor, toJson: OrderLineDto._write_unitPriceMinor) int unitPriceMinor,@JsonKey(readValue: OrderLineDto._extras, fromJson: OrderLineDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$LocalizedTextDtoCopyWith<$Res> get summary;$LocalizedTextDtoCopyWith<$Res> get title;

}
/// @nodoc
class _$OrderLineDtoCopyWithImpl<$Res>
    implements $OrderLineDtoCopyWith<$Res> {
  _$OrderLineDtoCopyWithImpl(this._self, this._then);

  final OrderLineDto _self;
  final $Res Function(OrderLineDto) _then;

/// Create a copy of OrderLineDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageUrl = freezed,Object? kind = null,Object? position = null,Object? qty = null,Object? summary = null,Object? title = null,Object? totalMinor = null,Object? unitPriceMinor = null,Object? additionalProperties = null,}) {
  return _then(OrderLineDto(
imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of OrderLineDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get summary {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of OrderLineDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get title {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.title, (value) {
    return _then(_self.copyWith(title: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderLineDto].
extension OrderLineDtoPatterns on OrderLineDto {
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
