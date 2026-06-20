import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../domain/models/ticket_models.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';
import 'ticket_detail_screen.dart';

class MyTicketsScreen extends ConsumerStatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  ConsumerState<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends ConsumerState<MyTicketsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(myTicketsViewModelProvider).loadTickets());
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
    final vm = ref.watch(myTicketsViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tiket Saya')),
      body: SafeArea(
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null
            ? Center(child: Text(vm.errorMessage!))
            : RefreshIndicator(
                onRefresh: vm.refresh,
                child: vm.tickets.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          Center(child: Text('Belum ada tiket')),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: vm.tickets.length,
                        itemBuilder: (context, index) {
                          final TicketListItem ticket = vm.tickets[index];
                          return Padding(
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
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
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
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
