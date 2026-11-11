// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'designer_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DesignerItemDto {


/// Create a copy of DesignerItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DesignerItemDtoCopyWith<DesignerItemDto> get copyWith => _$DesignerItemDtoCopyWithImpl<DesignerItemDto>(this as DesignerItemDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DesignerItemDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DesignerItemDto&&(identical(other.available, _this.available) || other.available == _this.available)&&const DeepCollectionEquality().equals(other.colorTags, _this.colorTags)&&(identical(other.cutoutUrl, _this.cutoutUrl) || other.cutoutUrl == _this.cutoutUrl)&&(identical(other.detail, _this.detail) || other.detail == _this.detail)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.limited, _this.limited) || other.limited == _this.limited)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.swatch, _this.swatch) || other.swatch == _this.swatch)&&(identical(other.type2, _this.type2) || other.type2 == _this.type2)&&(identical(other.unitPriceMinor, _this.unitPriceMinor) || other.unitPriceMinor == _this.unitPriceMinor)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as DesignerItemDto;
  return Object.hash(runtimeType,_this.available,const DeepCollectionEquality().hash(_this.colorTags),_this.cutoutUrl,_this.detail,_this.id,_this.limited,_this.name,_this.swatch,_this.type2,_this.unitPriceMinor,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as DesignerItemDto;
  return 'DesignerItemDto(available: ${_this.available}, colorTags: ${_this.colorTags}, cutoutUrl: ${_this.cutoutUrl}, detail: ${_this.detail}, id: ${_this.id}, limited: ${_this.limited}, name: ${_this.name}, swatch: ${_this.swatch}, type2: ${_this.type2}, unitPriceMinor: ${_this.unitPriceMinor}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $DesignerItemDtoCopyWith<$Res>  {
  factory $DesignerItemDtoCopyWith(DesignerItemDto value, $Res Function(DesignerItemDto) _then) = _$DesignerItemDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, fromJson: DesignerItemDto._read_available, toJson: DesignerItemDto._write_available) int? available,@JsonKey(required: true, disallowNullValue: true) List<String> colorTags,@JsonKey(required: true) String? cutoutUrl,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto detail,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true, disallowNullValue: true) bool limited,@JsonKey(required: true, disallowNullValue: true) LocalizedTextDto name,@JsonKey(required: true) String? swatch,@JsonKey(name: "type", required: true, disallowNullValue: true, fromJson: DesignerItemDto._read_type2, toJson: DesignerItemDto._write_type2) DesignerPart type2,@JsonKey(required: true, disallowNullValue: true, fromJson: DesignerItemDto._read_unitPriceMinor, toJson: DesignerItemDto._write_unitPriceMinor) int unitPriceMinor,@JsonKey(readValue: DesignerItemDto._extras, fromJson: DesignerItemDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$LocalizedTextDtoCopyWith<$Res> get detail;$LocalizedTextDtoCopyWith<$Res> get name;

}
/// @nodoc
class _$DesignerItemDtoCopyWithImpl<$Res>
    implements $DesignerItemDtoCopyWith<$Res> {
  _$DesignerItemDtoCopyWithImpl(this._self, this._then);

  final DesignerItemDto _self;
  final $Res Function(DesignerItemDto) _then;

/// Create a copy of DesignerItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = freezed,Object? colorTags = null,Object? cutoutUrl = freezed,Object? detail = null,Object? id = null,Object? limited = null,Object? name = null,Object? swatch = freezed,Object? type2 = null,Object? unitPriceMinor = null,Object? additionalProperties = null,}) {
  return _then(DesignerItemDto(
available: freezed == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int?,colorTags: null == colorTags ? _self.colorTags : colorTags // ignore: cast_nullable_to_non_nullable
as List<String>,cutoutUrl: freezed == cutoutUrl ? _self.cutoutUrl : cutoutUrl // ignore: cast_nullable_to_non_nullable
as String?,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,limited: null == limited ? _self.limited : limited // ignore: cast_nullable_to_non_nullable
as bool,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto,swatch: freezed == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as String?,type2: null == type2 ? _self.type2 : type2 // ignore: cast_nullable_to_non_nullable
as DesignerPart,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of DesignerItemDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get detail {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.detail, (value) {
    return _then(_self.copyWith(detail: value));
  });
}/// Create a copy of DesignerItemDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res> get name {
  
  return $LocalizedTextDtoCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}
}


/// Adds pattern-matching-related methods to [DesignerItemDto].
extension DesignerItemDtoPatterns on DesignerItemDto {
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
