import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../domain/models/order_models.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final int orderId;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  String _paymentMethod = 'bank_transfer';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(orderDetailViewModelProvider)
          .loadOrderDetail(widget.orderId),
    );
  }

  Future<void> _showPaymentMethodPicker() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        const methods = ['bank_transfer', 'e_wallet', 'virtual_account'];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Pilih Metode Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RadioGroup<String>(
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        if (value == null) return;
                        setModalState(() => _paymentMethod = value);
                        setState(() => _paymentMethod = value);
                      },
                      child: Column(
                        children: methods
                            .map(
                              (method) => RadioListTile<String>(
                                value: method,
                                title: Text(method),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Gunakan Metode Ini'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'paid':
        return const Color(0xFF7DFF9B);
      case 'cancelled':
      case 'expired':
        return const Color(0xFFFF8A8A);
      case 'pending':
      default:
        return const Color(0xFFFFD93D);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(orderDetailViewModelProvider);
    final Order? order = vm.orderDetail;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: SafeArea(
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null && order == null
            ? Center(child: Text(vm.errorMessage!))
            : order == null
            ? const Center(child: Text('Data pesanan tidak ditemukan'))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (vm.successMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NeoBrutalCard(
                        backgroundColor: const Color(0xFF7DFF9B),
                        child: Text(vm.successMessage!),
                      ),
                    ),
                  if (vm.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NeoBrutalCard(
                        backgroundColor: const Color(0xFFFF8A8A),
                        child: Text(vm.errorMessage!),
                      ),
                    ),
                  NeoBrutalCard(
                    backgroundColor: _statusColor(order.status),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderCode,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text('Status: ${order.status.toUpperCase()}'),
                        Text(
                          'Total: Rp ${order.totalAmount.toStringAsFixed(0)}',
                        ),
                        Text(
                          'Dibuat: ${DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt)}',
                        ),
                        Text(
                          'Expired: ${DateFormat('dd MMM yyyy, HH:mm').format(order.expiredAt)}',
                        ),
                        if (order.paidAt != null)
                          Text(
                            'Paid: ${DateFormat('dd MMM yyyy, HH:mm').format(order.paidAt!)}',
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  NeoBrutalCard(
                    backgroundColor: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Item Pesanan',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9F9),
                                border: Border.all(
                                  color: const Color(0xFF111111),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.eventTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text('Tiket: ${item.ticketTypeName}'),
                                  Text('Qty: ${item.quantity}'),
                                  Text(
                                    'Harga: Rp ${item.pricePerTicket.toStringAsFixed(0)}',
                                  ),
                                  Text(
                                    'Subtotal: Rp ${item.subtotal.toStringAsFixed(0)}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (order.status == 'pending')
                    NeoBrutalCard(
                      backgroundColor: const Color(0xFF6BCBFF),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Metode bayar: $_paymentMethod'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: vm.isPaying
                                      ? null
                                      : () => _showPaymentMethodPicker(),
                                  child: const Text('Pilih Metode'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: vm.isPaying
                                      ? null
                                      : () => vm.payOrder(
                                          orderId: order.id,
                                          paymentMethod: _paymentMethod,
                                        ),
                                  child: vm.isPaying
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Bayar Sekarang'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: vm.isCancelling
                                  ? null
                                  : () => vm.cancelOrder(order.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF8A8A),
                              ),
                              child: vm.isCancelling
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Batalkan Pesanan'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
