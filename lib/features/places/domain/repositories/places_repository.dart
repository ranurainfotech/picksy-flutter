import '../entities/place.dart';

class PlaceSearchResult {
  const PlaceSearchResult({
    required this.places,
    this.nextPageToken,
  });

  final List<Place> places;
  final String? nextPageToken;
}

class GeocodedLocation {
  const GeocodedLocation({
    required this.lat,
    required this.lng,
    required this.label,
  });

  final double lat;
  final double lng;
  final String label;
}

class PlaceDetails {
  const PlaceDetails({
    required this.placeId,
    required this.name,
    required this.rating,
    this.priceLevel,
    this.shortAddress = '',
    this.types = const <String>[],
    this.photoUrl,
    this.googleMapsUri,
    this.overview = '',
    this.openingHours = const <String>[],
    this.websiteUri,
  });

  final String placeId;
  final String name;
  final double rating;
  final int? priceLevel;
  final String shortAddress;
  final List<String> types;
  final String? photoUrl;
  final String? googleMapsUri;
  final String overview;
  final List<String> openingHours;
  final String? websiteUri;
}

abstract class PlacesRepository {
  Future<GeocodedLocation> geocodeLocation(String query);

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
  });

  Future<PlaceDetails> getPlaceDetails(String placeId);
}
