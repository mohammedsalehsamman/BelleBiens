// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option_group_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OptionGroupInputDto {


/// Create a copy of OptionGroupInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionGroupInputDtoCopyWith<OptionGroupInputDto> get copyWith => _$OptionGroupInputDtoCopyWithImpl<OptionGroupInputDto>(this as OptionGroupInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OptionGroupInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptionGroupInputDto&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.nameEn, _this.nameEn) || other.nameEn == _this.nameEn)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.required2, _this.required2) || other.required2 == _this.required2)&&(identical(other.selection, _this.selection) || other.selection == _this.selection)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as OptionGroupInputDto;
  return Object.hash(runtimeType,_this.key,_this.nameAr,_this.nameEn,const DeepCollectionEquality().hash(_this.options),_this.required2,_this.selection,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as OptionGroupInputDto;
  return 'OptionGroupInputDto(key: ${_this.key}, nameAr: ${_this.nameAr}, nameEn: ${_this.nameEn}, options: ${_this.options}, required2: ${_this.required2}, selection: ${_this.selection}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $OptionGroupInputDtoCopyWith<$Res>  {
  factory $OptionGroupInputDtoCopyWith(OptionGroupInputDto value, $Res Function(OptionGroupInputDto) _then) = _$OptionGroupInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String key,@JsonKey(required: true, disallowNullValue: true) String nameAr,@JsonKey(required: true, disallowNullValue: true) String nameEn,@JsonKey(required: true, disallowNullValue: true) List<OptionInputDto> options,@JsonKey(name: "required", disallowNullValue: true, readValue: OptionGroupInputDto._presentValue, fromJson: OptionGroupInputDto._read_required2, toJson: OptionGroupInputDto._write_required2) bool required2,@JsonKey(disallowNullValue: true, readValue: OptionGroupInputDto._presentValue, fromJson: OptionGroupInputDto._read_selection, toJson: OptionGroupInputDto._write_selection) OptionGroupInputDtoSelection selection,@JsonKey(readValue: OptionGroupInputDto._extras, fromJson: OptionGroupInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$OptionGroupInputDtoCopyWithImpl<$Res>
    implements $OptionGroupInputDtoCopyWith<$Res> {
  _$OptionGroupInputDtoCopyWithImpl(this._self, this._then);

  final OptionGroupInputDto _self;
  final $Res Function(OptionGroupInputDto) _then;

/// Create a copy of OptionGroupInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? nameAr = null,Object? nameEn = null,Object? options = null,Object? required2 = null,Object? selection = null,Object? additionalProperties = null,}) {
  return _then(OptionGroupInputDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<OptionInputDto>,required2: null == required2 ? _self.required2 : required2 // ignore: cast_nullable_to_non_nullable
as bool,selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as OptionGroupInputDtoSelection,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [OptionGroupInputDto].
extension OptionGroupInputDtoPatterns on OptionGroupInputDto {
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
