// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_design_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedDesignDto {


/// Create a copy of SavedDesignDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedDesignDtoCopyWith<SavedDesignDto> get copyWith => _$SavedDesignDtoCopyWithImpl<SavedDesignDto>(this as SavedDesignDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SavedDesignDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedDesignDto&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.previewUrl, _this.previewUrl) || other.previewUrl == _this.previewUrl)&&(identical(other.priceMinor, _this.priceMinor) || other.priceMinor == _this.priceMinor)&&(identical(other.spec, _this.spec) || other.spec == _this.spec)&&(identical(other.stems, _this.stems) || other.stems == _this.stems)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.wrap, _this.wrap) || other.wrap == _this.wrap)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as SavedDesignDto;
  return Object.hash(runtimeType,_this.available,_this.id,_this.name,_this.previewUrl,_this.priceMinor,_this.spec,_this.stems,_this.updatedAt,_this.wrap,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as SavedDesignDto;
  return 'SavedDesignDto(available: ${_this.available}, id: ${_this.id}, name: ${_this.name}, previewUrl: ${_this.previewUrl}, priceMinor: ${_this.priceMinor}, spec: ${_this.spec}, stems: ${_this.stems}, updatedAt: ${_this.updatedAt}, wrap: ${_this.wrap}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $SavedDesignDtoCopyWith<$Res>  {
  factory $SavedDesignDtoCopyWith(SavedDesignDto value, $Res Function(SavedDesignDto) _then) = _$SavedDesignDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) bool available,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(required: true, disallowNullValue: true) String name,@JsonKey(disallowNullValue: true, includeIfNull: false) String? previewUrl,@JsonKey(required: true, disallowNullValue: true, fromJson: SavedDesignDto._read_priceMinor, toJson: SavedDesignDto._write_priceMinor) int priceMinor,@JsonKey(required: true, disallowNullValue: true) SavedDesignDtoSpec spec,@JsonKey(required: true, disallowNullValue: true, fromJson: SavedDesignDto._read_stems, toJson: SavedDesignDto._write_stems) int stems,@JsonKey(required: true, disallowNullValue: true, fromJson: SavedDesignDto._read_updatedAt, toJson: SavedDesignDto._write_updatedAt) DateTime updatedAt,@JsonKey(disallowNullValue: true, includeIfNull: false) LocalizedTextDto? wrap,@JsonKey(readValue: SavedDesignDto._extras, fromJson: SavedDesignDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$SavedDesignDtoSpecCopyWith<$Res> get spec;$LocalizedTextDtoCopyWith<$Res>? get wrap;

}
/// @nodoc
class _$SavedDesignDtoCopyWithImpl<$Res>
    implements $SavedDesignDtoCopyWith<$Res> {
  _$SavedDesignDtoCopyWithImpl(this._self, this._then);

  final SavedDesignDto _self;
  final $Res Function(SavedDesignDto) _then;

/// Create a copy of SavedDesignDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? id = null,Object? name = null,Object? previewUrl = freezed,Object? priceMinor = null,Object? spec = null,Object? stems = null,Object? updatedAt = null,Object? wrap = freezed,Object? additionalProperties = null,}) {
  return _then(SavedDesignDto(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,spec: null == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as SavedDesignDtoSpec,stems: null == stems ? _self.stems : stems // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,wrap: freezed == wrap ? _self.wrap : wrap // ignore: cast_nullable_to_non_nullable
as LocalizedTextDto?,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of SavedDesignDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SavedDesignDtoSpecCopyWith<$Res> get spec {
  
  return $SavedDesignDtoSpecCopyWith<$Res>(_self.spec, (value) {
    return _then(_self.copyWith(spec: value));
  });
}/// Create a copy of SavedDesignDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextDtoCopyWith<$Res>? get wrap {
    if (_self.wrap == null) {
    return null;
  }

  return $LocalizedTextDtoCopyWith<$Res>(_self.wrap!, (value) {
    return _then(_self.copyWith(wrap: value));
  });
}
}


/// Adds pattern-matching-related methods to [SavedDesignDto].
extension SavedDesignDtoPatterns on SavedDesignDto {
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
