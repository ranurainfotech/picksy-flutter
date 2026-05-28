// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genres_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenresResponseDto _$GenresResponseDtoFromJson(Map<String, dynamic> json) =>
    _GenresResponseDto(
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GenreDto>[],
    );

Map<String, dynamic> _$GenresResponseDtoToJson(_GenresResponseDto instance) =>
    <String, dynamic>{'genres': instance.genres};
