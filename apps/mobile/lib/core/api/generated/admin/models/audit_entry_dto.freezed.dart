// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_entry_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuditEntryDto {


/// Create a copy of AuditEntryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryDtoCopyWith<AuditEntryDto> get copyWith => _$AuditEntryDtoCopyWithImpl<AuditEntryDto>(this as AuditEntryDto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AuditEntryDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntryDto&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.actorId, _this.actorId) || other.actorId == _this.actorId)&&(identical(other.actorRole, _this.actorRole) || other.actorRole == _this.actorRole)&&(identical(other.after, _this.after) || other.after == _this.after)&&(identical(other.before, _this.before) || other.before == _this.before)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.entity, _this.entity) || other.entity == _this.entity)&&(identical(other.entityId, _this.entityId) || other.entityId == _this.entityId)&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.additionalProperties, _this.additionalProperties));
}


@override
int get hashCode {
  final _this = this as AuditEntryDto;
  return Object.hash(runtimeType,_this.action,_this.actorId,_this.actorRole,_this.after,_this.before,_this.createdAt,_this.entity,_this.entityId,_this.id,const DeepCollectionEquality().hash(_this.additionalProperties));
}

@override
String toString() {
  final _this = this as AuditEntryDto;
  return 'AuditEntryDto(action: ${_this.action}, actorId: ${_this.actorId}, actorRole: ${_this.actorRole}, after: ${_this.after}, before: ${_this.before}, createdAt: ${_this.createdAt}, entity: ${_this.entity}, entityId: ${_this.entityId}, id: ${_this.id}, additionalProperties: ${_this.additionalProperties})';
}


}

/// @nodoc
abstract mixin class $AuditEntryDtoCopyWith<$Res>  {
  factory $AuditEntryDtoCopyWith(AuditEntryDto value, $Res Function(AuditEntryDto) _then) = _$AuditEntryDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(required: true, disallowNullValue: true) String action,@JsonKey(required: true) String? actorId,@JsonKey(required: true, disallowNullValue: true, fromJson: AuditEntryDto._read_actorRole, toJson: AuditEntryDto._write_actorRole) AuditEntryDtoActorRole actorRole,@JsonKey(required: true) AuditEntryDtoAfter? after,@JsonKey(required: true) AuditEntryDtoBefore? before,@JsonKey(required: true, disallowNullValue: true, fromJson: AuditEntryDto._read_createdAt, toJson: AuditEntryDto._write_createdAt) DateTime createdAt,@JsonKey(required: true, disallowNullValue: true) String entity,@JsonKey(required: true) String? entityId,@JsonKey(required: true, disallowNullValue: true) String id,@JsonKey(readValue: AuditEntryDto._extras, fromJson: AuditEntryDto._readExtras, includeToJson: false) Map<String, Object?> additionalProperties
});


$AuditEntryDtoAfterCopyWith<$Res>? get after;$AuditEntryDtoBeforeCopyWith<$Res>? get before;

}
/// @nodoc
class _$AuditEntryDtoCopyWithImpl<$Res>
    implements $AuditEntryDtoCopyWith<$Res> {
  _$AuditEntryDtoCopyWithImpl(this._self, this._then);

  final AuditEntryDto _self;
  final $Res Function(AuditEntryDto) _then;

/// Create a copy of AuditEntryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? actorId = freezed,Object? actorRole = null,Object? after = freezed,Object? before = freezed,Object? createdAt = null,Object? entity = null,Object? entityId = freezed,Object? id = null,Object? additionalProperties = null,}) {
  return _then(AuditEntryDto(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,actorRole: null == actorRole ? _self.actorRole : actorRole // ignore: cast_nullable_to_non_nullable
as AuditEntryDtoActorRole,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as AuditEntryDtoAfter?,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as AuditEntryDtoBefore?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,additionalProperties: null == additionalProperties ? _self.additionalProperties : additionalProperties // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of AuditEntryDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuditEntryDtoAfterCopyWith<$Res>? get after {
    if (_self.after == null) {
    return null;
  }

  return $AuditEntryDtoAfterCopyWith<$Res>(_self.after!, (value) {
    return _then(_self.copyWith(after: value));
  });
}/// Create a copy of AuditEntryDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuditEntryDtoBeforeCopyWith<$Res>? get before {
    if (_self.before == null) {
    return null;
  }

  return $AuditEntryDtoBeforeCopyWith<$Res>(_self.before!, (value) {
    return _then(_self.copyWith(before: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuditEntryDto].
extension AuditEntryDtoPatterns on AuditEntryDto {
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
