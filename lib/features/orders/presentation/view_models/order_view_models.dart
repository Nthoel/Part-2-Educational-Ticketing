import 'package:flutter/foundation.dart';

import '../../../../data/repositories/order_repository.dart';
import '../../../../domain/models/order_models.dart';

class CreateOrderViewModel extends ChangeNotifier {
  CreateOrderViewModel(this._orderRepository);

  final OrderRepository _orderRepository;

  bool _isLoading = false;
  String? _errorMessage;
  Order? _createdOrder;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Order? get createdOrder => _createdOrder;

  Future<Order?> createOrder({
    required int ticketTypeId,
    required int quantity,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _createdOrder = await _orderRepository.createOrder(
        ticketTypeId: ticketTypeId,
        quantity: quantity,
      );
      return _createdOrder;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

class MyOrdersViewModel extends ChangeNotifier {
  MyOrdersViewModel(this._orderRepository);

  final OrderRepository _orderRepository;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  final List<Order> _orders = [];
  int _page = 1;
  final int _perPage = 10;
  bool _hasMore = true;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<Order> get orders => List.unmodifiable(_orders);
  bool get hasMore => _hasMore;

  Future<void> initialize() async {
    _orders.clear();
    _page = 1;
    _hasMore = true;
    await _load(page: 1, reset: true);
  }

  Future<void> refresh() async {
    await initialize();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoading || _isLoadingMore) return;
    await _load(page: _page + 1, reset: false);
  }

  Future<void> _load({required int page, required bool reset}) async {
    if (reset) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _orderRepository.getOrders(
        page: page,
        perPage: _perPage,
      );

      if (reset) {
        _orders
          ..clear()
          ..addAll(result.orders);
      } else {
        _orders.addAll(result.orders);
      }

      _page = result.meta.page;
      _hasMore = result.meta.page < result.meta.totalPages;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}

class OrderDetailViewModel extends ChangeNotifier {
  OrderDetailViewModel(this._orderRepository);

  final OrderRepository _orderRepository;

  bool _isLoading = false;
  bool _isPaying = false;
  bool _isCancelling = false;
  String? _errorMessage;
  String? _successMessage;
  Order? _orderDetail;
  PayOrderResult? _lastPayment;

  bool get isLoading => _isLoading;
  bool get isPaying => _isPaying;
  bool get isCancelling => _isCancelling;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  Order? get orderDetail => _orderDetail;
  PayOrderResult? get lastPayment => _lastPayment;

  Future<void> loadOrderDetail(int id) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _orderDetail = await _orderRepository.getOrderDetail(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelOrder(int id) async {
    _isCancelling = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _orderDetail = await _orderRepository.cancelOrder(id);
      _successMessage = 'Pesanan berhasil dibatalkan.';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isCancelling = false;
      notifyListeners();
    }
  }

  Future<void> payOrder({
    required int orderId,
    required String paymentMethod,
  }) async {
    _isPaying = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _lastPayment = await _orderRepository.payOrder(
        orderId: orderId,
        paymentMethod: paymentMethod,
      );
      _orderDetail = await _orderRepository.getOrderDetail(orderId);
      _successMessage =
          'Pembayaran sukses (${_lastPayment?.paymentCode ?? '-'})';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isPaying = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
