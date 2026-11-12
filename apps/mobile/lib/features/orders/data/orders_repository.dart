import 'dart:typed_data';

import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:dio/dio.dart';

/// Reading, paying and cancelling orders (screens 24, 26, 27, 38). A guest
/// proves the order is theirs with the phone it was placed with
/// (FR-ORD-04); a signed-in customer with their session.
class OrdersRepository {
  new(this._api);

  final BelleApi _api;

  Future<List<OrderSummaryDto>> mine() =>
      guardApi(_api.me.myOrdersControllerList);

  /// The signed-in customer's order, or a guest's by number and phone.
  Future<OrderDto> get(String number, {String? phone}) => guardApi(
    () => phone == null
        ? _api.orders.ordersControllerGet(number: number)
        : _api.orders.ordersControllerLookup(
            body: OrderLookupDto(number: number, phone: phone),
          ),
  );

  Future<OrderDto> cancel(String number, {String? phone}) => guardApi(
    () => _api.orders.ordersControllerCancel(
      number: number,
      body: CancelOrderDto(phone: phone),
    ),
  );

  /// FR-PAY-03: the Sham Cash transaction number and/or receipt photo.
  Future<OrderDto> sendProof(
    String number, {
    String? phone,
    String? reference,
    String? receiptUrl,
  }) => guardApi(
    () => _api.orders.orderPaymentsControllerProof(
      number: number,
      body: PaymentProofDto(
        phone: phone,
        reference: reference,
        receiptUrl: receiptUrl,
      ),
    ),
  );

  /// Screen 38: pay on delivery instead.
  Future<OrderDto> payCash(String number, {String? phone}) => guardApi(
    () => _api.orders.orderPaymentsControllerCash(
      number: number,
      body: OwnerDto(phone: phone),
    ),
  );

  Future<String> uploadReceipt(Uint8List bytes, String filename) async {
    final result = await guardApi(
      () => _api.orders.orderPaymentsControllerReceipt(
        file: MultipartFile.fromBytes(bytes, filename: filename),
      ),
    );
    return result.url;
  }
}
