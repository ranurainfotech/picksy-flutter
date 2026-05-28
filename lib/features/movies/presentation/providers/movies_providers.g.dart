// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tmdbDio)
final tmdbDioProvider = TmdbDioProvider._();

final class TmdbDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  TmdbDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tmdbDioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tmdbDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return tmdbDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$tmdbDioHash() => r'545193141856038af657f5c650d36474b4711c34';

@ProviderFor(tmdbApiService)
final tmdbApiServiceProvider = TmdbApiServiceProvider._();

final class TmdbApiServiceProvider
    extends $FunctionalProvider<TmdbApiService, TmdbApiService, TmdbApiService>
    with $Provider<TmdbApiService> {
  TmdbApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tmdbApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tmdbApiServiceHash();

  @$internal
  @override
  $ProviderElement<TmdbApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TmdbApiService create(Ref ref) {
    return tmdbApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TmdbApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TmdbApiService>(value),
    );
  }
}

String _$tmdbApiServiceHash() => r'47be788b4fdd509382e655a5f1db97ba6620feb8';

@ProviderFor(moviesCacheStore)
final moviesCacheStoreProvider = MoviesCacheStoreProvider._();

final class MoviesCacheStoreProvider
    extends
        $FunctionalProvider<
          MoviesCacheStore,
          MoviesCacheStore,
          MoviesCacheStore
        >
    with $Provider<MoviesCacheStore> {
  MoviesCacheStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moviesCacheStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moviesCacheStoreHash();

  @$internal
  @override
  $ProviderElement<MoviesCacheStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MoviesCacheStore create(Ref ref) {
    return moviesCacheStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoviesCacheStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoviesCacheStore>(value),
    );
  }
}

String _$moviesCacheStoreHash() => r'a1010210fdbeede6467de321ae9f9e3dc315f5d2';

@ProviderFor(moviesRepository)
final moviesRepositoryProvider = MoviesRepositoryProvider._();

final class MoviesRepositoryProvider
    extends
        $FunctionalProvider<
          MoviesRepository,
          MoviesRepository,
          MoviesRepository
        >
    with $Provider<MoviesRepository> {
  MoviesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moviesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moviesRepositoryHash();

  @$internal
  @override
  $ProviderElement<MoviesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MoviesRepository create(Ref ref) {
    return moviesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoviesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoviesRepository>(value),
    );
  }
}

String _$moviesRepositoryHash() => r'1d796d21a248f0c4776b5e3e2c1144ec3743bf3c';

@ProviderFor(genres)
final genresProvider = GenresProvider._();

final class GenresProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Genre>>,
          List<Genre>,
          FutureOr<List<Genre>>
        >
    with $FutureModifier<List<Genre>>, $FutureProvider<List<Genre>> {
  GenresProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genresProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genresHash();

  @$internal
  @override
  $FutureProviderElement<List<Genre>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Genre>> create(Ref ref) {
    return genres(ref);
  }
}

String _$genresHash() => r'6ef36eab0be103159d4ba81bc6f2a4dc2e939f1c';

@ProviderFor(streamingProviders)
final streamingProvidersProvider = StreamingProvidersProvider._();

final class StreamingProvidersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StreamingProvider>>,
          List<StreamingProvider>,
          FutureOr<List<StreamingProvider>>
        >
    with
        $FutureModifier<List<StreamingProvider>>,
        $FutureProvider<List<StreamingProvider>> {
  StreamingProvidersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamingProvidersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamingProvidersHash();

  @$internal
  @override
  $FutureProviderElement<List<StreamingProvider>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StreamingProvider>> create(Ref ref) {
    return streamingProviders(ref);
  }
}

String _$streamingProvidersHash() =>
    r'cf38f20087ab9ec7eb524616c8ed28b8909acd58';

@ProviderFor(discoverMovies)
final discoverMoviesProvider = DiscoverMoviesFamily._();

final class DiscoverMoviesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Movie>>,
          List<Movie>,
          FutureOr<List<Movie>>
        >
    with $FutureModifier<List<Movie>>, $FutureProvider<List<Movie>> {
  DiscoverMoviesProvider._({
    required DiscoverMoviesFamily super.from,
    required DiscoverMoviesParams super.argument,
  }) : super(
         retry: null,
         name: r'discoverMoviesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$discoverMoviesHash();

  @override
  String toString() {
    return r'discoverMoviesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Movie>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Movie>> create(Ref ref) {
    final argument = this.argument as DiscoverMoviesParams;
    return discoverMovies(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DiscoverMoviesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$discoverMoviesHash() => r'08fbc7fa171c9dfd0fb06ae4afebdb9c283042ea';

final class DiscoverMoviesFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<Movie>>, DiscoverMoviesParams> {
  DiscoverMoviesFamily._()
    : super(
        retry: null,
        name: r'discoverMoviesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiscoverMoviesProvider call(DiscoverMoviesParams params) =>
      DiscoverMoviesProvider._(argument: params, from: this);

  @override
  String toString() => r'discoverMoviesProvider';
}
