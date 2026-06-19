import 'package:flutter/foundation.dart';

import '../../../../data/repositories/catalog_repository.dart';
import '../../../../domain/models/event_models.dart';

class EventDetailViewModel extends ChangeNotifier {
  EventDetailViewModel(this._catalogRepository);

  final CatalogRepository _catalogRepository;

  bool _isLoading = false;
  String? _errorMessage;
  EventDetail? _eventDetail;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  EventDetail? get eventDetail => _eventDetail;

  Future<void> loadEventDetail(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _eventDetail = await _catalogRepository.getEventDetail(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
