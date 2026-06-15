import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/location_suggestion.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/places_repository.dart';
import '../../places_load_errors.dart';

class CloudPlacesRepository implements PlacesRepository {
  CloudPlacesRepository(this._functions);

  final FirebaseFunctions _functions;

  HttpsCallable _callable(String name) {
    return _functions.httpsCallable(
      name,
      options: HttpsCallableOptions(timeout: const Duration(seconds: 45)),
    );
  }

  @override
  Future<GeocodedLocation> geocodeLocation(String query) async {
    try {
      debugPrint('[Places] geocodeLocation query="$query"');
      final result =
          await _callable('geocodeLocation').call<Map<String, dynamic>>({
        'query': query.trim(),
      });
      final data = _asMap(result.data);
      debugPrint(
        '[Places] geocodeLocation ok lat=${data['lat']} lng=${data['lng']}',
      );
      return GeocodedLocation(
        lat: (data['lat'] as num).toDouble(),
        lng: (data['lng'] as num).toDouble(),
        label: data['label'] as String? ?? query.trim(),
      );
    } on FirebaseFunctionsException catch (error) {
      throw mapFirebaseFunctionsException(error);
    }
  }

  @override
  Future<List<LocationSuggestion>> searchLocationSuggestions(String query) async {
    try {
      final normalized = query.trim();
      if (normalized.length < 2) {
        return const <LocationSuggestion>[];
      }

      final result = await _callable('searchLocationSuggestions')
          .call<Map<String, dynamic>>({'query': normalized});
      final data = _asMap(result.data);
      final rawSuggestions = data['suggestions'] as List? ?? const <dynamic>[];

      final suggestions = rawSuggestions
          .map((entry) => _parseLocationSuggestion(_asMap(entry)))
          .where(
            (suggestion) =>
                suggestion.label.isNotEmpty &&
                suggestion.lat != 0 &&
                suggestion.lng != 0,
          )
          .toList(growable: false);

      debugPrint(
        '[Places] searchLocationSuggestions query="$normalized" '
        'count=${suggestions.length}',
      );

      return suggestions;
    } on FirebaseFunctionsException catch (error) {
      throw mapFirebaseFunctionsException(error);
    }
  }

  @override
  Future<PlaceSearchResult> searchRestaurants({
    required double lat,
    required double lng,
    required int radiusMeters,
    double minRating = 0,
    List<int> priceLevels = const <int>[],
    List<String> cuisineTypes = const <String>[],
    bool openNow = false,
    String? pageToken,
    List<String> excludedPlaceIds = const <String>[],
  }) async {
    try {
      debugPrint(
        '[Places] searchRestaurants lat=$lat lng=$lng '
        'radius=$radiusMeters minRating=$minRating '
        'cuisines=$cuisineTypes openNow=$openNow',
      );
      final result =
          await _callable('searchRestaurants').call<Map<String, dynamic>>({
        'lat': lat,
        'lng': lng,
        'radiusMeters': radiusMeters,
        'minRating': minRating,
        'priceLevels': priceLevels,
        'cuisineTypes': cuisineTypes,
        'openNow': openNow,
        if (pageToken != null && pageToken.isNotEmpty) 'pageToken': pageToken,
        'excludedPlaceIds': excludedPlaceIds,
      });

      final data = _asMap(result.data);
      final rawPlaces = data['places'] as List? ?? const <dynamic>[];
      final places = rawPlaces
          .map((entry) => _parsePlace(_asMap(entry)))
          .where((place) => place.placeId.isNotEmpty)
          .toList(growable: false);

      debugPrint('[Places] searchRestaurants returned ${places.length} places');

      return PlaceSearchResult(
        places: places,
        nextPageToken: data['nextPageToken'] as String?,
      );
    } on FirebaseFunctionsException catch (error) {
      throw mapFirebaseFunctionsException(error);
    }
  }

  @override
  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    try {
      debugPrint('[Places] getPlaceDetails placeId=$placeId');
      final result =
          await _callable('getPlaceDetails').call<Map<String, dynamic>>({
        'placeId': placeId,
      });
      final data = _asMap(result.data);
      return PlaceDetails(
        placeId: data['placeId'] as String? ?? placeId,
        name: data['name'] as String? ?? 'Restaurant',
        rating: _parseRating(data['rating']),
        priceLevel: _parsePriceLevel(data['priceLevel']),
        shortAddress: data['shortAddress'] as String? ?? '',
        types: _stringList(data['types']),
        photoUrl: data['photoUrl'] as String?,
        googleMapsUri: data['googleMapsUri'] as String?,
        overview: data['overview'] as String? ?? '',
        openingHours: _stringList(data['openingHours']),
        websiteUri: data['websiteUri'] as String?,
      );
    } on FirebaseFunctionsException catch (error) {
      throw mapFirebaseFunctionsException(error);
    }
  }

  LocationSuggestion _parseLocationSuggestion(Map<String, dynamic> data) {
    return LocationSuggestion(
      label: data['label'] as String? ?? '',
      lat: (data['lat'] as num?)?.toDouble() ?? 0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0,
    );
  }

  Place _parsePlace(Map<String, dynamic> data) {
    return Place(
      placeId: data['placeId'] as String? ?? '',
      name: data['name'] as String? ?? 'Restaurant',
      rating: _parseRating(data['rating']),
      priceLevel: _parsePriceLevel(data['priceLevel']),
      shortAddress: data['shortAddress'] as String? ?? '',
      types: _stringList(data['types']),
      photoUrl: data['photoUrl'] as String?,
      photoName: data['photoName'] as String?,
      googleMapsUri: data['googleMapsUri'] as String?,
    );
  }

  @override
  Future<String?> resolvePlacePhoto(String photoName) async {
    final normalized = photoName.trim();
    if (normalized.isEmpty) {
      return null;
    }

    try {
      final result =
          await _callable('resolvePlacePhoto').call<Map<String, dynamic>>({
        'photoName': normalized,
      });
      final data = _asMap(result.data);
      return data['photoUrl'] as String?;
    } on FirebaseFunctionsException catch (error) {
      throw mapFirebaseFunctionsException(error);
    }
  }

  double _parseRating(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  int? _parsePriceLevel(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      final level = value.toInt();
      return level >= 1 && level <= 4 ? level : null;
    }
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null && parsed >= 1 && parsed <= 4) {
        return parsed;
      }
      return switch (value) {
        'PRICE_LEVEL_INEXPENSIVE' => 1,
        'PRICE_LEVEL_MODERATE' => 2,
        'PRICE_LEVEL_EXPENSIVE' => 3,
        'PRICE_LEVEL_VERY_EXPENSIVE' => 4,
        _ => null,
      };
    }
    return null;
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, entry) => MapEntry('$key', entry));
    }
    return const <String, dynamic>{};
  }

  List<String> _stringList(Object? value) {
    if (value is! List) {
      return const <String>[];
    }
    return value.map((item) => '$item').toList(growable: false);
  }
}
