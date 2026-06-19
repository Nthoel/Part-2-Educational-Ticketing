import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/user_api_model.dart';

class ProfileService {
  ProfileService({Dio? dio}) : _dio = dio ?? ApiClient.create();

  final Dio _dio;

  Future<UserApiModel> getMe(String accessToken) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/me',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    return UserApiModel.fromJson(data);
  }

  Future<UserApiModel> updateMe({
    required String accessToken,
    required String name,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/me',
      data: {'name': name},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    return UserApiModel.fromJson(data);
  }
}
