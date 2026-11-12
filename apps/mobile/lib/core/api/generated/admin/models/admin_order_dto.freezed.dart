// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_order_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminOrderDto {


/// Create a copy of AdminOrderDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOrderDtoCopyWith<AdminOrderDto> get copyWith => _$AdminOrderDtoCopyWithImpl<AdminOrderDto>(this as AdminOrderDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdminOrderDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOrderDto&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.callBeforeArrival, _this.callBeforeArrival) || other.callBeforeArrival == _this.callBeforeArrival)&&(identical(other.canCancel, _this.canCancel) || other.canCancel == _this.canCancel)&&(identical(other.couponCode, _this.couponCode) || other.couponCode == _this.couponCode)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.customer, _this.customer) || other.customer == _this.customer)&&(identical(other.fulfillment, _this.fulfillment) || other.fulfillment == _this.fulfillment)&&(identical(other.hideSender, _this.hideSender) || other.hideSender == _this.hideSender)&&const DeepCollectionEquality().equals(other.history, _this.history)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&const DeepCollectionEquality().equals(other.next, _this.next)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.paymentStatus, _this.paymentStatus) || other.paymentStatus == _this.paymentStatus)&&(identical(other.recipient, _this.recipient) || other.recipient == _this.recipient)&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.syp, _this.syp) || other.syp == _this.syp)&&(identical(other.totalUsdCents, _this.totalUsdCents) || other.totalUsdCents == _this.totalUsdCents)&&(identical(other.usdRate, _this.usdRate) || other.usdRate == _this.usdRate)&&(identical(other.whatsappConfirm, _this.whatsappConfirm) || other.whatsappConfirm == _this.whatsappConfirm)&&(identical(other.zone, _this.zone) || other.zone == _this.zone)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as AdminOrderDto;
  return Object.hashAll([runtimeType,_this.address,_this.callBeforeArrival,_this.canCancel,_this.couponCode,_this.createdAt,_this.customer,_this.fulfillment,_this.hideSender,const DeepCollectionEquality().hash(_this.history),const DeepCollectionEquality().hash(_this.lines),const DeepCollectionEquality().hash(_this.next),_this.notes,_this.number,_this.paymentMethod,_this.paymentStatus,_this.recipient,_this.slot,_this.status,_this.syp,_this.totalUsdCents,_this.usdRate,_this.whatsappConfirm,_this.zone,const DeepCollectionEquality().hash(_this.additionalProperties)]);
}

