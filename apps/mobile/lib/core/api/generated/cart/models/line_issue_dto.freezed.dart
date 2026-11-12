// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'line_issue_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LineIssueDto {


/// Create a copy of LineIssueDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LineIssueDtoCopyWith<LineIssueDto> get copyWith => _$LineIssueDtoCopyWithImpl<LineIssueDto>(this as LineIssueDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LineIssueDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineIssueDto&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.requested, _this.requested) || other.requested == _this.requested)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as LineIssueDto;
  return Object.hash(runtimeType,_this.available,_this.code,_this.itemId,_this.requested,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as LineIssueDto;
  return 'LineIssueDto(available: ${_this.available}, code: ${_this.code}, itemId: ${_this.itemId}, requested: ${_this.requested}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $LineIssueDtoCopyWith<$Res>  {
  factory $LineIssueDtoCopyWith(LineIssueDto value, $Res Function(LineIssueDto) _then) = _$LineIssueDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: LineIssueDto._read_available, toJson: LineIssueDto._write_available) int? available,@JsonKey(required: true, disallowNullValue: true, fromJson: LineIssueDto._read_code, toJson: LineIssueDto._write_code) CartIssueCode code,@JsonKey(disallowNullValue: true, includeIfNull: false) String? itemId,@JsonKey(disallowNullValue: true, includeIfNull: false, fromJson: LineIssueDto._read_requested, toJson: LineIssueDto._write_requested) int? requested,@JsonKey(readValue: LineIssueDto._extras, fromJson: LineIssueDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$LineIssueDtoCopyWithImpl<$Res>
    implements $LineIssueDtoCopyWith<$Res> {
  _$LineIssueDtoCopyWithImpl(this._self, this._then);

  final LineIssueDto _self;
  final $Res Function(LineIssueDto) _then;

/// Create a copy of LineIssueDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = freezed,Object? code = null,Object? itemId = freezed,Object? requested = freezed,Object? additionalProperties = null,}) {
  return _then(LineIssueDto(
available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as CartIssueCode,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,requested: freezed == requested ? _self.requested : requested // ignore: cast_nullable_to_non_nullable
as int?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [LineIssueDto].
extension LineIssueDtoPatterns on LineIssueDto {
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
