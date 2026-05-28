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
        LogInterceptor(
          requestBody: false,
          responseBody: false,
        ),
      );
    }

    return dio;
  }
}

class TmdbConfigException implements Exception {
  const TmdbConfigException(this.message);
  final String message;
}
