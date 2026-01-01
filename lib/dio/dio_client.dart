// ignore_for_file: unnecessary_null_comparison, prefer_final_fields

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/utils/constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  final GetStorage store = GetStorage();
  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: base_url,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Read token fresh each time
          final token = store.read<String>('token');

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          log("➡️ REQUEST [${options.method}] => ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log("⬅️ RESPONSE [${response.statusCode}] => ${response.requestOptions.uri}");
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          log("🔐 ${e.response?.statusCode} error for ${e.requestOptions.uri}");
          // 401 → try refresh token
          if (e.response?.statusCode == 401) {
            log("🔐 Token expired, attempting to refresh...");

            final oldToken = store.read<String>('refreshToken');
            final newToken = await _getRefreshToken(oldToken);

            if (newToken != null) {
              await store.write('token', newToken);

              final options = e.requestOptions;
              options.headers["Authorization"] = "Bearer $newToken";

              try {
                final clonedResponse = await dio.fetch(options);
                return handler.resolve(clonedResponse);
              } catch (err) {
                _handleError(err as DioException);
                return handler.next(err as DioException);
              }
            }
          }

          // Other errors
          _handleError(e);
          return handler.next(e); // let caller's try/catch handle it
        },
      ),
    );
  }

  Future<String?> _getRefreshToken(String? token) async {
    if (token == null) return null;

    try {
      final response = await dio.post(
        "auth/refreshToken",
        data: {"refreshToken": token},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.data["token"]; // adjust to your API
    } catch (e) {
      log("❌ Failed to refresh token: $e");
      return null;
    }
  }

  // Centralized error handler
  void _handleError(DioException e) {
    log("❌ Dio error: ${e.message}");
    log("STATUS: ${e.response?.statusCode}");
    log("DATA: ${e.response?.data}");

    if (e.type == DioExceptionType.connectionTimeout) {
      log("❌ Connection timeout");
    } else if (e.type == DioExceptionType.receiveTimeout) {
      log("❌ Receive timeout");
    } else if (e.type == DioExceptionType.badResponse) {
      log("❌ Bad response from server");
    } else if (e.type == DioExceptionType.unknown) {
      log("❌ Unknown error: ${e.error}");
    }
  }
}
