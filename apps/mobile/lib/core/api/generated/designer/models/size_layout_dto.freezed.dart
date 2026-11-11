// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'size_layout_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SizeLayoutDto {


/// Create a copy of SizeLayoutDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeLayoutDtoCopyWith<SizeLayoutDto> get copyWith => _$SizeLayoutDtoCopyWithImpl<SizeLayoutDto>(this as SizeLayoutDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SizeLayoutDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeLayoutDto&&const DeepCollectionEquality().equals(other.extras, _this.extras)&&const DeepCollectionEquality().equals(other.flowers, _this.flowers)&&const DeepCollectionEquality().equals(other.greens, _this.greens)&&(identical(other.ribbon, _this.ribbon) || other.ribbon == _this.ribbon)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.wrapBack, _this.wrapBack) || other.wrapBack == _this.wrapBack)&&(identical(other.wrapFront, _this.wrapFront) || other.wrapFront == _this.wrapFront)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as SizeLayoutDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.extras),const DeepCollectionEquality().hash(_this.flowers),const DeepCollectionEquality().hash(_this.greens),_this.ribbon,_this.size,_this.wrapBack,_this.wrapFront,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as SizeLayoutDto;
  return 'SizeLayoutDto(extras: ${_this.extras}, flowers: ${_this.flowers}, greens: ${_this.greens}, ribbon: ${_this.ribbon}, size: ${_this.size}, wrapBack: ${_this.wrapBack}, wrapFront: ${_this.wrapFront}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $SizeLayoutDtoCopyWith<$Res>  {
  factory $SizeLayoutDtoCopyWith(SizeLayoutDto value, $Res Function(SizeLayoutDto) _then) = _$SizeLayoutDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) List<SlotDto> extras,@JsonKey(required: true, disallowNullValue: true) List<SlotDto> flowers,@JsonKey(required: true, disallowNullValue: true) List<SlotDto> greens,@JsonKey(required: true, disallowNullValue: true) SlotDto ribbon,@JsonKey(required: true, disallowNullValue: true, fromJson: SizeLayoutDto._read_size, toJson: SizeLayoutDto._write_size) BouquetSize size,@JsonKey(required: true, disallowNullValue: true) SlotDto wrapBack,@JsonKey(required: true, disallowNullValue: true) SlotDto wrapFront,@JsonKey(readValue: SizeLayoutDto._extras, fromJson: SizeLayoutDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$SlotDtoCopyWith<$Res> get ribbon;$SlotDtoCopyWith<$Res> get wrapBack;$SlotDtoCopyWith<$Res> get wrapFront;

}
/// @nodoc
class _$SizeLayoutDtoCopyWithImpl<$Res>
    implements $SizeLayoutDtoCopyWith<$Res> {
  _$SizeLayoutDtoCopyWithImpl(this._self, this._then);

  final SizeLayoutDto _self;
  final $Res Function(SizeLayoutDto) _then;

/// Create a copy of SizeLayoutDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? extras = null,Object? flowers = null,Object? greens = null,Object? ribbon = null,Object? size = null,Object? wrapBack = null,Object? wrapFront = null,Object? additionalProperties = null,}) {
  return _then(SizeLayoutDto(
extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as List<SlotDto>,flowers: null == flowers ? _self.flowers : flowers // ignore: cast_nullable_to_non_nullable
as List<SlotDto>,greens: null == greens ? _self.greens : greens // ignore: cast_nullable_to_non_nullable
as List<SlotDto>,ribbon: null == ribbon ? _self.ribbon : ribbon // ignore: cast_nullable_to_non_nullable
as SlotDto,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as BouquetSize,wrapBack: null == wrapBack ? _self.wrapBack : wrapBack // ignore: cast_nullable_to_non_nullable
as SlotDto,wrapFront: null == wrapFront ? _self.wrapFront : wrapFront // ignore: cast_nullable_to_non_nullable
as SlotDto,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of SizeLayoutDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotDtoCopyWith<$Res> get ribbon {
  
  return $SlotDtoCopyWith<$Res>(_self.ribbon, (value) {
    return _then(_self.copyWith(ribbon: value));
  });
}/// Create a copy of SizeLayoutDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotDtoCopyWith<$Res> get wrapBack {
  
  return $SlotDtoCopyWith<$Res>(_self.wrapBack, (value) {
    return _then(_self.copyWith(wrapBack: value));
  });
}/// Create a copy of SizeLayoutDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotDtoCopyWith<$Res> get wrapFront {
  
  return $SlotDtoCopyWith<$Res>(_self.wrapFront, (value) {
    return _then(_self.copyWith(wrapFront: value));
  });
}
}


/// Adds pattern-matching-related methods to [SizeLayoutDto].
extension SizeLayoutDtoPatterns on SizeLayoutDto {
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
