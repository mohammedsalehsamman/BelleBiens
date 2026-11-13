// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardDto _$DashboardDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'awaitingConfirmation',
      'date',
      'lowStock',
      'ordersToday',
      'paymentsToCheck',
      'revenueTodayMinor',
      'revenueTodayUsdCents',
    ],
    disallowNullValues: const [
      'awaitingConfirmation',
      'date',
      'lowStock',
      'ordersToday',
      'paymentsToCheck',
      'revenueTodayMinor',
      'revenueTodayUsdCents',
    ],
  );
  return DashboardDto(
    awaitingConfirmation: DashboardDto._read_awaitingConfirmation(
      json['awaitingConfirmation'],
    ),
    date: json['date'] as String,
    lowStock: (json['lowStock'] as List<dynamic>)
        .map((e) => LowStockDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    ordersToday: DashboardDto._read_ordersToday(json['ordersToday']),
    paymentsToCheck: DashboardDto._read_paymentsToCheck(
      json['paymentsToCheck'],
    ),
    revenueTodayMinor: DashboardDto._read_revenueTodayMinor(
      json['revenueTodayMinor'],
    ),
    revenueTodayUsdCents: DashboardDto._read_revenueTodayUsdCents(
      json['revenueTodayUsdCents'],
    ),
    additionalProperties:
        DashboardDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DashboardDto._readExtras(
            DashboardDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DashboardDtoToJson(DashboardDto instance) =>
    <String, dynamic>{
      'awaitingConfirmation': ?DashboardDto._write_awaitingConfirmation(
        instance.awaitingConfirmation,
      ),
      'date': instance.date,
      'lowStock': instance.lowStock.map((e) => e.toJson()).toList(),
      'ordersToday': ?DashboardDto._write_ordersToday(instance.ordersToday),
      'paymentsToCheck': ?DashboardDto._write_paymentsToCheck(
        instance.paymentsToCheck,
      ),
      'revenueTodayMinor': ?DashboardDto._write_revenueTodayMinor(
        instance.revenueTodayMinor,
      ),
      'revenueTodayUsdCents': ?DashboardDto._write_revenueTodayUsdCents(
        instance.revenueTodayUsdCents,
      ),
    };
