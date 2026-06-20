import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/event_api_models.dart';
import '../models/order_api_models.dart';

class OrderService {
  OrderService({Dio? dio}) : _dio = dio ?? ApiClient.create();

  final Dio _dio;

  Future<OrderApiModel> createOrder({
    required int ticketTypeId,
    required int quantity,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/orders',
      data: {'ticket_type_id': ticketTypeId, 'quantity': quantity},
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    return OrderApiModel.fromJson(data);
  }

  Future<OrderListApiResult> getOrders({int page = 1, int perPage = 10}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/orders',
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final data = (response.data?['data'] as List<dynamic>?) ?? <dynamic>[];
    final metaJson =
        (response.data?['meta'] as Map<String, dynamic>?) ??
        <String, dynamic>{};

    return OrderListApiResult(
      orders: data
          .map(
            (e) => OrderApiModel.fromJson(
              (e as Map<String, dynamic>?) ?? <String, dynamic>{},
            ),
          )
          .toList(),
      meta: PaginationMetaApiModel.fromJson(metaJson),
    );
  }

  Future<OrderApiModel> getOrderDetail(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/orders/$id');

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    return OrderApiModel.fromJson(data);
  }

  Future<OrderApiModel> cancelOrder(int id) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/orders/$id/cancel',
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    return OrderApiModel.fromJson(data);
  }

  Future<PayOrderResultApiModel> payOrder({
    required int orderId,
    required String paymentMethod,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/orders/$orderId/pay',
      data: {'payment_method': paymentMethod},
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    return PayOrderResultApiModel.fromJson(data);
  }
}
