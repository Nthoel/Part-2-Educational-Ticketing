import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';
import '../../../orders/presentation/views/order_detail_screen.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({required this.eventId, super.key});

  final int eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  final Map<int, int> _quantities = {};

  int _getQty(int ticketTypeId) => _quantities[ticketTypeId] ?? 1;

  void _incQty(int ticketTypeId, int remaining) {
    final current = _getQty(ticketTypeId);
    if (current >= remaining) return;
    setState(() => _quantities[ticketTypeId] = current + 1);
  }

  void _decQty(int ticketTypeId) {
    final current = _getQty(ticketTypeId);
    if (current <= 1) return;
    setState(() => _quantities[ticketTypeId] = current - 1);
  }

  Future<void> _buyTicket({
    required int ticketTypeId,
    required int quantity,
  }) async {
    final vm = ref.read(createOrderViewModelProvider);
    final order = await vm.createOrder(
      ticketTypeId: ticketTypeId,
      quantity: quantity,
    );

    if (!mounted) return;

    if (order == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Gagal membuat pesanan')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pesanan ${order.orderCode} berhasil dibuat')),
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: order.id)),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref
          .read(eventDetailViewModelProvider)
          .loadEventDetail(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(eventDetailViewModelProvider);
    final event = vm.eventDetail;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Event')),
      body: SafeArea(
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null
            ? Center(child: Text(vm.errorMessage!))
            : event == null
            ? const Center(child: Text('Data event tidak ditemukan'))
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        event.posterUrl != null && event.posterUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: event.posterUrl!,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/placeholder.jpeg',
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/placeholder.jpeg',
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 16),
                  NeoBrutalCard(
                    backgroundColor: const Color(0xFFFFD93D),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text('Kategori: ${event.categoryName}'),
                        Text('Status: ${event.status}'),
                        Text('Venue: ${event.venue.name}, ${event.venue.city}'),
                        Text('Alamat: ${event.venue.address}'),
                        const SizedBox(height: 8),
                        Text(
                          'Event: ${DateFormat('dd MMM yyyy, HH:mm').format(event.eventAt)}',
                        ),
                        Text(
                          'Penjualan: ${DateFormat('dd MMM yyyy, HH:mm').format(event.salesStartAt)} - '
                          '${DateFormat('dd MMM yyyy, HH:mm').format(event.salesEndAt)}',
                        ),
                        const SizedBox(height: 12),
                        Text(
                          event.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  NeoBrutalCard(
                    backgroundColor: const Color(0xFF6BCBFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jenis Tiket',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        ...event.ticketTypes.map(
                          (ticket) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF111111),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'Harga: Rp ${ticket.price.toStringAsFixed(0)}',
                                  ),
                                  Text(
                                    'Sisa: ${ticket.remainingQuantity} / Kuota: ${ticket.quota}',
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: ticket.remainingQuantity <= 0
                                            ? null
                                            : () => _decQty(ticket.id),
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text(
                                        '${_getQty(ticket.id)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: ticket.remainingQuantity <= 0
                                            ? null
                                            : () => _incQty(
                                                ticket.id,
                                                ticket.remainingQuantity,
                                              ),
                                        icon: const Icon(Icons.add),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        height: 42,
                                        child: ElevatedButton(
                                          onPressed:
                                              ticket.remainingQuantity <= 0
                                              ? null
                                              : ref
                                                    .watch(
                                                      createOrderViewModelProvider,
                                                    )
                                                    .isLoading
                                              ? null
                                              : () => _buyTicket(
                                                  ticketTypeId: ticket.id,
                                                  quantity: _getQty(ticket.id),
                                                ),
                                          child:
                                              ref
                                                  .watch(
                                                    createOrderViewModelProvider,
                                                  )
                                                  .isLoading
                                              ? const SizedBox(
                                                  height: 16,
                                                  width: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : const Text('Beli'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
