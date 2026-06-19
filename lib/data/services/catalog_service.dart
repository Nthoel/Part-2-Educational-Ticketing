import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/category_api_model.dart';
import '../models/event_api_models.dart';

class EventListApiResult {
  const EventListApiResult({required this.events, required this.meta});

  final List<EventListItemApiModel> events;
  final PaginationMetaApiModel meta;
}

class CatalogService {
  CatalogService({Dio? dio}) : _dio = dio ?? ApiClient.create();

  final Dio _dio;

  Future<List<CategoryApiModel>> getCategories() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/categories');

    final data = (response.data?['data'] as List<dynamic>?) ?? <dynamic>[];
    return data
        .map(
          (e) => CategoryApiModel.fromJson(
            (e as Map<String, dynamic>?) ?? <String, dynamic>{},
          ),
        )
        .toList();
  }

  Future<EventListApiResult> getEvents({
    int page = 1,
    int perPage = 10,
    String? search,
    int? categoryId,
    String? city,
    String? sort,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/events',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (search?.trim().isNotEmpty ?? false) 'search': search?.trim(),
        'category_id': ?categoryId,
        if (city case final c? when c.trim().isNotEmpty) 'city': c.trim(),
        if (sort case final s? when s.trim().isNotEmpty) 'sort': s.trim(),
      },
    );

    final data = (response.data?['data'] as List<dynamic>?) ?? <dynamic>[];
    final metaJson =
        (response.data?['meta'] as Map<String, dynamic>?) ??
        <String, dynamic>{};

    return EventListApiResult(
      events: data
          .map(
            (e) => EventListItemApiModel.fromJson(
              (e as Map<String, dynamic>?) ?? <String, dynamic>{},
            ),
          )
          .toList(),
      meta: PaginationMetaApiModel.fromJson(metaJson),
    );
  }

  Future<EventDetailApiModel> getEventDetail(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/events/$id');

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    return EventDetailApiModel.fromJson(data);
  }
}
