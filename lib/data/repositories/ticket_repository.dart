import '../../domain/models/ticket_models.dart';
import '../services/ticket_service.dart';

class TicketRepository {
  TicketRepository({required TicketService ticketService})
    : _ticketService = ticketService;

  final TicketService _ticketService;

  Future<List<TicketListItem>> getTickets() async {
    final items = await _ticketService.getTickets();
    return items.map((e) => e.toDomain()).toList();
  }

  Future<TicketDetail> getTicketDetail(int id) async {
    final item = await _ticketService.getTicketDetail(id);
    return item.toDomain();
  }
}
