import 'package:freezed_annotation/freezed_annotation.dart';

import 'movie_dto.dart';

part 'discover_movies_response_dto.freezed.dart';
part 'discover_movies_response_dto.g.dart';

@freezed
abstract class DiscoverMoviesResponseDto with _$DiscoverMoviesResponseDto {
  const factory DiscoverMoviesResponseDto({
    @Default(<MovieDto>[]) List<MovieDto> results,
    @Default(1) @JsonKey(name: 'total_pages') int totalPages,
    @Default(0) @JsonKey(name: 'total_results') int totalResults,
  }) = _DiscoverMoviesResponseDto;

  factory DiscoverMoviesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DiscoverMoviesResponseDtoFromJson(json);
}
