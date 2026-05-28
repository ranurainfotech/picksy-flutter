import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MoviesCacheStore {
  static const _genresKey = 'tmdb_cache_genres';
  static const _providersKey = 'tmdb_cache_providers';

  Future<List<Map<String, dynamic>>?> readGenres() =>
      _readListMap(_genresKey);

  Future<List<Map<String, dynamic>>?> readProviders() =>
      _readListMap(_providersKey);

  Future<void> writeGenres(List<Map<String, dynamic>> raw) =>
      _writeListMap(_genresKey, raw);

  Future<void> writeProviders(List<Map<String, dynamic>> raw) =>
      _writeListMap(_providersKey, raw);

  Future<List<Map<String, dynamic>>?> _readListMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = prefs.getString(key);
    if (payload == null || payload.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(payload);
    if (decoded is! List) {
      return null;
    }

    return decoded
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  Future<void> _writeListMap(String key, List<Map<String, dynamic>> raw) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(raw));
  }
}
