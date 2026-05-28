import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/tmdb_movies_repository.dart';
import '../../data/services/movies_cache_store.dart';
import '../../data/services/tmdb_api_service.dart';
import '../../data/services/tmdb_dio_client.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/streaming_provider.dart';
import '../../domain/repositories/movies_repository.dart';
import '../controllers/discover_movies_params.dart';

part 'movies_providers.g.dart';

@riverpod
Dio tmdbDio(Ref ref) {
  return const TmdbDioClient().create();
}

@riverpod
TmdbApiService tmdbApiService(Ref ref) {
  return TmdbApiService(ref.watch(tmdbDioProvider));
}

@riverpod
MoviesCacheStore moviesCacheStore(Ref ref) {
  return MoviesCacheStore();
}

@riverpod
MoviesRepository moviesRepository(Ref ref) {
  return TmdbMoviesRepository(
    ref.watch(tmdbApiServiceProvider),
    ref.watch(moviesCacheStoreProvider),
  );
}

@riverpod
Future<List<Genre>> genres(Ref ref) {
  return ref.watch(moviesRepositoryProvider).getGenres();
}

@riverpod
Future<List<StreamingProvider>> streamingProviders(Ref ref) {
  return ref.watch(moviesRepositoryProvider).getProviders();
}

@riverpod
Future<List<Movie>> discoverMovies(Ref ref, DiscoverMoviesParams params) {
  return ref
      .watch(moviesRepositoryProvider)
      .discoverMovies(
        genreIds: params.genreIds,
        providerIds: params.providerIds,
        minRating: params.minRating,
        releaseYear: params.releaseYear,
      );
}
