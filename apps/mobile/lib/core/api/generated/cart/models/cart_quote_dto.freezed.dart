// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_quote_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartQuoteDto {


/// Create a copy of CartQuoteDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartQuoteDtoCopyWith<CartQuoteDto> get copyWith => _$CartQuoteDtoCopyWithImpl<CartQuoteDto>(this as CartQuoteDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CartQuoteDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartQuoteDto&&(identical(other.coupon, _this.coupon) || other.coupon == _this.coupon)&&(identical(other.earliestAt, _this.earliestAt) || other.earliestAt == _this.earliestAt)&&(identical(other.earliestInDays, _this.earliestInDays) || other.earliestInDays == _this.earliestInDays)&&(identical(other.leadTimeHours, _this.leadTimeHours) || other.leadTimeHours == _this.leadTimeHours)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.orderable, _this.orderable) || other.orderable == _this.orderable)&&const DeepCollectionEquality().equals(other.suggestions, _this.suggestions)&&(identical(other.syp, _this.syp) || other.syp == _this.syp)&&(identical(other.usd, _this.usd) || other.usd == _this.usd)&&(identical(other.usdRate, _this.usdRate) || other.usdRate == _this.usdRate)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as CartQuoteDto;
  return Object.hash(runtimeType,_this.coupon,_this.earliestAt,_this.earliestInDays,_this.leadTimeHours,const DeepCollectionEquality().hash(_this.lines),_this.orderable,const DeepCollectionEquality().hash(_this.suggestions),_this.syp,_this.usd,_this.usdRate,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as CartQuoteDto;
  return 'CartQuoteDto(coupon: ${_this.coupon}, earliestAt: ${_this.earliestAt}, earliestInDays: ${_this.earliestInDays}, leadTimeHours: ${_this.leadTimeHours}, lines: ${_this.lines}, orderable: ${_this.orderable}, suggestions: ${_this.suggestions}, syp: ${_this.syp}, usd: ${_this.usd}, usdRate: ${_this.usdRate}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $CartQuoteDtoCopyWith<$Res>  {
  factory $CartQuoteDtoCopyWith(CartQuoteDto value, $Res Function(CartQuoteDto) _then) = _$CartQuoteDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true) CartQuoteDtoCoupon? coupon,@JsonKey(required: true, disallowNullValue: true) String earliestAt,@JsonKey(required: true, disallowNullValue: true, fromJson: CartQuoteDto._read_earliestInDays, toJson: CartQuoteDto._write_earliestInDays) int earliestInDays,@JsonKey(required: true, disallowNullValue: true, fromJson: CartQuoteDto._read_leadTimeHours, toJson: CartQuoteDto._write_leadTimeHours) int leadTimeHours,@JsonKey(required: true, disallowNullValue: true) List<QuotedLineDto> lines,@JsonKey(required: true, disallowNullValue: true) bool orderable,@JsonKey(required: true, disallowNullValue: true) List<ProductCardDto> suggestions,@JsonKey(required: true, disallowNullValue: true) MoneyBreakdownDto syp,@JsonKey(required: true, disallowNullValue: true) MoneyBreakdownDto usd,@JsonKey(required: true, disallowNullValue: true) String usdRate,@JsonKey(readValue: CartQuoteDto._extras, fromJson: CartQuoteDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$CartQuoteDtoCouponCopyWith<$Res>? get coupon;$MoneyBreakdownDtoCopyWith<$Res> get syp;$MoneyBreakdownDtoCopyWith<$Res> get usd;

}
/// @nodoc
class _$CartQuoteDtoCopyWithImpl<$Res>
    implements $CartQuoteDtoCopyWith<$Res> {
  _$CartQuoteDtoCopyWithImpl(this._self, this._then);

  final CartQuoteDto _self;
  final $Res Function(CartQuoteDto) _then;

/// Create a copy of CartQuoteDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coupon = freezed,Object? earliestAt = null,Object? earliestInDays = null,Object? leadTimeHours = null,Object? lines = null,Object? orderable = null,Object? suggestions = null,Object? syp = null,Object? usd = null,Object? usdRate = null,Object? additionalProperties = null,}) {
  return _then(CartQuoteDto(
coupon: freezed == coupon ? _self.coupon : coupon // ignore: cast_nullable_to_non_nullable
as CartQuoteDtoCoupon?,earliestAt: null == earliestAt ? _self.earliestAt : earliestAt // ignore: cast_nullable_to_non_nullable
as String,earliestInDays: null == earliestInDays ? _self.earliestInDays : earliestInDays // ignore: cast_nullable_to_non_nullable
as int,leadTimeHours: null == leadTimeHours ? _self.leadTimeHours : leadTimeHours // ignore: cast_nullable_to_non_nullable
as int,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<QuotedLineDto>,orderable: null == orderable ? _self.orderable : orderable // ignore: cast_nullable_to_non_nullable
as bool,suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<ProductCardDto>,syp: null == syp ? _self.syp : syp // ignore: cast_nullable_to_non_nullable
as MoneyBreakdownDto,usd: null == usd ? _self.usd : usd // ignore: cast_nullable_to_non_nullable
as MoneyBreakdownDto,usdRate: null == usdRate ? _self.usdRate : usdRate // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of CartQuoteDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CartQuoteDtoCouponCopyWith<$Res>? get coupon {
    if (_self.coupon == null) {
    return null;
  }

  return $CartQuoteDtoCouponCopyWith<$Res>(_self.coupon!, (value) {
    return _then(_self.copyWith(coupon: value));
  });
}/// Create a copy of CartQuoteDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyBreakdownDtoCopyWith<$Res> get syp {
  
  return $MoneyBreakdownDtoCopyWith<$Res>(_self.syp, (value) {
    return _then(_self.copyWith(syp: value));
  });
}/// Create a copy of CartQuoteDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyBreakdownDtoCopyWith<$Res> get usd {
  
  return $MoneyBreakdownDtoCopyWith<$Res>(_self.usd, (value) {
    return _then(_self.copyWith(usd: value));
  });
}
}


/// Adds pattern-matching-related methods to [CartQuoteDto].
extension CartQuoteDtoPatterns on CartQuoteDto {
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
