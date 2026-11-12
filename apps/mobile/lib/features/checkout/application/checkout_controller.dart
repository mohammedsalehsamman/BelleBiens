import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/cart/application/cart_controller.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/checkout/data/checkout_repository.dart';
import 'package:belle_biens/features/checkout/domain/checkout_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

final checkoutRepositoryProvider = Provider<CheckoutRepository>(
  (ref) => CheckoutRepository(
    ref.watch(belleApiProvider),
    ref.watch(jsonCacheProvider),
  ),
);

/// What the customer chose on screens 21-23. Starts with the signed-in
/// customer's name and phone; cleared once the order is placed.
class CheckoutController extends Notifier<CheckoutDraft> {
  @override
  CheckoutDraft build() {
    final user = ref.read(sessionControllerProvider).value?.user;
    return CheckoutDraft(
      idempotencyKey: newIdempotencyKey(),
      customerName: user?.name ?? '',
      customerPhone: user?.phone ?? '',
    );
  }

  /// Any other field: name, phone, recipient, notes, payment.
  void edit(CheckoutDraft Function(CheckoutDraft) change) =>
      state = change(state);

  void fulfillment(Fulfillment value) => state = state.copyWith(
    fulfillment: value,
    // Pickup has its own calendar: no slot capacity (FR-DLV-08).
    slotStart: () => null,
    slotEnd: () => null,
    holdId: () => null,
  );

  void address(DraftAddress? value) =>
      state = state.copyWith(address: () => value);

  void day(String date) => state = state.copyWith(
    date: () => date,
    slotStart: () => null,
    slotEnd: () => null,
    holdId: () => null,
  );

  void slot(String start, String end) => state = state.copyWith(
    slotStart: () => start,
    slotEnd: () => end,
    holdId: () => null,
  );

  /// FR-DLV-04: keeps the chosen delivery slot while the customer pays.
  Future<void> holdSlot(int leadTimeHours) async {
    final d = state;
    if (!d.delivery || d.date == null || d.slotStart == null) return;
    final hold = await ref
        .read(checkoutRepositoryProvider)
        .hold(d.date!, d.slotStart!, leadTimeHours);
    state = state.copyWith(holdId: () => hold.id);
  }

  /// Places the order with the checkout's key, then empties the cart.
  Future<OrderDto> place() async {
    final lines = await ref.read(cartControllerProvider.future);
    final coupon = ref.read(couponProvider);
    final repo = ref.read(checkoutRepositoryProvider);
    final order = await repo.place(
      state.toOrder(lines, coupon: coupon),
      state.idempotencyKey,
    );
    if (ref.read(sessionControllerProvider).value == null) {
      await repo.rememberGuestOrder((
        number: order.number,
        phone: state.customerPhone,
      ));
    }
    await ref.read(cartControllerProvider.notifier).clear();
    ref.read(couponProvider.notifier).apply(null);
    return order;
  }

  /// A fresh checkout (after an order, or to start over).
  void reset() => state = build();
}

final checkoutControllerProvider =
    NotifierProvider<CheckoutController, CheckoutDraft>(CheckoutController.new);

/// Delivery areas, for the map and the area search (screen 22).
final FutureProvider<List<ZoneWithAreaDto>> zonesProvider =
    FutureProvider.autoDispose(
      (ref) => ref.watch(checkoutRepositoryProvider).zones(),
    );

typedef CalendarKey = ({int leadTimeHours, Fulfillment fulfillment});
typedef SlotsKey = ({String date, int leadTimeHours, Fulfillment fulfillment});

/// Today to the end of the booking window (FR-DLV-03).
final FutureProviderFamily<DeliveryCalendarDto, CalendarKey>
deliveryCalendarProvider = FutureProvider.autoDispose
    .family<DeliveryCalendarDto, CalendarKey>(
      (ref, key) => ref
          .watch(checkoutRepositoryProvider)
          .calendar(key.leadTimeHours, key.fulfillment),
    );

/// One day's slots and why some cannot be chosen (FR-DLV-04/05).
final FutureProviderFamily<DaySlotsDto, SlotsKey> daySlotsProvider =
    FutureProvider.autoDispose.family<DaySlotsDto, SlotsKey>(
      (ref, key) => ref
          .watch(checkoutRepositoryProvider)
          .slots(key.date, key.leadTimeHours, key.fulfillment),
    );

/// The signed-in customer's saved addresses; none for a guest.
final FutureProvider<List<AddressDto>> savedAddressesProvider =
    FutureProvider.autoDispose((ref) async {
      final session = await ref.watch(sessionControllerProvider.future);
      if (session == null) return const [];
      return await ref.watch(checkoutRepositoryProvider).savedAddresses();
    });

/// The cart priced with the chosen zone's fee (screens 21, 23; FR-CRT-08).
final checkoutQuoteProvider = Provider<AsyncValue<CartQuoteDto?>>((ref) {
  final lines = ref.watch(cartControllerProvider).value ?? const [];
  final zone = ref.watch(checkoutControllerProvider.select((d) => d.zoneSlug));
  return ref.watch(
    cartQuoteProvider(
      cartQuoteKey(lines, ref.watch(couponProvider), zone: zone),
    ),
  );
});

/// The longest lead time in the cart, from the server's quote (FR-DLV-05).
final cartLeadTimeProvider = Provider<int?>(
  (ref) => ref.watch(currentCartQuoteProvider).value?.leadTimeHours,
);
