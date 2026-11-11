// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_issue_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuoteIssueDto {


/// Create a copy of QuoteIssueDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteIssueDtoCopyWith<QuoteIssueDto> get copyWith => _$QuoteIssueDtoCopyWithImpl<QuoteIssueDto>(this as QuoteIssueDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuoteIssueDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteIssueDto&&const DeepCollectionEquality().equals(other.alternatives, _this.alternatives)&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.max, _this.max) || other.max == _this.max)&&(identical(other.min, _this.min) || other.min == _this.min)&&(identical(other.requested, _this.requested) || other.requested == _this.requested)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as QuoteIssueDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.alternatives),_this.available,_this.code,_this.itemId,_this.max,_this.min,_this.requested,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as QuoteIssueDto;
  return 'QuoteIssueDto(alternatives: ${_this.alternatives}, available: ${_this.available}, code: ${_this.code}, itemId: ${_this.itemId}, max: ${_this.max}, min: ${_this.min}, requested: ${_this.requested}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $QuoteIssueDtoCopyWith<$Res>  {
  factory $QuoteIssueDtoCopyWith(QuoteIssueDto value, $Res Function(QuoteIssueDto) _then) = _$QuoteIssueDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false) List<AlternativeDto>? alternatives,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: QuoteIssueDto._read_available, toJson: QuoteIssueDto._write_available) int? available,@JsonKey(required: true, disallowNullValue: true, fromJson: QuoteIssueDto._read_code, toJson: QuoteIssueDto._write_code) QuoteIssueCode code,@JsonKey(disallowNullValue: true, includeIfNull: false) String? itemId,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: QuoteIssueDto._read_max, toJson: QuoteIssueDto._write_max) int? max,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: QuoteIssueDto._read_min, toJson: QuoteIssueDto._write_min) int? min,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: QuoteIssueDto._read_requested, toJson: QuoteIssueDto._write_requested) int? requested,@JsonKey(readValue: QuoteIssueDto._extras, fromJson: QuoteIssueDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$QuoteIssueDtoCopyWithImpl<$Res>
    implements $QuoteIssueDtoCopyWith<$Res> {
  _$QuoteIssueDtoCopyWithImpl(this._self, this._then);

  final QuoteIssueDto _self;
  final $Res Function(QuoteIssueDto) _then;

/// Create a copy of QuoteIssueDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? alternatives = freezed,Object? available = freezed,Object? code = null,Object? itemId = freezed,Object? max = freezed,Object? min = freezed,Object? requested = freezed,Object? additionalProperties = null,}) {
  return _then(QuoteIssueDto(
alternatives: freezed == alternatives ? _self.alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<AlternativeDto>?,available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as QuoteIssueCode,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int?,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int?,requested: freezed == requested ? _self.requested : requested // ignore: cast_nullable_to_non_nullable
as int?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuoteIssueDto].
extension QuoteIssueDtoPatterns on QuoteIssueDto {
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
