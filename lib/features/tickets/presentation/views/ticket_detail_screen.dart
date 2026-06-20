import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../domain/models/ticket_models.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';

class TicketDetailScreen extends ConsumerStatefulWidget {
  const TicketDetailScreen({required this.ticketId, super.key});

  final int ticketId;

  @override
  ConsumerState<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(ticketDetailViewModelProvider)
          .loadTicketDetail(widget.ticketId),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return const Color(0xFF7DFF9B);
      case 'used':
        return const Color(0xFF6BCBFF);
      case 'cancelled':
      default:
        return const Color(0xFFFF8A8A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(ticketDetailViewModelProvider);
    final TicketDetail? ticket = vm.ticketDetail;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tiket')),
      body: SafeArea(
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null && ticket == null
            ? Center(child: Text(vm.errorMessage!))
            : ticket == null
            ? const Center(child: Text('Data tiket tidak ditemukan'))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  NeoBrutalCard(
                    backgroundColor: _statusColor(ticket.status),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.ticketCode,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text('Status: ${ticket.status.toUpperCase()}'),
                        Text('Pemilik: ${ticket.holder.name}'),
                        Text('Email: ${ticket.holder.email}'),
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
                          ticket.event.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text('Venue: ${ticket.event.venueName}'),
                        Text('Alamat: ${ticket.event.venueAddress}'),
                        Text('Kota: ${ticket.event.city}'),
                        Text(
                          'Waktu Event: ${DateFormat('dd MMM yyyy, HH:mm').format(ticket.event.eventAt)}',
                        ),
                        const SizedBox(height: 8),
                        Text('Tipe Tiket: ${ticket.ticketType.name}'),
                        Text(
                          'Harga: Rp ${ticket.ticketType.price.toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  NeoBrutalCard(
                    backgroundColor: const Color(0xFFFFD93D),
                    child: Column(
                      children: [
                        Text(
                          'QR Tiket',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFF111111),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: QrImageView(
                            data: ticket.qrCodeValue,
                            size: 220,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ticket.qrCodeValue,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
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
