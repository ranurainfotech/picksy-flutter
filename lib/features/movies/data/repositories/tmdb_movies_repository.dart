import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/streaming_provider.dart';
import '../../domain/repositories/movies_repository.dart';
import '../../presentation/controllers/supported_providers.dart';
import '../dto/genre_dto.dart';
import '../dto/streaming_provider_dto.dart';
import '../services/movies_cache_store.dart';
import '../services/tmdb_api_service.dart';

class TmdbMoviesRepository implements MoviesRepository {
  TmdbMoviesRepository(this._api, this._cacheStore);

  final TmdbApiService _api;
  final MoviesCacheStore _cacheStore;
  static const _defaultReleaseDateUpperBound = '2100-12-31';
  static const _defaultReleaseDateLowerBound = '1900-01-01';

  @override
  Future<List<Genre>> getGenres() async {
    final cached = await _cacheStore.readGenres();
    if (cached != null && cached.isNotEmpty) {
      return cached
          .map(GenreDto.fromJson)
          .map((dto) => Genre(id: dto.id, name: dto.name))
          .toList(growable: false);
    }

    final response = await _api.getGenres();
    await _cacheStore.writeGenres(
      response.genres.map((genre) => genre.toJson()).toList(growable: false),
    );
    return response.genres
        .map((dto) => Genre(id: dto.id, name: dto.name))
        .toList(growable: false);
  }

  @override
  Future<List<StreamingProvider>> getProviders() async {
    final cached = await _cacheStore.readProviders();
    if (cached != null && cached.isNotEmpty) {
      return cached
          .map(StreamingProviderDto.fromJson)
          .map(
            (dto) => StreamingProvider(
              id: dto.providerId,
              name: dto.providerName,
              logoPath: dto.logoPath,
            ),
          )
          .toList(growable: false);
    }

    final byId = <int, StreamingProviderDto>{};
    final response = await _api.getWatchProviders();
    for (final provider in response.results) {
      if (supportedProviderIds.contains(provider.providerId)) {
        byId[provider.providerId] = provider;
      }
    }

    final curatedProviders = <StreamingProviderDto>[
      for (final id in supportedProviderIds)
        if (byId.containsKey(id)) byId[id]!,
    ];

    await _cacheStore.writeProviders(
      curatedProviders
          .map((provider) => provider.toJson())
          .toList(growable: false),
    );
    return curatedProviders
        .map(
          (dto) => StreamingProvider(
            id: dto.providerId,
            name: dto.providerName,
            logoPath: dto.logoPath,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<Movie>> discoverMovies({
    required List<int> genreIds,
    required List<int> providerIds,
    required double minRating,
    required int releaseYear,
    String sortBy = 'popularity.desc',
    int page = 1,
  }) async {
    final pageResult = await discoverMoviesPage(
      genreIds: genreIds,
      providerIds: providerIds,
      minRating: minRating,
      releaseYear: releaseYear,
      sortBy: sortBy,
      page: page,
    );
    return pageResult.movies;
  }

  @override
  Future<({List<Movie> movies, int totalPages, int totalResults})> discoverMoviesPage({
    required List<int> genreIds,
    required List<int> providerIds,
    required double minRating,
    required int releaseYear,
    String sortBy = 'popularity.desc',
    int page = 1,
  }) async {
    final response = await _api.discoverMovies(
      // Pipe = OR (comma = AND, which is too restrictive for multi-genre rooms).
      withGenres: genreIds.isEmpty ? null : genreIds.join('|'),
      voteAverageGte: minRating,
      primaryReleaseDateGte: releaseYear > 0
          ? '$releaseYear-01-01'
          : _defaultReleaseDateLowerBound,
      primaryReleaseDateLte: _defaultReleaseDateUpperBound,
      withWatchProviders: providerIds.isEmpty ? null : providerIds.join('|'),
      sortBy: sortBy,
      page: page,
    );

    final movies = response.results
        .map(
          (dto) => Movie(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            voteAverage: dto.voteAverage,
            releaseDate: dto.releaseDate,
          ),
        )
        .toList(growable: false);

    return (
      movies: movies,
      totalPages: response.totalPages,
      totalResults: response.totalResults,
    );
  }

  @override
  Future<Movie?> getMovieById(int movieId) async {
    try {
      final dto = await _api.getMovieDetails(movieId: movieId);
      return Movie(
        id: dto.id,
        title: dto.title,
        overview: dto.overview,
        posterPath: dto.posterPath,
        backdropPath: dto.backdropPath,
        voteAverage: dto.voteAverage,
        releaseDate: dto.releaseDate,
      );
    } catch (_) {
      return null;
    }
  }
}
