// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_order_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateOrderDto {


/// Create a copy of CreateOrderDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateOrderDtoCopyWith<CreateOrderDto> get copyWith => _$CreateOrderDtoCopyWithImpl<CreateOrderDto>(this as CreateOrderDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CreateOrderDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateOrderDto&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.callBeforeArrival, _this.callBeforeArrival) || other.callBeforeArrival == _this.callBeforeArrival)&&(identical(other.couponCode, _this.couponCode) || other.couponCode == _this.couponCode)&&(identical(other.customer, _this.customer) || other.customer == _this.customer)&&(identical(other.fulfillment, _this.fulfillment) || other.fulfillment == _this.fulfillment)&&(identical(other.hideSender, _this.hideSender) || other.hideSender == _this.hideSender)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.recipient, _this.recipient) || other.recipient == _this.recipient)&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.slotHoldId, _this.slotHoldId) || other.slotHoldId == _this.slotHoldId)&&(identical(other.whatsappConfirm, _this.whatsappConfirm) || other.whatsappConfirm == _this.whatsappConfirm)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as CreateOrderDto;
  return Object.hash(runtimeType,_this.address,_this.callBeforeArrival,_this.couponCode,_this.customer,_this.fulfillment,_this.hideSender,const DeepCollectionEquality().hash(_this.lines),_this.notes,_this.paymentMethod,_this.recipient,_this.slot,_this.slotHoldId,_this.whatsappConfirm,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as CreateOrderDto;
  return 'CreateOrderDto(address: ${_this.address}, callBeforeArrival: ${_this.callBeforeArrival}, couponCode: ${_this.couponCode}, customer: ${_this.customer}, fulfillment: ${_this.fulfillment}, hideSender: ${_this.hideSender}, lines: ${_this.lines}, notes: ${_this.notes}, paymentMethod: ${_this.paymentMethod}, recipient: ${_this.recipient}, slot: ${_this.slot}, slotHoldId: ${_this.slotHoldId}, whatsappConfirm: ${_this.whatsappConfirm}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $CreateOrderDtoCopyWith<$Res>  {
  factory $CreateOrderDtoCopyWith(CreateOrderDto value, $Res Function(CreateOrderDto) _then) = _$CreateOrderDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) OrderAddressInputDto? address,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? callBeforeArrival,@JsonKey(disallowNullValue: true, includeIfNull: false) String? couponCode,@JsonKey(required: true, disallowNullValue: true) PersonDto customer,@JsonKey(required: true, disallowNullValue: true, fromJson: CreateOrderDto._read_fulfillment, toJson: CreateOrderDto._write_fulfillment) Fulfillment fulfillment,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? hideSender,@JsonKey(required: true, disallowNullValue: true) List<CartLineInputDto> lines,@JsonKey(disallowNullValue: true, includeIfNull: false) String? notes,@JsonKey(required: true, disallowNullValue: true, fromJson: CreateOrderDto._read_paymentMethod, toJson: CreateOrderDto._write_paymentMethod) PaymentMethod paymentMethod,@JsonKey(disallowNullValue: true, includeIfNull: false) PersonDto? recipient,@JsonKey(required: true, disallowNullValue: true) SlotChoiceDto slot,@JsonKey(disallowNullValue: true, includeIfNull: false) String? slotHoldId,@JsonKey(disallowNullValue: true, includeIfNull: false) bool? whatsappConfirm,@JsonKey(readValue: CreateOrderDto._extras, fromJson: CreateOrderDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$OrderAddressInputDtoCopyWith<$Res>? get address;$PersonDtoCopyWith<$Res> get customer;$PersonDtoCopyWith<$Res>? get recipient;$SlotChoiceDtoCopyWith<$Res> get slot;

}
/// @nodoc
class _$CreateOrderDtoCopyWithImpl<$Res>
    implements $CreateOrderDtoCopyWith<$Res> {
  _$CreateOrderDtoCopyWithImpl(this._self, this._then);

  final CreateOrderDto _self;
  final $Res Function(CreateOrderDto) _then;

/// Create a copy of CreateOrderDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = freezed,Object? callBeforeArrival = freezed,Object? couponCode = freezed,Object? customer = null,Object? fulfillment = null,Object? hideSender = freezed,Object? lines = null,Object? notes = freezed,Object? paymentMethod = null,Object? recipient = freezed,Object? slot = null,Object? slotHoldId = freezed,Object? whatsappConfirm = freezed,Object? additionalProperties = null,}) {
  return _then(CreateOrderDto(
address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as OrderAddressInputDto?,callBeforeArrival: freezed == callBeforeArrival ? _self.callBeforeArrival : callBeforeArrival // ignore: cast_nullable_to_non_nullable
as bool?,couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,customer: null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as PersonDto,fulfillment: null == fulfillment ? _self.fulfillment : fulfillment // ignore: cast_nullable_to_non_nullable
as Fulfillment,hideSender: freezed == hideSender ? _self.hideSender : hideSender // ignore: cast_nullable_to_non_nullable
as bool?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<CartLineInputDto>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,recipient: freezed == recipient ? _self.recipient : recipient // ignore: cast_nullable_to_non_nullable
as PersonDto?,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as SlotChoiceDto,slotHoldId: freezed == slotHoldId ? _self.slotHoldId : slotHoldId // ignore: cast_nullable_to_non_nullable
as String?,whatsappConfirm: freezed == whatsappConfirm ? _self.whatsappConfirm : whatsappConfirm // ignore: cast_nullable_to_non_nullable
as bool?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of CreateOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderAddressInputDtoCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $OrderAddressInputDtoCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of CreateOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonDtoCopyWith<$Res> get customer {
  
  return $PersonDtoCopyWith<$Res>(_self.customer, (value) {
    return _then(_self.copyWith(customer: value));
  });
}/// Create a copy of CreateOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonDtoCopyWith<$Res>? get recipient {
    if (_self.recipient == null) {
    return null;
  }

  return $PersonDtoCopyWith<$Res>(_self.recipient!, (value) {
    return _then(_self.copyWith(recipient: value));
  });
}/// Create a copy of CreateOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotChoiceDtoCopyWith<$Res> get slot {
  
  return $SlotChoiceDtoCopyWith<$Res>(_self.slot, (value) {
    return _then(_self.copyWith(slot: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateOrderDto].
extension CreateOrderDtoPatterns on CreateOrderDto {
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
