import '../../domain/models/order_models.dart';
import 'event_api_models.dart';

class OrderItemApiModel {
  const OrderItemApiModel({
    required this.id,
    required this.ticketTypeId,
    required this.ticketTypeName,
    required this.eventTitle,
    required this.quantity,
    required this.pricePerTicket,
    required this.subtotal,
  });

  final int id;
  final int ticketTypeId;
  final String ticketTypeName;
  final String eventTitle;
  final int quantity;
  final double pricePerTicket;
  final double subtotal;

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) {
    return OrderItemApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ticketTypeId: (json['ticket_type_id'] as num?)?.toInt() ?? 0,
      ticketTypeName: json['ticket_type_name'] as String? ?? '',
      eventTitle: json['event_title'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      pricePerTicket: (json['price_per_ticket'] as num?)?.toDouble() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
    );
  }

  OrderItem toDomain() {
    return OrderItem(
      id: id,
      ticketTypeId: ticketTypeId,
      ticketTypeName: ticketTypeName,
      eventTitle: eventTitle,
      quantity: quantity,
      pricePerTicket: pricePerTicket,
      subtotal: subtotal,
    );
  }
}

class OrderApiModel {
  const OrderApiModel({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.totalAmount,
    required this.expiredAt,
    required this.paidAt,
    required this.cancelledAt,
    required this.createdAt,
    required this.items,
  });

  final int id;
  final String orderCode;
  final String status;
  final double totalAmount;
  final DateTime expiredAt;
  final DateTime? paidAt;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final List<OrderItemApiModel> items;

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>?) ?? <dynamic>[];
    return OrderApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      orderCode: json['order_code'] as String? ?? '',
      status: json['status'] as String? ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      expiredAt:
          DateTime.tryParse(json['expired_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      paidAt: DateTime.tryParse(json['paid_at'] as String? ?? ''),
      cancelledAt: DateTime.tryParse(json['cancelled_at'] as String? ?? ''),
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      items: itemsJson
          .map(
            (e) => OrderItemApiModel.fromJson(
              (e as Map<String, dynamic>?) ?? <String, dynamic>{},
            ),
          )
          .toList(),
    );
  }

  Order toDomain() {
    return Order(
      id: id,
      orderCode: orderCode,
      status: status,
      totalAmount: totalAmount,
      expiredAt: expiredAt,
      paidAt: paidAt,
      cancelledAt: cancelledAt,
      createdAt: createdAt,
      items: items.map((e) => e.toDomain()).toList(),
    );
  }
}

class PayOrderResultApiModel {
  const PayOrderResultApiModel({
    required this.orderId,
    required this.orderCode,
    required this.paymentStatus,
    required this.orderStatus,
    required this.paymentMethod,
    required this.paymentCode,
    required this.amount,
    required this.paidAt,
    required this.generatedTicketCount,
  });

  final int orderId;
  final String orderCode;
  final String paymentStatus;
  final String orderStatus;
  final String paymentMethod;
  final String paymentCode;
  final double amount;
  final DateTime paidAt;
  final int generatedTicketCount;

  factory PayOrderResultApiModel.fromJson(Map<String, dynamic> json) {
    return PayOrderResultApiModel(
      orderId: (json['order_id'] as num?)?.toInt() ?? 0,
      orderCode: json['order_code'] as String? ?? '',
      paymentStatus: json['payment_status'] as String? ?? '',
      orderStatus: json['order_status'] as String? ?? '',
      paymentMethod: json['payment_method'] as String? ?? '',
      paymentCode: json['payment_code'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      paidAt:
          DateTime.tryParse(json['paid_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      generatedTicketCount:
          (json['generated_ticket_count'] as num?)?.toInt() ?? 0,
    );
  }

  PayOrderResult toDomain() {
    return PayOrderResult(
      orderId: orderId,
      orderCode: orderCode,
      paymentStatus: paymentStatus,
      orderStatus: orderStatus,
      paymentMethod: paymentMethod,
      paymentCode: paymentCode,
      amount: amount,
      paidAt: paidAt,
      generatedTicketCount: generatedTicketCount,
    );
  }
}

class OrderListApiResult {
  const OrderListApiResult({required this.orders, required this.meta});

  final List<OrderApiModel> orders;
  final PaginationMetaApiModel meta;
}
