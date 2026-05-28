import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';

@freezed
abstract class Movie with _$Movie {
  const Movie._();

  const factory Movie({
    required int id,
    required String title,
    required String overview,
    String? posterPath,
    String? backdropPath,
    required double voteAverage,
    String? releaseDate,
  }) = _Movie;

  String? get posterUrl =>
      posterPath == null ? null : 'https://image.tmdb.org/t/p/w500/$posterPath';

  String? get backdropUrl => backdropPath == null
      ? null
      : 'https://image.tmdb.org/t/p/original/$backdropPath';

  String get releaseYear {
    if (releaseDate == null || releaseDate!.length < 4) {
      return '—';
    }
    return releaseDate!.substring(0, 4);
  }
}
