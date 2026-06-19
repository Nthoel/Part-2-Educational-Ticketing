import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../models/auth_result_api_model.dart';

class AuthService {
  AuthService({Dio? dio}) : _dio = dio ?? ApiClient.create();

  final Dio _dio;

  Future<AuthResultApiModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    return AuthResultApiModel.fromJson(data);
  }

  Future<AuthResultApiModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    return AuthResultApiModel.fromJson(data);
  }

  Future<void> logout(String accessToken) async {
    await _dio.post<void>(
      '/api/v1/auth/logout',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}
