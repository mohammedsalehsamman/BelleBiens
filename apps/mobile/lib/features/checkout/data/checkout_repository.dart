import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/storage/json_cache.dart';

/// An order placed on this phone without an account, found again later with
/// its number and phone (FR-ORD-04; the "طلباتي" tab lists them in S6).
typedef GuestOrder = ({String number, String phone});

/// Delivery and order calls for checkout (screens 21-25, 36).
class CheckoutRepository {
  new(this._api, this._cache);

  final BelleApi _api;
  final JsonCache _cache;

  static const guestOrdersKey = 'orders:guest';

  Future<List<ZoneWithAreaDto>> zones() =>
      guardApi(_api.delivery.deliveryControllerZones);

  Future<ZoneCheckDto> zoneCheck(double latitude, double longitude) => guardApi(
    () => _api.delivery.deliveryControllerZoneCheck(
      body: PointDto(latitude: latitude, longitude: longitude),
    ),
  );

  Future<DeliveryCalendarDto> calendar(
    int leadTimeHours,
    Fulfillment fulfillment,
  ) => guardApi(
    () => _api.delivery.deliveryControllerDates(
      leadTimeHours: leadTimeHours,
      fulfillment: fulfillment,
    ),
  );

  Future<DaySlotsDto> slots(
    String date,
    int leadTimeHours,
    Fulfillment fulfillment,
  ) => guardApi(
    () => _api.delivery.deliveryControllerSlots(
      date: date,
      leadTimeHours: leadTimeHours,
      fulfillment: fulfillment,
    ),
  );

  /// Keeps the slot for a few minutes while the customer pays (FR-DLV-04).
  Future<SlotHoldDto> hold(String date, String start, int leadTimeHours) =>
      guardApi(
        () => _api.delivery.deliveryControllerHold(
          body: SlotHoldRequestDto(
            date: date,
            start: start,
            leadTimeHours: leadTimeHours,
          ),
        ),
      );

  Future<List<AddressDto>> savedAddresses() =>
      guardApi(_api.me.addressesControllerList);

  /// FR-CRT-10: a retry sends the same key, so it never orders twice.
  Future<OrderDto> place(CreateOrderDto order, String idempotencyKey) =>
      guardApi(
        () => _api.orders.ordersControllerCreate(
          idempotencyKey: idempotencyKey,
          body: order,
        ),
      );

  Future<List<GuestOrder>> guestOrders() async {
    final json = (await _cache.read(guestOrdersKey))?.json;
    if (json is! List) return const [];
    return [
      for (final item in json)
        if (item is Map && item['number'] is String && item['phone'] is String)
          (number: item['number'] as String, phone: item['phone'] as String),
    ];
  }

  Future<void> rememberGuestOrder(GuestOrder order) async {
    final orders = [
      order,
      for (final o in await guestOrders())
        if (o.number != order.number) o,
    ];
    await _cache.write(guestOrdersKey, [
      for (final o in orders.take(50)) {'number': o.number, 'phone': o.phone},
    ], savedAt: DateTime.now());
  }
}
