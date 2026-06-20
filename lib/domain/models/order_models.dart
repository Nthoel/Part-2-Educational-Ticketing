class OrderItem {
  const OrderItem({
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
}

class Order {
  const Order({
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
  final List<OrderItem> items;
}

class PayOrderResult {
  const PayOrderResult({
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
}
