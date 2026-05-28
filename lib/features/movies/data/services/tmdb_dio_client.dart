import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TmdbDioClient {
  const TmdbDioClient();

  Dio create() {
    final token = dotenv.env['TMDB_ACCESS_TOKEN']?.trim() ?? '';
    if (token.isEmpty || token == 'YOUR_TOKEN') {
      throw const TmdbConfigException(
        'TMDB_ACCESS_TOKEN is missing. Add it in .env',
      );
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        headers: const <String, String>{'accept': 'application/json'},
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 12),
        sendTimeout: const Duration(seconds: 8),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('API URL: ${options.uri}');
            debugPrint('BODY: ${_formatForLog(options.data)}');
            handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint('STATUS: ${response.statusCode}');
            debugPrint('RESPONSE: ${_formatForLog(response.data)}');
            handler.next(response);
          },
          onError: (error, handler) {
            debugPrint('API URL: ${error.requestOptions.uri}');
            debugPrint('BODY: ${_formatForLog(error.requestOptions.data)}');
            debugPrint('STATUS: ${error.response?.statusCode ?? 'N/A'}');
            debugPrint('RESPONSE: ${_formatForLog(error.response?.data)}');
            if (error.response == null) {
              debugPrint('ERROR TYPE: ${error.type.name}');
              debugPrint('ERROR MESSAGE: ${error.message}');
              debugPrint('ERROR DETAIL: ${_formatForLog(error.error)}');
            }
            handler.next(error);
          },
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (!_shouldRetry(error)) {
            handler.next(error);
            return;
          }

          final request = error.requestOptions;
          final attempt = (request.extra['retry_attempt'] as int? ?? 0) + 1;
          if (attempt > 4) {
            handler.next(error);
            return;
          }

          request.extra['retry_attempt'] = attempt;
          await Future<void>.delayed(_retryDelay(attempt));

          try {
            final response = await dio.fetch<dynamic>(request);
            handler.resolve(response);
          } catch (retryError) {
            if (retryError is DioException) {
              handler.next(retryError);
            } else {
              handler.next(error);
            }
          }
        },
      ),
    );

    return dio;
  }

  static Duration _retryDelay(int attempt) {
    switch (attempt) {
      case 1:
        return const Duration(milliseconds: 300);
      case 2:
        return const Duration(milliseconds: 900);
      case 3:
        return const Duration(milliseconds: 1800);
      case 4:
        return const Duration(milliseconds: 3000);
      default:
        return const Duration(seconds: 1);
    }
  }

  static bool _shouldRetry(DioException error) {
    if (error.requestOptions.extra['no_retry'] == true) {
      return false;
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }
    final inner = error.error;
    if (inner is SocketException) {
      return true;
    }
    return false;
  }

  static String _formatForLog(Object? value) {
    if (value == null) {
      return 'null';
    }
    if (value is String) {
      return value;
    }
    try {
      return jsonEncode(value);
    } catch (_) {
      return value.toString();
    }
  }
}

class TmdbConfigException implements Exception {
  const TmdbConfigException(this.message);
  final String message;
}
