import 'package:freezed_annotation/freezed_annotation.dart';

import 'genre_dto.dart';

part 'genres_response_dto.freezed.dart';
part 'genres_response_dto.g.dart';

@freezed
abstract class GenresResponseDto with _$GenresResponseDto {
  const factory GenresResponseDto({
    @Default(<GenreDto>[]) List<GenreDto> genres,
  }) = _GenresResponseDto;

  factory GenresResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GenresResponseDtoFromJson(json);
}
