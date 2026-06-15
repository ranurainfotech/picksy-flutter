// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_filters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomFilters _$RoomFiltersFromJson(Map<String, dynamic> json) => _RoomFilters(
  genreIds:
      (json['genreIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  providerIds:
      (json['providerIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  minRating: (json['minRating'] as num?)?.toDouble() ?? 0,
  releaseYear: (json['releaseYear'] as num?)?.toInt() ?? 0,
  sortBy: json['sortBy'] as String? ?? 'popularity.desc',
  locationLabel: json['locationLabel'] as String? ?? '',
  lat: (json['lat'] as num?)?.toDouble() ?? 0,
  lng: (json['lng'] as num?)?.toDouble() ?? 0,
  radiusMeters: (json['radiusMeters'] as num?)?.toInt() ?? 5000,
  priceLevels:
      (json['priceLevels'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  cuisineTypes:
      (json['cuisineTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  openNow: json['openNow'] as bool? ?? false,
);

Map<String, dynamic> _$RoomFiltersToJson(_RoomFilters instance) =>
    <String, dynamic>{
      'genreIds': instance.genreIds,
      'providerIds': instance.providerIds,
      'minRating': instance.minRating,
      'releaseYear': instance.releaseYear,
      'sortBy': instance.sortBy,
      'locationLabel': instance.locationLabel,
      'lat': instance.lat,
      'lng': instance.lng,
      'radiusMeters': instance.radiusMeters,
      'priceLevels': instance.priceLevels,
      'cuisineTypes': instance.cuisineTypes,
      'openNow': instance.openNow,
    };
