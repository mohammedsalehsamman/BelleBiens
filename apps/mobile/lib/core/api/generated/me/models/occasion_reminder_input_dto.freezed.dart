// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'occasion_reminder_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OccasionReminderInputDto {


/// Create a copy of OccasionReminderInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OccasionReminderInputDtoCopyWith<OccasionReminderInputDto> get copyWith => _$OccasionReminderInputDtoCopyWithImpl<OccasionReminderInputDto>(this as OccasionReminderInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OccasionReminderInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OccasionReminderInputDto&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.person, _this.person) || other.person == _this.person)&&(identical(other.remindDaysBefore, _this.remindDaysBefore) || other.remindDaysBefore == _this.remindDaysBefore)&&(identical(other.type2, _this.type2) || other.type2 == _this.type2)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as OccasionReminderInputDto;
  return Object.hash(runtimeType,_this.date,_this.person,_this.remindDaysBefore,_this.type2,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as OccasionReminderInputDto;
  return 'OccasionReminderInputDto(date: ${_this.date}, person: ${_this.person}, remindDaysBefore: ${_this.remindDaysBefore}, type2: ${_this.type2}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $OccasionReminderInputDtoCopyWith<$Res>  {
  factory $OccasionReminderInputDtoCopyWith(OccasionReminderInputDto value, $Res Function(OccasionReminderInputDto) _then) = _$OccasionReminderInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String date,@JsonKey(required: true, disallowNullValue: true) String person,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: OccasionReminderInputDto._read_remindDaysBefore, toJson: OccasionReminderInputDto._write_remindDaysBefore) int? remindDaysBefore,@JsonKey(name: "type", required: true, disallowNullValue: true, fromJson: OccasionReminderInputDto._read_type2, toJson: OccasionReminderInputDto._write_type2) OccasionType type2,@JsonKey(readValue: OccasionReminderInputDto._extras, fromJson: OccasionReminderInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$OccasionReminderInputDtoCopyWithImpl<$Res>
    implements $OccasionReminderInputDtoCopyWith<$Res> {
  _$OccasionReminderInputDtoCopyWithImpl(this._self, this._then);

  final OccasionReminderInputDto _self;
  final $Res Function(OccasionReminderInputDto) _then;

/// Create a copy of OccasionReminderInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? person = null,Object? remindDaysBefore = freezed,Object? type2 = null,Object? additionalProperties = null,}) {
  return _then(OccasionReminderInputDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as String,remindDaysBefore: freezed == remindDaysBefore ? _self.remindDaysBefore : remindDaysBefore // ignore: cast_nullable_to_non_nullable
as int?,type2: null == type2 ? _self.type2 : type2 // ignore: cast_nullable_to_non_nullable
as OccasionType,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [OccasionReminderInputDto].
extension OccasionReminderInputDtoPatterns on OccasionReminderInputDto {
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
