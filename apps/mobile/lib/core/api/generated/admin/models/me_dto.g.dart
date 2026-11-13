// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeDto _$MeDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'createdAt',
      'email',
      'homeArea',
      'id',
      'language',
      'marketingOptIn',
      'name',
      'notifyOccasions',
      'notifyWhatsapp',
      'numerals',
      'phone',
      'profileComplete',
      'role',
      'termsAccepted',
    ],
    disallowNullValues: const [
      'createdAt',
      'id',
      'language',
      'marketingOptIn',
      'name',
      'notifyOccasions',
      'notifyWhatsapp',
      'numerals',
      'profileComplete',
      'role',
      'termsAccepted',
    ],
  );
  return MeDto(
    createdAt: MeDto._read_createdAt(json['createdAt']),
    email: json['email'] as String?,
    homeArea: json['homeArea'] as String?,
    id: json['id'] as String,
    language: MeDto._read_language(json['language']),
    marketingOptIn: json['marketingOptIn'] as bool,
    name: json['name'] as String,
    notifyOccasions: json['notifyOccasions'] as bool,
    notifyWhatsapp: json['notifyWhatsapp'] as bool,
    numerals: MeDto._read_numerals(json['numerals']),
    phone: json['phone'] as String?,
    profileComplete: json['profileComplete'] as bool,
    role: MeDto._read_role(json['role']),
    termsAccepted: json['termsAccepted'] as bool,
    additionalProperties: MeDto._extras(json, 'additionalProperties') == null
        ? const {}
        : MeDto._readExtras(MeDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$MeDtoToJson(MeDto instance) => <String, dynamic>{
  'createdAt': ?MeDto._write_createdAt(instance.createdAt),
  'email': instance.email,
  'homeArea': instance.homeArea,
  'id': instance.id,
  'language': ?MeDto._write_language(instance.language),
  'marketingOptIn': instance.marketingOptIn,
  'name': instance.name,
  'notifyOccasions': instance.notifyOccasions,
  'notifyWhatsapp': instance.notifyWhatsapp,
  'numerals': ?MeDto._write_numerals(instance.numerals),
  'phone': instance.phone,
  'profileComplete': instance.profileComplete,
  'role': ?MeDto._write_role(instance.role),
  'termsAccepted': instance.termsAccepted,
};
