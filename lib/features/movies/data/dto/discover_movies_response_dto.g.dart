// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_movies_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiscoverMoviesResponseDto _$DiscoverMoviesResponseDtoFromJson(
  Map<String, dynamic> json,
) => _DiscoverMoviesResponseDto(
  results:
      (json['results'] as List<dynamic>?)
          ?.map((e) => MovieDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MovieDto>[],
);

Map<String, dynamic> _$DiscoverMoviesResponseDtoToJson(
  _DiscoverMoviesResponseDto instance,
) => <String, dynamic>{'results': instance.results};
