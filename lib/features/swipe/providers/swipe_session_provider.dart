import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/analytics_provider.dart';
import '../../../core/services/analytics/analytics_helpers.dart';
import '../../../core/services/analytics/analytics_screens.dart';
import '../../auth/providers/auth_providers.dart';
import '../../movies/domain/entities/genre.dart';
import '../../movies/domain/entities/movie.dart';
import '../../movies/domain/entities/streaming_provider.dart';
import '../../movies/presentation/providers/movies_providers.dart';
import '../../places/domain/entities/place.dart';
import '../../places/places_load_errors.dart';
import '../../places/presentation/providers/places_providers.dart';
import '../../rooms/models/room_filters.dart';
import '../../rooms/providers/room_repository_provider.dart';
import '../../../core/services/analytics/swipe_submit_outcome.dart';
import '../models/swipe_decision.dart';
import 'swipe_repository_provider.dart';

class SwipeSessionState {
  const SwipeSessionState({
    this.category = 'movies',
    this.movies = const <Movie>[],
    this.places = const <Place>[],
    this.currentIndex = 0,
    this.isFetchingMore = false,
    this.errorMessage,
    this.endReached = false,
    this.queueIds = const <int>[],
    this.placeQueueIds = const <String>[],
    this.visibleQueueIds = const <int>[],
    this.visiblePlaceQueueIds = const <String>[],
    this.loadedVisibleCount = 0,
    this.nextPageToken,
  });

  final String category;
  final List<Movie> movies;
  final List<Place> places;
  final int currentIndex;
  final bool isFetchingMore;
  final String? errorMessage;
  final bool endReached;
  final List<int> queueIds;
  final List<String> placeQueueIds;
  final List<int> visibleQueueIds;
  final List<String> visiblePlaceQueueIds;
  final int loadedVisibleCount;
  final String? nextPageToken;

  bool get isRestaurantRoom => category == 'restaurants';

  SwipeSessionState copyWith({
    String? category,
    List<Movie>? movies,
    List<Place>? places,
    int? currentIndex,
    bool? isFetchingMore,
    String? errorMessage,
    bool clearError = false,
    bool? endReached,
    List<int>? queueIds,
    List<String>? placeQueueIds,
    List<int>? visibleQueueIds,
    List<String>? visiblePlaceQueueIds,
    int? loadedVisibleCount,
    String? nextPageToken,
    bool clearNextPageToken = false,
  }) {
    return SwipeSessionState(
      category: category ?? this.category,
      movies: movies ?? this.movies,
      places: places ?? this.places,
      currentIndex: currentIndex ?? this.currentIndex,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      endReached: endReached ?? this.endReached,
      queueIds: queueIds ?? this.queueIds,
      placeQueueIds: placeQueueIds ?? this.placeQueueIds,
      visibleQueueIds: visibleQueueIds ?? this.visibleQueueIds,
      visiblePlaceQueueIds:
          visiblePlaceQueueIds ?? this.visiblePlaceQueueIds,
      loadedVisibleCount: loadedVisibleCount ?? this.loadedVisibleCount,
      nextPageToken:
          clearNextPageToken ? null : (nextPageToken ?? this.nextPageToken),
    );
  }
}

final swipeSessionProvider = AsyncNotifierProvider.autoDispose
    .family<SwipeSessionNotifier, SwipeSessionState, String>(
      SwipeSessionNotifier.new,
    );

class SwipeSessionNotifier extends AsyncNotifier<SwipeSessionState> {
  SwipeSessionNotifier(this.roomId);

  final String roomId;

  static const _initialBatchSize = 20;
  static const _incrementBatchSize = 15;

  bool _loggedSessionStart = false;
  bool _loggedSessionComplete = false;
  int _sessionSwipeCount = 0;
  int _sessionMatchCount = 0;
  String _genreLabel = 'unknown';
  int _roomSize = 1;

  @override
  Future<SwipeSessionState> build() => _load();

