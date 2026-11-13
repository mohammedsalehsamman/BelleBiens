// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'occasion_reminder_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OccasionReminderDto {


/// Create a copy of OccasionReminderDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OccasionReminderDtoCopyWith<OccasionReminderDto> get copyWith => _$OccasionReminderDtoCopyWithImpl<OccasionReminderDto>(this as OccasionReminderDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OccasionReminderDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OccasionReminderDto&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.daysLeft, _this.daysLeft) || other.daysLeft == _this.daysLeft)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.next, _this.next) || other.next == _this.next)&&(identical(other.person, _this.person) || other.person == _this.person)&&(identical(other.remindDaysBefore, _this.remindDaysBefore) || other.remindDaysBefore == _this.remindDaysBefore)&&(identical(other.type2, _this.type2) || other.type2 == _this.type2)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as OccasionReminderDto;
  return Object.hash(runtimeType,_this.date,_this.daysLeft,_this.id,_this.next,_this.person,_this.remindDaysBefore,_this.type2,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as OccasionReminderDto;
  return 'OccasionReminderDto(date: ${_this.date}, daysLeft: ${_this.daysLeft}, id: ${_this.id}, next: ${_this.next}, person: ${_this.person}, remindDaysBefore: ${_this.remindDaysBefore}, type2: ${_this.type2}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $OccasionReminderDtoCopyWith<$Res>  {
  factory $OccasionReminderDtoCopyWith(OccasionReminderDto value, $Res Function(OccasionReminderDto) _then) = _$OccasionReminderDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String date,@JsonKey(required: true, disallowNullValue: true, fromJson: OccasionReminderDto._read_daysLeft, toJson: OccasionReminderDto._write_daysLeft) int daysLeft,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true, disallowNullValue: true) String next,@JsonKey(required: true, disallowNullValue: true) String person,@JsonKey(required: true, disallowNullValue: true, fromJson: OccasionReminderDto._read_remindDaysBefore, toJson: OccasionReminderDto._write_remindDaysBefore) int remindDaysBefore,@JsonKey(name: "type", required: true, disallowNullValue: true, fromJson: OccasionReminderDto._read_type2, toJson: OccasionReminderDto._write_type2) OccasionType type2,@JsonKey(readValue: OccasionReminderDto._extras, fromJson: OccasionReminderDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$OccasionReminderDtoCopyWithImpl<$Res>
    implements $OccasionReminderDtoCopyWith<$Res> {
  _$OccasionReminderDtoCopyWithImpl(this._self, this._then);

  final OccasionReminderDto _self;
  final $Res Function(OccasionReminderDto) _then;

/// Create a copy of OccasionReminderDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? daysLeft = null,Object? id = null,Object? next = null,Object? person = null,Object? remindDaysBefore = null,Object? type2 = null,Object? additionalProperties = null,}) {
  return _then(OccasionReminderDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,daysLeft: null == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,next: null == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as String,remindDaysBefore: null == remindDaysBefore ? _self.remindDaysBefore : remindDaysBefore // ignore: cast_nullable_to_non_nullable
as int,type2: null == type2 ? _self.type2 : type2 // ignore: cast_nullable_to_non_nullable
as OccasionType,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [OccasionReminderDto].
extension OccasionReminderDtoPatterns on OccasionReminderDto {
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
