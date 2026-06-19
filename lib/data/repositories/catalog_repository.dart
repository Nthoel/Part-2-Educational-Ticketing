import '../../domain/models/category.dart';
import '../../domain/models/event_models.dart';
import '../../domain/models/pagination_meta.dart';
import '../services/catalog_service.dart';

class EventListResult {
  const EventListResult({required this.events, required this.meta});

  final List<EventListItem> events;
  final PaginationMeta meta;
}

class CatalogRepository {
  CatalogRepository({required CatalogService catalogService})
    : _catalogService = catalogService;

  final CatalogService _catalogService;

  Future<List<Category>> getCategories() async {
    final result = await _catalogService.getCategories();
    return result.map((e) => e.toDomain()).toList();
  }

  Future<EventListResult> getEvents({
    int page = 1,
    int perPage = 10,
    String? search,
    int? categoryId,
    String? city,
    String? sort,
  }) async {
    final result = await _catalogService.getEvents(
      page: page,
      perPage: perPage,
      search: search,
      categoryId: categoryId,
      city: city,
      sort: sort,
    );

    return EventListResult(
      events: result.events.map((e) => e.toDomain()).toList(),
      meta: result.meta.toDomain(),
    );
  }

  Future<EventDetail> getEventDetail(int id) async {
    final result = await _catalogService.getEventDetail(id);
    return result.toDomain();
  }
}
