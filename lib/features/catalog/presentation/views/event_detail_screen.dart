import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({required this.eventId, super.key});

  final int eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
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
