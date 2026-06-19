import 'package:flutter/foundation.dart' hide Category;

import '../../../../data/repositories/catalog_repository.dart';
import '../../../../domain/models/category.dart';
import '../../../../domain/models/event_models.dart';

class EventListViewModel extends ChangeNotifier {
  EventListViewModel(this._catalogRepository);

  final CatalogRepository _catalogRepository;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  List<Category> _categories = [];
  List<EventListItem> _events = [];

  int _page = 1;
  final int _perPage = 10;
  int _totalPages = 1;

  String _search = '';
  int? _categoryId;
  String _city = '';
  String _sort = 'event_at_asc';

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<Category> get categories => _categories;
  List<EventListItem> get events => _events;
  bool get hasMore => _page < _totalPages;

  String get search => _search;
  int? get categoryId => _categoryId;
  String get city => _city;
  String get sort => _sort;

  Future<void> initialize() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _categories = await _catalogRepository.getCategories();
      await _fetchEvents(reset: true);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() async {
    await _fetchEvents(reset: true);
  }

  Future<void> loadMore() async {
    if (!hasMore || _isLoadingMore || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _page += 1;
      final result = await _catalogRepository.getEvents(
        page: _page,
        perPage: _perPage,
        search: _search,
        categoryId: _categoryId,
        city: _city,
        sort: _sort,
      );

      _events = [..._events, ...result.events];
      _totalPages = result.meta.totalPages;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> setSearch(String value) async {
    _search = value;
    await _fetchEvents(reset: true);
  }

  Future<void> setCategory(int? value) async {
    _categoryId = value;
    await _fetchEvents(reset: true);
  }

  Future<void> setCity(String value) async {
    _city = value;
    await _fetchEvents(reset: true);
  }

  Future<void> setSort(String value) async {
    _sort = value;
    await _fetchEvents(reset: true);
  }

  Future<void> _fetchEvents({required bool reset}) async {
    if (reset) {
      _setLoading(true);
      _page = 1;
      _totalPages = 1;
      _errorMessage = null;
    }

    try {
      final result = await _catalogRepository.getEvents(
        page: _page,
        perPage: _perPage,
        search: _search,
        categoryId: _categoryId,
        city: _city,
        sort: _sort,
      );

      _events = result.events;
      _totalPages = result.meta.totalPages;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (reset) {
        _setLoading(false);
      } else {
        notifyListeners();
      }
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
