import 'dart:async';

import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/cart/application/cart_controller.dart';
import 'package:belle_biens/features/cart/domain/cart_line.dart';
import 'package:belle_biens/features/checkout/application/checkout_controller.dart';
import 'package:belle_biens/features/orders/data/orders_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>(
  (ref) => OrdersRepository(ref.watch(belleApiProvider)),
);

/// One row of "طلباتي" (screen 26), for a customer's summary or a guest's
/// looked-up order alike.
class OrderListItem {
  const new({
    required this.number,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.fulfillment,
    required this.slot,
    required this.createdAt,
    required this.totalMinor,
    required this.itemCount,
    required this.title,
  });

  factory fromSummary(OrderSummaryDto s) => OrderListItem(
    number: s.number,
    status: s.status,
    paymentStatus: s.paymentStatus,
    paymentMethod: s.paymentMethod,
    fulfillment: s.fulfillment,
    slot: s.slot,
    createdAt: s.createdAt,
    totalMinor: s.totalMinor,
    itemCount: s.itemCount,
    title: s.title,
  );

  factory fromOrder(OrderDto o) => OrderListItem(
    number: o.number,
    status: o.status,
    paymentStatus: o.paymentStatus,
    paymentMethod: o.paymentMethod,
    fulfillment: o.fulfillment,
    slot: o.slot,
    createdAt: o.createdAt,
    totalMinor: o.syp.totalMinor,
    itemCount: o.lines.fold(0, (s, l) => s + l.qty),
    title: o.lines.isEmpty
        ? const LocalizedTextDto(ar: '', en: '')
        : o.lines.first.title,
  );

  final String number;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final Fulfillment fulfillment;
  final OrderSlotDto slot;
  final DateTime createdAt;
  final int totalMinor;
  final int itemCount;
  final LocalizedTextDto title;

  /// Still on its way (screen 26 "الحالية").
  bool get current => isCurrent(status);
}

bool isCurrent(OrderStatus status) => !const {
  OrderStatus.delivered,
  OrderStatus.pickedUp,
  OrderStatus.cancelled,
}.contains(status);

/// The phone a guest placed this order with, kept on this phone; null when
/// it is not a guest order here.
final FutureProviderFamily<String?, String> guestPhoneProvider = FutureProvider
    .autoDispose
    .family<String?, String>((ref, number) async {
      final guest = await ref.watch(checkoutRepositoryProvider).guestOrders();
      return guest.where((g) => g.number == number).firstOrNull?.phone;
    });

/// Screen 26: the account's orders, or this phone's guest orders.
final FutureProvider<List<OrderListItem>> ordersListProvider =
    FutureProvider.autoDispose((ref) async {
      final session = await ref.watch(sessionControllerProvider.future);
      final repo = ref.watch(ordersRepositoryProvider);
      if (session != null) {
        return [
          for (final s in await repo.mine()) OrderListItem.fromSummary(s),
        ];
      }
      final guest = await ref.watch(checkoutRepositoryProvider).guestOrders();
      final found = <OrderListItem>[];
      for (final g in guest) {
        try {
          found.add(
            OrderListItem.fromOrder(await repo.get(g.number, phone: g.phone)),
          );
        } on ApiError catch (error) {
          // Offline fails the list; a removed order is skipped.
          if (error.isOffline) rethrow;
        }
      }
      return found;
    });

/// One order (screen 27). The signed-in owner reads it with the session; a
/// guest with the phone kept from checkout or typed in screen 26.
final FutureProviderFamily<OrderDto, String> orderProvider = FutureProvider
    .autoDispose
    .family<OrderDto, String>((ref, number) async {
      final repo = ref.watch(ordersRepositoryProvider);
      final phone = await ref.watch(guestPhoneProvider(number).future);
      if (phone != null) return await repo.get(number, phone: phone);
      final session = await ref.watch(sessionControllerProvider.future);
      if (session == null) {
        throw const ApiError(code: 'NOT_FOUND', status: 404);
      }
      return await repo.get(number);
    });

/// Screen 27 asks again every minute while open, since push is not
/// guaranteed in Syria (plan section 9).
const orderRefreshEvery = Duration(seconds: 60);

/// Customer actions on an order; each returns the order as it is now.
class OrderActions {
  new(this._ref);

  final Ref _ref;

  OrdersRepository get _repo => _ref.read(ordersRepositoryProvider);

  /// Read straight from the phone's store: an auto-disposed provider read
  /// once here could be disposed before it answers.
  Future<String?> _phone(String number) async {
    final guest = await _ref.read(checkoutRepositoryProvider).guestOrders();
    return guest.where((g) => g.number == number).firstOrNull?.phone;
  }

  /// The order, the way [orderProvider] reads it.
  Future<OrderDto> fetch(String number) async {
    final phone = await _phone(number);
    if (phone != null) return await _repo.get(number, phone: phone);
    if (_ref.read(sessionControllerProvider).value == null) {
      throw const ApiError(code: 'NOT_FOUND', status: 404);
    }
    return await _repo.get(number);
  }

  OrderDto _refresh(String number, OrderDto order) {
    _ref
      ..invalidate(orderProvider(number))
      ..invalidate(ordersListProvider);
    return order;
  }

  Future<OrderDto> cancel(String number) async =>
      _refresh(number, await _repo.cancel(number, phone: await _phone(number)));

  Future<OrderDto> payCash(String number) async => _refresh(
    number,
    await _repo.payCash(number, phone: await _phone(number)),
  );

  Future<OrderDto> sendProof(
    String number, {
    String? reference,
    String? receiptUrl,
  }) async => _refresh(
    number,
    await _repo.sendProof(
      number,
      phone: await _phone(number),
      reference: reference,
      receiptUrl: receiptUrl,
    ),
  );

  /// Screen 26 for guests: finds the order and remembers it on this phone.
  Future<OrderDto> findAsGuest(String number, String phone) async {
    final order = await _repo.get(number.trim().toUpperCase(), phone: phone);
    await _ref.read(checkoutRepositoryProvider).rememberGuestOrder((
      number: order.number,
      phone: phone,
    ));
    _ref
      ..invalidate(guestPhoneProvider(order.number))
      ..invalidate(ordersListProvider);
    return order;
  }

  /// FR-ORD-07: the order's lines back in the cart, as new lines.
  Future<int> orderAgain(OrderDto order) async {
    final cart = _ref.read(cartControllerProvider.notifier);
    var added = 0;
    for (final line in order.lines) {
      final json = Map<String, Object?>.from(line.choice.toJson())
        ..['id'] = CartLine.newId();
      try {
        await cart.add(CartLine.fromJson(json));
        added += 1;
      } on Object {
        // A line this app version cannot read again is left out.
      }
    }
    return added;
  }
}

final orderActionsProvider = Provider<OrderActions>(OrderActions.new);

/// The time now; tests fix it so countdowns read the same every run.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Ticks every second, for the payment countdowns (screens 24, 38).
final StreamProvider<DateTime> nowTickerProvider =
    StreamProvider.autoDispose<DateTime>((ref) {
      final now = ref.watch(clockProvider);
      final controller = StreamController<DateTime>()..add(now());
      final timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => controller.add(now()),
      );
      ref.onDispose(() {
        timer.cancel();
        controller.close().ignore();
      });
      return controller.stream;
    });

/// "01:54:20" until [due], from [now]; "00:00:00" once past.
String countdownText(DateTime due, DateTime now) {
  var left = due.difference(now);
  if (left.isNegative) left = Duration.zero;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(left.inHours)}:${two(left.inMinutes % 60)}:'
      '${two(left.inSeconds % 60)}';
}
