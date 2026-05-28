import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_movies_params.freezed.dart';

@freezed
abstract class DiscoverMoviesParams with _$DiscoverMoviesParams {
  const factory DiscoverMoviesParams({
    @Default(<int>[]) List<int> genreIds,
    @Default(<int>[]) List<int> providerIds,
    @Default(0) double minRating,
    @Default('popularity.desc') String sortBy,
    required int releaseYear,
  }) = _DiscoverMoviesParams;
}
