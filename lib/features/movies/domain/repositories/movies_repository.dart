import '../entities/genre.dart';
import '../entities/movie.dart';
import '../entities/streaming_provider.dart';

abstract class MoviesRepository {
  Future<List<Genre>> getGenres();
  Future<List<StreamingProvider>> getProviders();
  Future<List<Movie>> discoverMovies({
    required List<int> genreIds,
    required List<int> providerIds,
    required double minRating,
    required int releaseYear,
    String sortBy = 'popularity.desc',
    int page = 1,
  });

  Future<({List<Movie> movies, int totalPages, int totalResults})> discoverMoviesPage({
    required List<int> genreIds,
    required List<int> providerIds,
    required double minRating,
    required int releaseYear,
    String sortBy = 'popularity.desc',
    int page = 1,
  });

  Future<Movie?> getMovieById(int movieId);
}