@override
String toString() {
  final _this = this as AdminOrderDto;
  return 'AdminOrderDto(address: ${_this.address}, callBeforeArrival: ${_this.callBeforeArrival}, canCancel: ${_this.canCancel}, couponCode: ${_this.couponCode}, createdAt: ${_this.createdAt}, customer: ${_this.customer}, fulfillment: ${_this.fulfillment}, hideSender: ${_this.hideSender}, history: ${_this.history}, lines: ${_this.lines}, next: ${_this.next}, notes: ${_this.notes}, number: ${_this.number}, paymentMethod: ${_this.paymentMethod}, paymentStatus: ${_this.paymentStatus}, recipient: ${_this.recipient}, slot: ${_this.slot}, status: ${_this.status}, syp: ${_this.syp}, totalUsdCents: ${_this.totalUsdCents}, usdRate: ${_this.usdRate}, whatsappConfirm: ${_this.whatsappConfirm}, zone: ${_this.zone}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $AdminOrderDtoCopyWith<$Res>  {
  factory $AdminOrderDtoCopyWith(AdminOrderDto value, $Res Function(AdminOrderDto) _then) = _$AdminOrderDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) OrderAddressDto? address,@JsonKey(required: true, disallowNullValue: true) bool callBeforeArrival,@JsonKey(required: true, disallowNullValue: true) bool canCancel,@JsonKey(disallowNullValue: true, includeIfNull: false) String? couponCode,@JsonKey(required: true, disallowNullValue: true, fromJson: AdminOrderDto._read_createdAt, toJson: AdminOrderDto._write_createdAt) DateTime createdAt,@JsonKey(required: true, disallowNullValue: true) RecipientDto customer,@JsonKey(required: true, disallowNullValue: true, fromJson: AdminOrderDto._read_fulfillment, toJson: AdminOrderDto._write_fulfillment) Fulfillment fulfillment,@JsonKey(required: true, disallowNullValue: true) bool hideSender,@JsonKey(required: true, disallowNullValue: true) List<StatusEventDto> history,@JsonKey(required: true, disallowNullValue: true) List<OrderLineDto> lines,@JsonKey(required: true, disallowNullValue: true, fromJson: AdminOrderDto._read_next, toJson: AdminOrderDto._write_next) List<AdminOrderDtoNextItem> next,@JsonKey(required: true, disallowNullValue: true) String notes,@JsonKey(required: true, disallowNullValue: true) String number,@JsonKey(required: true, disallowNullValue: true, fromJson: AdminOrderDto._read_paymentMethod, toJson: AdminOrderDto._write_paymentMethod) PaymentMethod paymentMethod,@JsonKey(required: true, disallowNullValue: true, fromJson: AdminOrderDto._read_paymentStatus, toJson: AdminOrderDto._write_paymentStatus) PaymentStatus paymentStatus,@JsonKey(required: true, disallowNullValue: true) RecipientDto recipient,@JsonKey(required: true, disallowNullValue: true) OrderSlotDto slot,@JsonKey(required: true, disallowNullValue: true, fromJson: AdminOrderDto._read_status, toJson: AdminOrderDto._write_status) OrderStatus status,@JsonKey(required: true, disallowNullValue: true) MoneyBreakdownDto syp,@JsonKey(required: true, disallowNullValue: true, fromJson: AdminOrderDto._read_totalUsdCents, toJson: AdminOrderDto._write_totalUsdCents) int totalUsdCents,@JsonKey(required: true, disallowNullValue: true) String usdRate,@JsonKey(required: true, disallowNullValue: true) bool whatsappConfirm,@JsonKey(disallowNullValue: true, includeIfNull: false) ZoneDto? zone,@JsonKey(readValue: AdminOrderDto._extras, fromJson: AdminOrderDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$OrderAddressDtoCopyWith<$Res>? get address;$RecipientDtoCopyWith<$Res> get customer;$RecipientDtoCopyWith<$Res> get recipient;$OrderSlotDtoCopyWith<$Res> get slot;$MoneyBreakdownDtoCopyWith<$Res> get syp;$ZoneDtoCopyWith<$Res>? get zone;

}
/// @nodoc
class _$AdminOrderDtoCopyWithImpl<$Res>
    implements $AdminOrderDtoCopyWith<$Res> {
  _$AdminOrderDtoCopyWithImpl(this._self, this._then);

  final AdminOrderDto _self;
  final $Res Function(AdminOrderDto) _then;

/// Create a copy of AdminOrderDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = freezed,Object? callBeforeArrival = null,Object? canCancel = null,Object? couponCode = freezed,Object? createdAt = null,Object? customer = null,Object? fulfillment = null,Object? hideSender = null,Object? history = null,Object? lines = null,Object? next = null,Object? notes = null,Object? number = null,Object? paymentMethod = null,Object? paymentStatus = null,Object? recipient = null,Object? slot = null,Object? status = null,Object? syp = null,Object? totalUsdCents = null,Object? usdRate = null,Object? whatsappConfirm = null,Object? zone = freezed,Object? additionalProperties = null,}) {
  return _then(AdminOrderDto(
address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as OrderAddressDto?,callBeforeArrival: null == callBeforeArrival ? _self.callBeforeArrival : callBeforeArrival // ignore: cast_nullable_to_non_nullable
as bool,canCancel: null == canCancel ? _self.canCancel : canCancel // ignore: cast_nullable_to_non_nullable
as bool,couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,customer: null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as RecipientDto,fulfillment: null == fulfillment ? _self.fulfillment : fulfillment // ignore: cast_nullable_to_non_nullable
as Fulfillment,hideSender: null == hideSender ? _self.hideSender : hideSender // ignore: cast_nullable_to_non_nullable
as bool,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<StatusEventDto>,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<OrderLineDto>,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as List<AdminOrderDtoNextItem>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,recipient: null == recipient ? _self.recipient : recipient // ignore: cast_nullable_to_non_nullable
as RecipientDto,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as OrderSlotDto,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,syp: null == syp ? _self.syp : syp // ignore: cast_nullable_to_non_nullable
as MoneyBreakdownDto,totalUsdCents: null == totalUsdCents ? _self.totalUsdCents : totalUsdCents // ignore: cast_nullable_to_non_nullable
as int,usdRate: null == usdRate ? _self.usdRate : usdRate // ignore: cast_nullable_to_non_nullable
as String,whatsappConfirm: null == whatsappConfirm ? _self.whatsappConfirm : whatsappConfirm // ignore: cast_nullable_to_non_nullable
as bool,zone: freezed == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as ZoneDto?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of AdminOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderAddressDtoCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $OrderAddressDtoCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of AdminOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipientDtoCopyWith<$Res> get customer {
  
  return $RecipientDtoCopyWith<$Res>(_self.customer, (value) {
    return _then(_self.copyWith(customer: value));
  });
}/// Create a copy of AdminOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipientDtoCopyWith<$Res> get recipient {
  
  return $RecipientDtoCopyWith<$Res>(_self.recipient, (value) {
    return _then(_self.copyWith(recipient: value));
  });
}/// Create a copy of AdminOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderSlotDtoCopyWith<$Res> get slot {
  
  return $OrderSlotDtoCopyWith<$Res>(_self.slot, (value) {
    return _then(_self.copyWith(slot: value));
  });
}/// Create a copy of AdminOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyBreakdownDtoCopyWith<$Res> get syp {
  
  return $MoneyBreakdownDtoCopyWith<$Res>(_self.syp, (value) {
    return _then(_self.copyWith(syp: value));
  });
}/// Create a copy of AdminOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ZoneDtoCopyWith<$Res>? get zone {
    if (_self.zone == null) {
    return null;
  }

  return $ZoneDtoCopyWith<$Res>(_self.zone!, (value) {
    return _then(_self.copyWith(zone: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminOrderDto].
extension AdminOrderDtoPatterns on AdminOrderDto {
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
