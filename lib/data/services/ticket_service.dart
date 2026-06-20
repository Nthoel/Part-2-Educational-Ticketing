import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/ticket_api_models.dart';

class TicketService {
  TicketService({Dio? dio}) : _dio = dio ?? ApiClient.create();

  final Dio _dio;

  Future<List<TicketListItemApiModel>> getTickets() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/tickets');
    final data = (response.data?['data'] as List<dynamic>?) ?? <dynamic>[];

    return data
        .map(
          (e) => TicketListItemApiModel.fromJson(
            (e as Map<String, dynamic>?) ?? <String, dynamic>{},
          ),
        )
        .toList();
  }

  Future<TicketDetailApiModel> getTicketDetail(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/tickets/$id',
    );
    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};

    return TicketDetailApiModel.fromJson(data);
  }
}
