import '../../domain/models/order_models.dart';
import '../../domain/models/pagination_meta.dart';
import '../services/order_service.dart';

class OrderListResult {
  const OrderListResult({required this.orders, required this.meta});

  final List<Order> orders;
  final PaginationMeta meta;
}

class OrderRepository {
  OrderRepository({required OrderService orderService})
    : _orderService = orderService;

  final OrderService _orderService;

  Future<Order> createOrder({
    required int ticketTypeId,
    required int quantity,
  }) async {
    final result = await _orderService.createOrder(
      ticketTypeId: ticketTypeId,
      quantity: quantity,
    );
    return result.toDomain();
  }

  Future<OrderListResult> getOrders({int page = 1, int perPage = 10}) async {
    final result = await _orderService.getOrders(page: page, perPage: perPage);
    return OrderListResult(
      orders: result.orders.map((e) => e.toDomain()).toList(),
      meta: result.meta.toDomain(),
    );
  }

  Future<Order> getOrderDetail(int id) async {
    final result = await _orderService.getOrderDetail(id);
    return result.toDomain();
  }

  Future<Order> cancelOrder(int id) async {
    final result = await _orderService.cancelOrder(id);
    return result.toDomain();
  }

  Future<PayOrderResult> payOrder({
    required int orderId,
    required String paymentMethod,
  }) async {
    final result = await _orderService.payOrder(
      orderId: orderId,
      paymentMethod: paymentMethod,
    );
    return result.toDomain();
  }
}
