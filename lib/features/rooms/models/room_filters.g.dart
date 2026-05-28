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
);

Map<String, dynamic> _$RoomFiltersToJson(_RoomFilters instance) =>
    <String, dynamic>{
      'genreIds': instance.genreIds,
      'providerIds': instance.providerIds,
      'minRating': instance.minRating,
      'releaseYear': instance.releaseYear,
      'sortBy': instance.sortBy,
    };
