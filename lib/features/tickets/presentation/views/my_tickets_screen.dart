import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../domain/models/order_models.dart';
import '../../../../domain/models/ticket_models.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';
import '../../../catalog/presentation/views/event_list_screen.dart';
import '../../../orders/presentation/views/order_detail_screen.dart';
import '../../../profile/presentation/views/profile_screen.dart';
import 'ticket_detail_screen.dart';

class MyTicketsScreen extends ConsumerStatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  ConsumerState<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends ConsumerState<MyTicketsScreen> {
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(myTicketsViewModelProvider).loadTickets();
      await ref.read(myOrdersViewModelProvider).initialize();
    });
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'paid':
        return const Color(0xFF7DFF9B);
      case 'pending':
        return const Color(0xFFFFD93D);
      case 'used':
        return const Color(0xFF6BCBFF);
      case 'cancelled':
      case 'expired':
      default:
        return const Color(0xFFFF8A8A);
    }
  }

  void _onNavTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const EventListScreen()),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(myTicketsViewModelProvider);
    final ordersVm = ref.watch(myOrdersViewModelProvider);

    final List<Order> pendingOrders = ordersVm.orders
        .where((order) => order.status.toLowerCase() == 'pending')
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Tiket Saya')),
      body: SafeArea(
        child: vm.isLoading && ordersVm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([vm.refresh(), ordersVm.refresh()]);
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (pendingOrders.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Menunggu Pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      ...pendingOrders.map(
                        (order) => Padding(
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
                              backgroundColor: const Color(0xFFFFD93D),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.orderCode,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 6),
                                  Text('Status: ${order.status.toUpperCase()}'),
                                  Text(
                                    'Total: Rp ${order.totalAmount.toStringAsFixed(0)}',
                                  ),
                                  Text(
                                    'Expired: ${DateFormat('dd MMM yyyy, HH:mm').format(order.expiredAt)}',
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Tap untuk lanjut bayar / batalkan pesanan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    if (vm.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(vm.errorMessage!),
                      ),
                    if (ordersVm.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(ordersVm.errorMessage!),
                      ),
                    if (vm.tickets.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 36),
                        child: Center(child: Text('Belum ada tiket aktif')),
                      )
                    else ...[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Tiket Aktif',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      ...vm.tickets.map(
                        (TicketListItem ticket) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TicketDetailScreen(ticketId: ticket.id),
                                ),
                              );
                            },
                            child: NeoBrutalCard(
                              backgroundColor: _statusColor(ticket.status),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.ticketCode,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Status: ${ticket.status.toUpperCase()}',
                                  ),
                                  Text('Event: ${ticket.event.title}'),
                                  Text(
                                    '${ticket.event.venueName}, ${ticket.event.city}',
                                  ),
                                  Text(
                                    DateFormat(
                                      'dd MMM yyyy, HH:mm',
                                    ).format(ticket.event.eventAt),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_num_outlined),
            selectedIcon: Icon(Icons.confirmation_num),
            label: 'Tiket',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
