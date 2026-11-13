// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_design_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedDesignInputDto {


/// Create a copy of SavedDesignInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedDesignInputDtoCopyWith<SavedDesignInputDto> get copyWith => _$SavedDesignInputDtoCopyWithImpl<SavedDesignInputDto>(this as SavedDesignInputDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SavedDesignInputDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedDesignInputDto&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.previewUrl, _this.previewUrl) || other.previewUrl == _this.previewUrl)&&(identical(other.spec, _this.spec) || other.spec == _this.spec)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as SavedDesignInputDto;
  return Object.hash(runtimeType,_this.name,_this.previewUrl,_this.spec,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as SavedDesignInputDto;
  return 'SavedDesignInputDto(name: ${_this.name}, previewUrl: ${_this.previewUrl}, spec: ${_this.spec}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $SavedDesignInputDtoCopyWith<$Res>  {
  factory $SavedDesignInputDtoCopyWith(SavedDesignInputDto value, $Res Function(SavedDesignInputDto) _then) = _$SavedDesignInputDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String name,@JsonKey(disallowNullValue: true, includeIfNull: false) String? previewUrl,@JsonKey(required: true, disallowNullValue: true) SavedDesignInputDtoSpec spec,@JsonKey(readValue: SavedDesignInputDto._extras, fromJson: SavedDesignInputDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$SavedDesignInputDtoSpecCopyWith<$Res> get spec;

}
/// @nodoc
class _$SavedDesignInputDtoCopyWithImpl<$Res>
    implements $SavedDesignInputDtoCopyWith<$Res> {
  _$SavedDesignInputDtoCopyWithImpl(this._self, this._then);

  final SavedDesignInputDto _self;
  final $Res Function(SavedDesignInputDto) _then;

/// Create a copy of SavedDesignInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? previewUrl = freezed,Object? spec = null,Object? additionalProperties = null,}) {
  return _then(SavedDesignInputDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,spec: null == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as SavedDesignInputDtoSpec,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of SavedDesignInputDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SavedDesignInputDtoSpecCopyWith<$Res> get spec {
  
  return $SavedDesignInputDtoSpecCopyWith<$Res>(_self.spec, (value) {
    return _then(_self.copyWith(spec: value));
  });
}
}


/// Adds pattern-matching-related methods to [SavedDesignInputDto].
extension SavedDesignInputDtoPatterns on SavedDesignInputDto {
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
