import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';
import 'order_detail_screen.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(myOrdersViewModelProvider).initialize());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(myOrdersViewModelProvider).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    final vm = ref.watch(myOrdersViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: SafeArea(
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null
            ? Center(child: Text(vm.errorMessage!))
            : RefreshIndicator(
                onRefresh: vm.refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.orders.length + (vm.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= vm.orders.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final order = vm.orders[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderDetailScreen(orderId: order.id),
                            ),
                          );
                        },
                        child: NeoBrutalCard(
                          backgroundColor: _statusColor(order.status),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.orderCode,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 6),
                              Text('Status: ${order.status.toUpperCase()}'),
                              Text(
                                'Total: Rp ${order.totalAmount.toStringAsFixed(0)}',
                              ),
                              Text(
                                'Dibuat: ${DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt)}',
                              ),
                              Text('Item: ${order.items.length}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
