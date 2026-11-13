// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardDto {


/// Create a copy of DashboardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDtoCopyWith<DashboardDto> get copyWith => _$DashboardDtoCopyWithImpl<DashboardDto>(this as DashboardDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardDto&&(identical(other.awaitingConfirmation, _this.awaitingConfirmation) || other.awaitingConfirmation == _this.awaitingConfirmation)&&(identical(other.date, _this.date) || other.date == _this.date)&&const DeepCollectionEquality().equals(other.lowStock, _this.lowStock)&&(identical(other.ordersToday, _this.ordersToday) || other.ordersToday == _this.ordersToday)&&(identical(other.paymentsToCheck, _this.paymentsToCheck) || other.paymentsToCheck == _this.paymentsToCheck)&&(identical(other.revenueTodayMinor, _this.revenueTodayMinor) || other.revenueTodayMinor == _this.revenueTodayMinor)&&(identical(other.revenueTodayUsdCents, _this.revenueTodayUsdCents) || other.revenueTodayUsdCents == _this.revenueTodayUsdCents)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as DashboardDto;
  return Object.hash(runtimeType,_this.awaitingConfirmation,_this.date,const DeepCollectionEquality().hash(_this.lowStock),_this.ordersToday,_this.paymentsToCheck,_this.revenueTodayMinor,_this.revenueTodayUsdCents,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as DashboardDto;
  return 'DashboardDto(awaitingConfirmation: ${_this.awaitingConfirmation}, date: ${_this.date}, lowStock: ${_this.lowStock}, ordersToday: ${_this.ordersToday}, paymentsToCheck: ${_this.paymentsToCheck}, revenueTodayMinor: ${_this.revenueTodayMinor}, revenueTodayUsdCents: ${_this.revenueTodayUsdCents}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $DashboardDtoCopyWith<$Res>  {
  factory $DashboardDtoCopyWith(DashboardDto value, $Res Function(DashboardDto) _then) = _$DashboardDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true, fromJson: DashboardDto._read_awaitingConfirmation, toJson: DashboardDto._write_awaitingConfirmation) int awaitingConfirmation,@JsonKey(required: true, disallowNullValue: true) String date,@JsonKey(required: true, disallowNullValue: true) List<LowStockDto> lowStock,@JsonKey(required: true, disallowNullValue: true, fromJson: DashboardDto._read_ordersToday, toJson: DashboardDto._write_ordersToday) int ordersToday,@JsonKey(required: true, disallowNullValue: true, fromJson: DashboardDto._read_paymentsToCheck, toJson: DashboardDto._write_paymentsToCheck) int paymentsToCheck,@JsonKey(required: true, disallowNullValue: true, fromJson: DashboardDto._read_revenueTodayMinor, toJson: DashboardDto._write_revenueTodayMinor) int revenueTodayMinor,@JsonKey(required: true, disallowNullValue: true, fromJson: DashboardDto._read_revenueTodayUsdCents, toJson: DashboardDto._write_revenueTodayUsdCents) int revenueTodayUsdCents,@JsonKey(readValue: DashboardDto._extras, fromJson: DashboardDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$DashboardDtoCopyWithImpl<$Res>
    implements $DashboardDtoCopyWith<$Res> {
  _$DashboardDtoCopyWithImpl(this._self, this._then);

  final DashboardDto _self;
  final $Res Function(DashboardDto) _then;

/// Create a copy of DashboardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? awaitingConfirmation = null,Object? date = null,Object? lowStock = null,Object? ordersToday = null,Object? paymentsToCheck = null,Object? revenueTodayMinor = null,Object? revenueTodayUsdCents = null,Object? additionalProperties = null,}) {
  return _then(DashboardDto(
awaitingConfirmation: null == awaitingConfirmation ? _self.awaitingConfirmation : awaitingConfirmation // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,lowStock: null == lowStock ? _self.lowStock : lowStock // ignore: cast_nullable_to_non_nullable
as List<LowStockDto>,ordersToday: null == ordersToday ? _self.ordersToday : ordersToday // ignore: cast_nullable_to_non_nullable
as int,paymentsToCheck: null == paymentsToCheck ? _self.paymentsToCheck : paymentsToCheck // ignore: cast_nullable_to_non_nullable
as int,revenueTodayMinor: null == revenueTodayMinor ? _self.revenueTodayMinor : revenueTodayMinor // ignore: cast_nullable_to_non_nullable
as int,revenueTodayUsdCents: null == revenueTodayUsdCents ? _self.revenueTodayUsdCents : revenueTodayUsdCents // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardDto].
extension DashboardDtoPatterns on DashboardDto {
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
