import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../dto/discover_movies_response_dto.dart';
import '../dto/genres_response_dto.dart';
import '../dto/providers_response_dto.dart';

part 'tmdb_api_service.g.dart';

@RestApi()
abstract class TmdbApiService {
  factory TmdbApiService(Dio dio, {String baseUrl}) = _TmdbApiService;

  @GET('/genre/movie/list')
  Future<GenresResponseDto> getGenres();

  @GET('/watch/providers/movie')
  Future<ProvidersResponseDto> getWatchProviders({
    @Query('watch_region') String watchRegion = 'US',
  });

  @GET('/discover/movie')
  Future<DiscoverMoviesResponseDto> discoverMovies({
    @Query('with_genres') required String withGenres,
    @Query('vote_average.gte') required double voteAverageGte,
    @Query('primary_release_year') required int primaryReleaseYear,
    @Query('with_watch_providers') String? withWatchProviders,
    @Query('watch_region') String? watchRegion,
    @Query('sort_by') String sortBy = 'popularity.desc',
  });
}
