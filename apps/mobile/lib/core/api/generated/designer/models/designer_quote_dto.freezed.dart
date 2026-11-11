// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'designer_quote_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DesignerQuoteDto {


/// Create a copy of DesignerQuoteDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DesignerQuoteDtoCopyWith<DesignerQuoteDto> get copyWith => _$DesignerQuoteDtoCopyWithImpl<DesignerQuoteDto>(this as DesignerQuoteDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DesignerQuoteDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DesignerQuoteDto&&(identical(other.assemblyFeeMinor, _this.assemblyFeeMinor) || other.assemblyFeeMinor == _this.assemblyFeeMinor)&&const DeepCollectionEquality().equals(other.issues, _this.issues)&&(identical(other.itemsMinor, _this.itemsMinor) || other.itemsMinor == _this.itemsMinor)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.orderable, _this.orderable) || other.orderable == _this.orderable)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.specHash, _this.specHash) || other.specHash == _this.specHash)&&(identical(other.stems, _this.stems) || other.stems == _this.stems)&&(identical(other.totalMinor, _this.totalMinor) || other.totalMinor == _this.totalMinor)&&(identical(other.totalUsdCents, _this.totalUsdCents) || other.totalUsdCents == _this.totalUsdCents)&&(identical(other.usdRate, _this.usdRate) || other.usdRate == _this.usdRate)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as DesignerQuoteDto;
  return Object.hash(runtimeType,_this.assemblyFeeMinor,const DeepCollectionEquality().hash(_this.issues),_this.itemsMinor,const DeepCollectionEquality().hash(_this.lines),_this.orderable,_this.size,_this.specHash,_this.stems,_this.totalMinor,_this.totalUsdCents,_this.usdRate,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as DesignerQuoteDto;
  return 'DesignerQuoteDto(assemblyFeeMinor: ${_this.assemblyFeeMinor}, issues: ${_this.issues}, itemsMinor: ${_this.itemsMinor}, lines: ${_this.lines}, orderable: ${_this.orderable}, size: ${_this.size}, specHash: ${_this.specHash}, stems: ${_this.stems}, totalMinor: ${_this.totalMinor}, totalUsdCents: ${_this.totalUsdCents}, usdRate: ${_this.usdRate}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $DesignerQuoteDtoCopyWith<$Res>  {
  factory $DesignerQuoteDtoCopyWith(DesignerQuoteDto value, $Res Function(DesignerQuoteDto) _then) = _$DesignerQuoteDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: DesignerQuoteDto._read_assemblyFeeMinor, toJson: DesignerQuoteDto._write_assemblyFeeMinor) int assemblyFeeMinor,@JsonKey(required: true, disallowNullValue: true) List<QuoteIssueDto> issues,@JsonKey(required: true, disallowNullValue: true, fromJson: DesignerQuoteDto._read_itemsMinor, toJson: DesignerQuoteDto._write_itemsMinor) int itemsMinor,@JsonKey(required: true, disallowNullValue: true) List<QuoteLineDto> lines,@JsonKey(required: true, disallowNullValue: true) bool orderable,@JsonKey(required: true, disallowNullValue: true) DesignerSizeDto size,@JsonKey(required: true, disallowNullValue: true) String specHash,@JsonKey(required: true, disallowNullValue: true, fromJson: DesignerQuoteDto._read_stems, toJson: DesignerQuoteDto._write_stems) int stems,@JsonKey(required: true, disallowNullValue: true, fromJson: DesignerQuoteDto._read_totalMinor, toJson: DesignerQuoteDto._write_totalMinor) int totalMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: DesignerQuoteDto._read_totalUsdCents, toJson: DesignerQuoteDto._write_totalUsdCents) int totalUsdCents,@JsonKey(required: true, disallowNullValue: true) String usdRate,@JsonKey(readValue: DesignerQuoteDto._extras, fromJson: DesignerQuoteDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$DesignerSizeDtoCopyWith<$Res> get size;

}
/// @nodoc
class _$DesignerQuoteDtoCopyWithImpl<$Res>
    implements $DesignerQuoteDtoCopyWith<$Res> {
  _$DesignerQuoteDtoCopyWithImpl(this._self, this._then);

  final DesignerQuoteDto _self;
  final $Res Function(DesignerQuoteDto) _then;

/// Create a copy of DesignerQuoteDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assemblyFeeMinor = null,Object? issues = null,Object? itemsMinor = null,Object? lines = null,Object? orderable = null,Object? size = null,Object? specHash = null,Object? stems = null,Object? totalMinor = null,Object? totalUsdCents = null,Object? usdRate = null,Object? additionalProperties = null,}) {
  return _then(DesignerQuoteDto(
assemblyFeeMinor: null == assemblyFeeMinor ? _self.assemblyFeeMinor : assemblyFeeMinor // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as List<QuoteIssueDto>,itemsMinor: null == itemsMinor ? _self.itemsMinor : itemsMinor // ignore: cast_nullable_to_non_nullable
as int,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<QuoteLineDto>,orderable: null == orderable ? _self.orderable : orderable // ignore: cast_nullable_to_non_nullable
as bool,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as DesignerSizeDto,specHash: null == specHash ? _self.specHash : specHash // ignore: cast_nullable_to_non_nullable
as String,stems: null == stems ? _self.stems : stems // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,totalUsdCents: null == totalUsdCents ? _self.totalUsdCents : totalUsdCents // ignore: cast_nullable_to_non_nullable
as int,usdRate: null == usdRate ? _self.usdRate : usdRate // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of DesignerQuoteDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DesignerSizeDtoCopyWith<$Res> get size {
  
  return $DesignerSizeDtoCopyWith<$Res>(_self.size, (value) {
    return _then(_self.copyWith(size: value));
  });
}
}


/// Adds pattern-matching-related methods to [DesignerQuoteDto].
extension DesignerQuoteDtoPatterns on DesignerQuoteDto {
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
