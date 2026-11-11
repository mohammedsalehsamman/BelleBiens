// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_product_dto_designer_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminProductDtoDesignerTemplate {


/// Create a copy of AdminProductDtoDesignerTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductDtoDesignerTemplateCopyWith<AdminProductDtoDesignerTemplate> get copyWith => _$AdminProductDtoDesignerTemplateCopyWithImpl<AdminProductDtoDesignerTemplate>(this as AdminProductDtoDesignerTemplate, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdminProductDtoDesignerTemplate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductDtoDesignerTemplate&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as AdminProductDtoDesignerTemplate;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as AdminProductDtoDesignerTemplate;
  return 'AdminProductDtoDesignerTemplate(additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $AdminProductDtoDesignerTemplateCopyWith<$Res>  {
  factory $AdminProductDtoDesignerTemplateCopyWith(AdminProductDtoDesignerTemplate value, $Res Function(AdminProductDtoDesignerTemplate) _then) = _$AdminProductDtoDesignerTemplateCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: AdminProductDtoDesignerTemplate._extras, fromJson: AdminProductDtoDesignerTemplate._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});




}
/// @nodoc
class _$AdminProductDtoDesignerTemplateCopyWithImpl<$Res>
    implements $AdminProductDtoDesignerTemplateCopyWith<$Res> {
  _$AdminProductDtoDesignerTemplateCopyWithImpl(this._self, this._then);

  final AdminProductDtoDesignerTemplate _self;
  final $Res Function(AdminProductDtoDesignerTemplate) _then;

/// Create a copy of AdminProductDtoDesignerTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? additionalProperties = null,}) {
  return _then(AdminProductDtoDesignerTemplate(
additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductDtoDesignerTemplate].
extension AdminProductDtoDesignerTemplatePatterns on AdminProductDtoDesignerTemplate {
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
