// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_filters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomFilters _$RoomFiltersFromJson(Map<String, dynamic> json) => _RoomFilters(
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  streamingPlatforms:
      (json['streamingPlatforms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  minRating: (json['minRating'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$RoomFiltersToJson(_RoomFilters instance) =>
    <String, dynamic>{
      'genres': instance.genres,
      'streamingPlatforms': instance.streamingPlatforms,
      'minRating': instance.minRating,
    };
