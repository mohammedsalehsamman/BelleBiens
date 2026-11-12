// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_event_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentEventDto {


/// Create a copy of PaymentEventDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentEventDtoCopyWith<PaymentEventDto> get copyWith => _$PaymentEventDtoCopyWithImpl<PaymentEventDto>(this as PaymentEventDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaymentEventDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentEventDto&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.receiptUrl, _this.receiptUrl) || other.receiptUrl == _this.receiptUrl)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as PaymentEventDto;
  return Object.hash(runtimeType,_this.amountMinor,_this.at,_this.currency,_this.kind,_this.method,_this.note,_this.receiptUrl,_this.reference,_this.status,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as PaymentEventDto;
  return 'PaymentEventDto(amountMinor: ${_this.amountMinor}, at: ${_this.at}, currency: ${_this.currency}, kind: ${_this.kind}, method: ${_this.method}, note: ${_this.note}, receiptUrl: ${_this.receiptUrl}, reference: ${_this.reference}, status: ${_this.status}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $PaymentEventDtoCopyWith<$Res>  {
  factory $PaymentEventDtoCopyWith(PaymentEventDto value, $Res Function(PaymentEventDto) _then) = _$PaymentEventDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: PaymentEventDto._read_amountMinor, toJson: PaymentEventDto._write_amountMinor) int amountMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: PaymentEventDto._read_at, toJson: PaymentEventDto._write_at) DateTime at,@JsonKey(required: true, disallowNullValue: true) String currency,@JsonKey(required: true, disallowNullValue: true) String kind,@JsonKey(required: true, disallowNullValue: true, fromJson: PaymentEventDto._read_method, toJson: PaymentEventDto._write_method) PaymentMethod method,@JsonKey(required: true, disallowNullValue: true) String note,@JsonKey(disallowNullValue: true, includeIfNull: false) String? receiptUrl,@JsonKey(disallowNullValue: true, includeIfNull: false) String? reference,@JsonKey(required: true, disallowNullValue: true, fromJson: PaymentEventDto._read_status, toJson: PaymentEventDto._write_status) PaymentStatus status,@JsonKey(readValue: PaymentEventDto._extras, fromJson: PaymentEventDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$PaymentEventDtoCopyWithImpl<$Res>
    implements $PaymentEventDtoCopyWith<$Res> {
  _$PaymentEventDtoCopyWithImpl(this._self, this._then);

  final PaymentEventDto _self;
  final $Res Function(PaymentEventDto) _then;

/// Create a copy of PaymentEventDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amountMinor = null,Object? at = null,Object? currency = null,Object? kind = null,Object? method = null,Object? note = null,Object? receiptUrl = freezed,Object? reference = freezed,Object? status = null,Object? additionalProperties = null,}) {
  return _then(PaymentEventDto(
amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentEventDto].
extension PaymentEventDtoPatterns on PaymentEventDto {
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
