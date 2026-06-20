import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/env.dart';

class ApiClient {
  ApiClient._();

  static const _storage = FlutterSecureStorage();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          final tokenType = await _storage.read(key: 'token_type') ?? 'Bearer';

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = '$tokenType $token';
          }

          handler.next(options);
        },
      ),
    );

    return dio;
  }
}