  Future<void> retry({bool clearQueue = true}) async {
    if (clearQueue) {
      try {
        final currentCategory =
            state.asData?.value.category ??
            (await ref.read(roomRepositoryProvider).getRoom(roomId))
                .data()?['category'] as String? ??
            'movies';
        if (currentCategory == 'restaurants') {
          await ref.read(roomRepositoryProvider).clearPlaceDeck(roomId: roomId);
        } else {
          await ref.read(roomRepositoryProvider).upsertMovieQueue(
                roomId: roomId,
                movieQueue: const <int>[],
              );
        }
      } catch (error, stackTrace) {
        unawaited(
          ref.read(crashReportingServiceProvider).recordError(
                error,
                stackTrace,
                fatal: false,
              ),
        );
      }
    }
    ref.invalidateSelf();
  }

  Future<SwipeSessionState> _load() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    final roomSnapshot = await ref.read(roomRepositoryProvider).getRoom(roomId);
    final roomData = roomSnapshot.data() ?? const <String, dynamic>{};
    final category = (roomData['category'] as String? ?? 'movies').toLowerCase();

    try {
      if (category == 'restaurants') {
        return await _loadRestaurantDeck(roomData, uid);
      }
      return await _loadMovieDeck(roomData, uid);
    } catch (error, stackTrace) {
      debugPrint('[SwipeSession] Load failed for $roomId ($category): $error');
      debugPrint('$stackTrace');
      unawaited(
        ref.read(crashReportingServiceProvider).recordError(
              error,
              stackTrace,
              fatal: false,
            ),
      );
      return SwipeSessionState(
        category: category,
        endReached: true,
        errorMessage: placesLoadErrorMessage(error, category: category),
      );
    }
  }

  Future<SwipeSessionState> _loadMovieDeck(
    Map<String, dynamic> roomData,
    String? uid,
  ) async {
    final filters = await _resolveFilters(roomData['filters']);
    final members = (roomData['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toList(growable: false);
    _genreLabel = genreLabelFromFilters(filters);
    _roomSize = members.isEmpty ? 1 : members.length;

    if (!_loggedSessionStart) {
      _loggedSessionStart = true;
      final analytics = ref.read(analyticsServiceProvider);
      unawaited(analytics.logSwipeSessionStarted());
      unawaited(analytics.logScreenView(AnalyticsScreens.swipe));
    }

    final swipedIds = uid == null
        ? <int>{}
        : await ref.read(swipeRepositoryProvider).getSwipedMovieIds(
            roomId: roomId,
            userId: uid,
          );

    var queueIds = _parseMovieQueueIds(roomData['movieQueue']);
    final discovered = await _fetchDeckFromDiscover(
      filters: filters,
      swipedIds: swipedIds,
      minCount: _initialBatchSize,
    );

    var movies = await _buildDeckFromDiscoverAndQueue(
      discovered: discovered,
      queueIds: queueIds,
      swipedIds: swipedIds,
    );

    if (movies.isEmpty) {
      return SwipeSessionState(
        category: 'movies',
        endReached: true,
        queueIds: queueIds,
        visibleQueueIds: const <int>[],
        errorMessage: swipedIds.isNotEmpty
            ? 'No new movies left for these filters. Try loosening filters or tap Try Again.'
            : 'No movies found for these filters. Try loosening genres or providers.',
      );
    }

    var visibleQueueIds = queueIds
        .where((id) => !swipedIds.contains(id))
        .toList(growable: false);

    if (queueIds.isEmpty || visibleQueueIds.isEmpty) {
      queueIds = movies.map((movie) => movie.id).toList(growable: false);
      visibleQueueIds = queueIds;
      unawaited(
        ref.read(roomRepositoryProvider).upsertMovieQueue(
              roomId: roomId,
              movieQueue: queueIds,
            ),
      );
    }

    return SwipeSessionState(
      category: 'movies',
      movies: movies,
      currentIndex: 0,
      endReached: false,
      queueIds: queueIds,
      visibleQueueIds: visibleQueueIds,
      loadedVisibleCount: movies.length,
    );
  }

  Future<SwipeSessionState> _loadRestaurantDeck(
    Map<String, dynamic> roomData,
    String? uid,
  ) async {
    final filters = _parseRoomFilters(roomData['filters']);
    final members = (roomData['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toList(growable: false);
    _genreLabel = 'restaurants';
    _roomSize = members.isEmpty ? 1 : members.length;

    if (!_loggedSessionStart) {
      _loggedSessionStart = true;
      final analytics = ref.read(analyticsServiceProvider);
      unawaited(analytics.logSwipeSessionStarted());
      unawaited(analytics.logScreenView(AnalyticsScreens.swipe));
    }

    if (filters.lat == 0 || filters.lng == 0) {
      debugPrint(
        '[SwipeSession] Restaurant room $roomId missing location '
        '(lat=${filters.lat}, lng=${filters.lng})',
      );
      return const SwipeSessionState(
        category: 'restaurants',
        endReached: true,
        errorMessage:
            'This room needs a location. Edit room setup and pick an area.',
      );
    }

    final swipedIds = uid == null
        ? <String>{}
        : await ref.read(swipeRepositoryProvider).getSwipedPlaceIds(
            roomId: roomId,
            userId: uid,
          );

    var queueIds = _parsePlaceQueueIds(roomData['placeQueue']);
    final placeCache = _parsePlaceCache(roomData['placeCache']);

    final visibleQueueIds = queueIds
        .where((id) => !swipedIds.contains(id))
        .toList(growable: false);

    if (_canServeRestaurantDeckFromCache(
      queueIds: queueIds,
      placeCache: placeCache,
      swipedIds: swipedIds,
    )) {
      final places = _buildPlaceDeck(
        discovered: const <Place>[],
        queueIds: queueIds,
        swipedIds: swipedIds,
        placeCache: placeCache,
      );
      debugPrint(
        '[SwipeSession] Serving ${places.length} cached restaurants for $roomId',
      );
      return SwipeSessionState(
        category: 'restaurants',
        places: places,
        currentIndex: 0,
        endReached: false,
        placeQueueIds: queueIds,
        visiblePlaceQueueIds: visibleQueueIds,
        loadedVisibleCount: places.length,
      );
    }

    debugPrint(
      '[SwipeSession] Loading restaurants for $roomId at '
      '${filters.lat},${filters.lng} radius=${filters.radiusMeters}m',
    );
    final searchResult = await ref.read(placesRepositoryProvider).searchRestaurants(
          lat: filters.lat,
          lng: filters.lng,
          radiusMeters: filters.radiusMeters,
          minRating: filters.minRating,
          priceLevels: filters.priceLevels,
          cuisineTypes: filters.cuisineTypes.isEmpty
              ? const <String>['restaurant']
              : filters.cuisineTypes,
          openNow: filters.openNow,
          excludedPlaceIds: swipedIds.toList(growable: false),
        );

    var places = _buildPlaceDeck(
      discovered: searchResult.places,
      queueIds: queueIds,
      swipedIds: swipedIds,
      placeCache: placeCache,
    );

    if (places.isEmpty) {
      return SwipeSessionState(
        category: 'restaurants',
        endReached: true,
        placeQueueIds: queueIds,
        visiblePlaceQueueIds: const <String>[],
        errorMessage: swipedIds.isNotEmpty
            ? 'No new restaurants left nearby. Widen radius or tap Try Again.'
            : 'No restaurants found nearby. Widen radius or change cuisine filters.',
      );
    }

    if (queueIds.isEmpty || visibleQueueIds.isEmpty) {
      queueIds = places.map((place) => place.placeId).toList(growable: false);
    }

    final nextVisibleQueueIds = queueIds
        .where((id) => !swipedIds.contains(id))
        .toList(growable: false);

    unawaited(
      ref.read(roomRepositoryProvider).upsertPlaceDeck(
            roomId: roomId,
            placeQueue: queueIds,
            places: places,
          ),
    );

    return SwipeSessionState(
      category: 'restaurants',
      places: places,
      currentIndex: 0,
      endReached: false,
      placeQueueIds: queueIds,
      visiblePlaceQueueIds: nextVisibleQueueIds,
      loadedVisibleCount: places.length,
      nextPageToken: searchResult.nextPageToken,
    );
  }

  bool _canServeRestaurantDeckFromCache({
    required List<String> queueIds,
    required Map<String, Place> placeCache,
    required Set<String> swipedIds,
  }) {
    if (queueIds.isEmpty || placeCache.isEmpty) {
      return false;
    }

    final visibleIds =
        queueIds.where((id) => !swipedIds.contains(id)).toList(growable: false);
    if (visibleIds.isEmpty) {
      return false;
    }

    for (final id in visibleIds) {
      final cached = placeCache[id];
      if (cached == null || cached.placeId.isEmpty) {
        return false;
      }
    }

    return true;
  }

  Map<String, Place> _parsePlaceCache(Object? rawCache) {
    if (rawCache is! Map) {
      return const <String, Place>{};
    }

    final cache = <String, Place>{};
    for (final entry in rawCache.entries) {
      final key = '${entry.key}';
      final value = entry.value;
      if (key.isEmpty || value is! Map) {
        continue;
      }
      final place = Place.fromCacheJson(Map<String, dynamic>.from(value));
      if (place.placeId.isNotEmpty) {
        cache[place.placeId] = place;
      }
    }
    return cache;
  }

  List<Place> _buildPlaceDeck({
    required List<Place> discovered,
    required List<String> queueIds,
    required Set<String> swipedIds,
    Map<String, Place> placeCache = const <String, Place>{},
  }) {
    final byId = {
      ...placeCache,
      for (final place in discovered) place.placeId: place,
    };
    final deck = <Place>[];

    for (final id in queueIds) {
      if (swipedIds.contains(id)) {
        continue;
      }
      final cached = byId[id];
      if (cached != null) {
        deck.add(cached);
      }
    }

    for (final place in discovered) {
      if (swipedIds.contains(place.placeId)) {
        continue;
      }
      if (deck.any((entry) => entry.placeId == place.placeId)) {
        continue;
      }
      deck.add(place);
    }

    return deck;
  }

  Future<List<Movie>> _fetchDeckFromDiscover({
    required RoomFilters filters,
    required Set<int> swipedIds,
    required int minCount,
    int startPage = 1,
  }) async {
    final repo = ref.read(moviesRepositoryProvider);
    final movies = <Movie>[];
    final seen = <int>{};
    var lastPage = 10;

    for (var page = startPage; page <= lastPage && movies.length < minCount; page += 1) {
      final pageResult = await repo.discoverMoviesPage(
        genreIds: filters.genreIds,
        providerIds: filters.providerIds,
        minRating: filters.minRating,
        releaseYear: filters.releaseYear,
        sortBy: filters.sortBy,
        page: page,
      );
      lastPage = pageResult.totalPages;

      if (pageResult.movies.isEmpty) {
        if (page >= lastPage) {
          break;
        }
        continue;
      }

      for (final movie in pageResult.movies) {
        if (!seen.add(movie.id) || swipedIds.contains(movie.id)) {
          continue;
        }
        movies.add(movie);
        if (movies.length >= minCount) {
          break;
        }
      }

      if (page >= lastPage) {
        break;
      }
    }

    return movies;
  }

  Future<List<Movie>> _buildDeckFromDiscoverAndQueue({
    required List<Movie> discovered,
    required List<int> queueIds,
    required Set<int> swipedIds,
  }) async {
    final repo = ref.read(moviesRepositoryProvider);
    final byId = <int, Movie>{for (final movie in discovered) movie.id: movie};
    final deck = <Movie>[];

    for (final id in queueIds) {
      if (swipedIds.contains(id)) {
        continue;
      }
      final cached = byId[id];
      if (cached != null) {
        deck.add(cached);
        continue;
      }
      final movie = await repo.getMovieById(id);
      if (movie != null) {
        byId[movie.id] = movie;
        deck.add(movie);
      }
    }

    for (final movie in discovered) {
      if (swipedIds.contains(movie.id)) {
        continue;
      }
      if (deck.any((entry) => entry.id == movie.id)) {
        continue;
      }
      deck.add(movie);
    }

    return deck;
  }

  List<int> _parseMovieQueueIds(Object? rawQueue) {
    if (rawQueue is! List) {
      return const <int>[];
    }

    final ids = <int>[];
    for (final entry in rawQueue) {
      final parsed = switch (entry) {
        final int value => value,
        final num value => value.toInt(),
        final String value => int.tryParse(value),
        _ => null,
      };
      if (parsed != null) {
        ids.add(parsed);
      }
    }
    return ids;
  }

  List<String> _parsePlaceQueueIds(Object? rawQueue) {
    if (rawQueue is! List) {
      return const <String>[];
    }
    return rawQueue.map((entry) => '$entry').where((id) => id.isNotEmpty).toList(
          growable: false,
        );
  }

  Future<RoomFilters> _resolveFilters(Object? rawFilters) async {
    final map = _toStringDynamicMap(rawFilters);
    if (map == null) {
      return const RoomFilters();
    }

    final parsed = _parseRoomFilters(map);
    if (parsed.genreIds.isNotEmpty) {
      return parsed;
    }

    final legacyGenreNames = _stringList(map['genres']);
    final legacyProviderNames = _stringList(map['streamingPlatforms']);
    if (legacyGenreNames.isEmpty && legacyProviderNames.isEmpty) {
      return parsed;
    }

    final genres = await ref.read(genresProvider.future);
    final providers = await ref.read(streamingProvidersProvider.future);
    final matchedGenreIds = _matchGenreIds(genres, legacyGenreNames);
    final matchedProviderIds = _matchProviderIds(providers, legacyProviderNames);

    return parsed.copyWith(
      genreIds: matchedGenreIds.isEmpty ? parsed.genreIds : matchedGenreIds,
      providerIds:
          matchedProviderIds.isEmpty ? parsed.providerIds : matchedProviderIds,
    );
  }

  RoomFilters _parseRoomFilters(Map<String, dynamic> map) {
    return RoomFilters(
      genreIds: _parseIntList(map['genreIds']),
      providerIds: _parseIntList(map['providerIds']),
      minRating: (map['minRating'] as num?)?.toDouble() ?? 0,
      releaseYear: (map['releaseYear'] as num?)?.toInt() ?? 0,
      sortBy: map['sortBy'] as String? ?? 'popularity.desc',
      locationLabel: map['locationLabel'] as String? ?? '',
      lat: (map['lat'] as num?)?.toDouble() ?? 0,
      lng: (map['lng'] as num?)?.toDouble() ?? 0,
      radiusMeters: (map['radiusMeters'] as num?)?.toInt() ?? 5000,
      priceLevels: _parseIntList(map['priceLevels']),
      cuisineTypes: _stringList(map['cuisineTypes']),
      openNow: map['openNow'] as bool? ?? false,
    );
  }

  List<int> _parseIntList(Object? value) {
    if (value is! List) {
      return const <int>[];
    }
    final ids = <int>[];
    for (final entry in value) {
      final parsed = switch (entry) {
        final int v => v,
        final num v => v.toInt(),
        final String v => int.tryParse(v),
        _ => null,
      };
      if (parsed != null) {
        ids.add(parsed);
      }
    }
    return ids;
  }

  Map<String, dynamic>? _toStringDynamicMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, entry) => MapEntry('$key', entry));
    }
    return null;
  }

  List<String> _stringList(Object? value) {
    if (value is! List) {
      return const <String>[];
    }
    return value
        .map((item) => '$item'.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  List<int> _matchGenreIds(List<Genre> genres, List<String> names) {
    if (names.isEmpty) {
      return const <int>[];
    }
    final normalized = names.map(_normalize).toSet();
    return [
      for (final genre in genres)
        if (normalized.contains(_normalize(genre.name))) genre.id,
    ];
  }

  List<int> _matchProviderIds(
    List<StreamingProvider> providers,
    List<String> names,
  ) {
    if (names.isEmpty) {
      return const <int>[];
    }
    final normalized = names.map(_normalize).toSet();
    return [
      for (final provider in providers)
        if (normalized.contains(_normalize(provider.name))) provider.id,
    ];
  }

  String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  Future<void> submitSwipe({
    required SwipeDecision decision,
  }) async {
    final current = state.asData?.value;
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (current == null || uid == null) {
      return;
    }

    if (current.isRestaurantRoom) {
      await _submitPlaceSwipe(current, uid, decision);
      return;
    }
    await _submitMovieSwipe(current, uid, decision);
  }

  Future<void> _submitMovieSwipe(
    SwipeSessionState current,
    String uid,
    SwipeDecision decision,
  ) async {
    if (current.currentIndex >= current.movies.length) {
      return;
    }

    final movie = current.movies[current.currentIndex];
    final queueIndex = current.queueIds.indexOf(movie.id);
    final nextIndex = queueIndex < 0 ? current.currentIndex + 1 : queueIndex + 1;

    final nextLocalIndex = current.currentIndex + 1;
    state = AsyncData(
      current.copyWith(
        currentIndex: nextLocalIndex,
        endReached: nextLocalIndex >= current.movies.length &&
            current.loadedVisibleCount >= current.visibleQueueIds.length,
      ),
    );

    SwipeSubmitOutcome outcome;
    try {
      outcome = await ref.read(swipeRepositoryProvider).submitSwipe(
            roomId: roomId,
            userId: uid,
            movie: movie,
            decision: decision,
            nextIndex: nextIndex,
          );
    } catch (error, stackTrace) {
      state = AsyncData(current);
      unawaited(
        ref.read(crashReportingServiceProvider).recordError(
              error,
              stackTrace,
              fatal: false,
            ),
      );
      return;
    }

    await _afterSwipeSubmitted(current, movie.id, decision, outcome);
  }

  Future<void> _submitPlaceSwipe(
    SwipeSessionState current,
    String uid,
    SwipeDecision decision,
  ) async {
    if (current.currentIndex >= current.places.length) {
      return;
    }

    final place = current.places[current.currentIndex];
    final queueIndex = current.placeQueueIds.indexOf(place.placeId);
    final nextIndex =
        queueIndex < 0 ? current.currentIndex + 1 : queueIndex + 1;

    final nextLocalIndex = current.currentIndex + 1;
    state = AsyncData(
      current.copyWith(
        currentIndex: nextLocalIndex,
        endReached: nextLocalIndex >= current.places.length &&
            current.loadedVisibleCount >= current.visiblePlaceQueueIds.length &&
            current.nextPageToken == null,
      ),
    );

    SwipeSubmitOutcome outcome;
    try {
      outcome = await ref.read(swipeRepositoryProvider).submitPlaceSwipe(
            roomId: roomId,
            userId: uid,
            place: place,
            decision: decision,
            nextIndex: nextIndex,
          );
    } catch (error, stackTrace) {
      state = AsyncData(current);
      unawaited(
        ref.read(crashReportingServiceProvider).recordError(
              error,
              stackTrace,
              fatal: false,
            ),
      );
      return;
    }

    await _afterSwipeSubmitted(current, place.placeId.hashCode, decision, outcome);
  }

  Future<void> _afterSwipeSubmitted(
    SwipeSessionState current,
    int analyticsItemId,
    SwipeDecision decision,
    SwipeSubmitOutcome outcome,
  ) async {
    _sessionSwipeCount += 1;
    if (outcome.matchCreated) {
      _sessionMatchCount += 1;
    }

    final analytics = ref.read(analyticsServiceProvider);
    final roomSize = outcome.memberCount > 0 ? outcome.memberCount : _roomSize;
    unawaited(
      switch (decision) {
        SwipeDecision.liked => analytics.logMovieLiked(
            movieId: analyticsItemId,
            genre: _genreLabel,
            roomSize: roomSize,
          ),
        SwipeDecision.disliked => analytics.logMovieDisliked(
            movieId: analyticsItemId,
            genre: _genreLabel,
            roomSize: roomSize,
          ),
        SwipeDecision.maybe => analytics.logMovieMaybe(
            movieId: analyticsItemId,
            genre: _genreLabel,
            roomSize: roomSize,
          ),
      },
    );

    final nextState = state.asData!.value;

    if (nextState.endReached && !_loggedSessionComplete) {
      _loggedSessionComplete = true;
      unawaited(
        analytics.logSwipeSessionCompleted(
          totalSwipes: _sessionSwipeCount,
          totalMatches: _sessionMatchCount,
        ),
      );
    }

    await fetchMoreIfNeeded();
  }

  Future<void> fetchMoreIfNeeded() async {
    final current = state.asData?.value;
    if (current == null || current.isFetchingMore) {
      return;
    }

    if (current.isRestaurantRoom) {
      await _fetchMorePlacesIfNeeded(current);
      return;
    }

    final remainingLoaded = current.movies.length - current.currentIndex;
    if (remainingLoaded > 4) {
      return;
    }
    if (current.loadedVisibleCount >= current.visibleQueueIds.length) {
      state = AsyncData(
        current.copyWith(
          endReached: current.currentIndex >= current.movies.length,
        ),
      );
      return;
    }

    state = AsyncData(current.copyWith(isFetchingMore: true, clearError: true));

    try {
      final roomSnapshot = await ref.read(roomRepositoryProvider).getRoom(roomId);
      final filters = await _resolveFilters(roomSnapshot.data()?['filters']);
      final uid = ref.read(authRepositoryProvider).currentUser?.uid;
      final swipedIds = uid == null
          ? <int>{}
          : await ref.read(swipeRepositoryProvider).getSwipedMovieIds(
              roomId: roomId,
              userId: uid,
            );
      final alreadyLoaded = current.movies.map((movie) => movie.id).toSet();
      final moreMovies = await _fetchDeckFromDiscover(
        filters: filters,
        swipedIds: {...swipedIds, ...alreadyLoaded},
        minCount: _incrementBatchSize,
        startPage: (current.movies.length ~/ 20) + 1,
      );
      final mergedMovies = List<Movie>.from(current.movies)..addAll(moreMovies);
      final nextLoadedCount = min(
        current.loadedVisibleCount + moreMovies.length,
        current.visibleQueueIds.length,
      );

      state = AsyncData(
        current.copyWith(
          movies: mergedMovies,
          loadedVisibleCount: nextLoadedCount,
          isFetchingMore: false,
          endReached: moreMovies.isEmpty &&
              current.currentIndex >= mergedMovies.length,
        ),
      );
    } catch (_) {
      state = AsyncData(
        current.copyWith(
          isFetchingMore: false,
          errorMessage: 'Could not load more movies.',
        ),
      );
    }
  }

  Future<void> _fetchMorePlacesIfNeeded(SwipeSessionState current) async {
    final remainingLoaded = current.places.length - current.currentIndex;
    if (remainingLoaded > 4) {
      return;
    }

    if (current.nextPageToken == null &&
        current.loadedVisibleCount >= current.visiblePlaceQueueIds.length) {
      state = AsyncData(
        current.copyWith(
          endReached: current.currentIndex >= current.places.length,
        ),
      );
      return;
    }

    state = AsyncData(current.copyWith(isFetchingMore: true, clearError: true));

    try {
      final roomSnapshot = await ref.read(roomRepositoryProvider).getRoom(roomId);
      final filters = _parseRoomFilters(roomSnapshot.data()?['filters']);
      final uid = ref.read(authRepositoryProvider).currentUser?.uid;
      final swipedIds = uid == null
          ? <String>{}
          : await ref.read(swipeRepositoryProvider).getSwipedPlaceIds(
              roomId: roomId,
              userId: uid,
            );
      final alreadyLoaded =
          current.places.map((place) => place.placeId).toSet();

      final searchResult =
          await ref.read(placesRepositoryProvider).searchRestaurants(
                lat: filters.lat,
                lng: filters.lng,
                radiusMeters: filters.radiusMeters,
                minRating: filters.minRating,
                priceLevels: filters.priceLevels,
                cuisineTypes: filters.cuisineTypes.isEmpty
                    ? const <String>['restaurant']
                    : filters.cuisineTypes,
                openNow: filters.openNow,
                pageToken: current.nextPageToken,
                excludedPlaceIds: {
                  ...swipedIds,
                  ...alreadyLoaded,
                }.toList(growable: false),
              );

      final newPlaces = searchResult.places
          .where((place) => !alreadyLoaded.contains(place.placeId))
          .toList(growable: false);
      final mergedPlaces = List<Place>.from(current.places)..addAll(newPlaces);
      final mergedQueueIds = [
        ...current.placeQueueIds,
        ...newPlaces.map((place) => place.placeId),
      ];

      unawaited(
        ref.read(roomRepositoryProvider).upsertPlaceDeck(
              roomId: roomId,
              placeQueue: mergedQueueIds,
              places: mergedPlaces,
            ),
      );

      state = AsyncData(
        current.copyWith(
          places: mergedPlaces,
          placeQueueIds: mergedQueueIds,
          loadedVisibleCount: mergedPlaces.length,
          isFetchingMore: false,
          nextPageToken: searchResult.nextPageToken,
          endReached: newPlaces.isEmpty &&
              searchResult.nextPageToken == null &&
              current.currentIndex >= mergedPlaces.length,
        ),
      );
    } catch (_) {
      state = AsyncData(
        current.copyWith(
          isFetchingMore: false,
          errorMessage: 'Could not load more restaurants.',
        ),
      );
    }
  }
}
