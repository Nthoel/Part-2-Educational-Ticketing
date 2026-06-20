import 'package:flutter/foundation.dart';

import '../../../../data/repositories/ticket_repository.dart';
import '../../../../domain/models/ticket_models.dart';

class MyTicketsViewModel extends ChangeNotifier {
  MyTicketsViewModel(this._ticketRepository);

  final TicketRepository _ticketRepository;

  bool _isLoading = false;
  String? _errorMessage;
  List<TicketListItem> _tickets = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<TicketListItem> get tickets => _tickets;

  Future<void> loadTickets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tickets = await _ticketRepository.getTickets();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadTickets();
}

class TicketDetailViewModel extends ChangeNotifier {
  TicketDetailViewModel(this._ticketRepository);

  final TicketRepository _ticketRepository;

  bool _isLoading = false;
  String? _errorMessage;
  TicketDetail? _ticketDetail;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TicketDetail? get ticketDetail => _ticketDetail;

  Future<void> loadTicketDetail(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ticketDetail = await _ticketRepository.getTicketDetail(id);
    } catch (e) {
      _errorMessage = e.toString();
      _ticketDetail = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
