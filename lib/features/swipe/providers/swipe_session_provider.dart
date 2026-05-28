import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../../movies/domain/entities/genre.dart';
import '../../movies/domain/entities/movie.dart';
import '../../movies/domain/entities/streaming_provider.dart';
import '../../movies/presentation/providers/movies_providers.dart';
import '../../rooms/models/room_filters.dart';
import '../../rooms/providers/room_repository_provider.dart';
import '../models/swipe_decision.dart';
import 'swipe_repository_provider.dart';

class SwipeSessionState {
  const SwipeSessionState({
    this.movies = const <Movie>[],
    this.currentIndex = 0,
    this.isFetchingMore = false,
    this.errorMessage,
    this.endReached = false,
    this.queueIds = const <int>[],
    this.visibleQueueIds = const <int>[],
    this.loadedVisibleCount = 0,
  });

  final List<Movie> movies;
  final int currentIndex;
  final bool isFetchingMore;
  final String? errorMessage;
  final bool endReached;
  final List<int> queueIds;
  final List<int> visibleQueueIds;
  final int loadedVisibleCount;

  SwipeSessionState copyWith({
    List<Movie>? movies,
    int? currentIndex,
    bool? isFetchingMore,
    String? errorMessage,
    bool clearError = false,
    bool? endReached,
    List<int>? queueIds,
    List<int>? visibleQueueIds,
    int? loadedVisibleCount,
  }) {
    return SwipeSessionState(
      movies: movies ?? this.movies,
      currentIndex: currentIndex ?? this.currentIndex,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      endReached: endReached ?? this.endReached,
      queueIds: queueIds ?? this.queueIds,
      visibleQueueIds: visibleQueueIds ?? this.visibleQueueIds,
      loadedVisibleCount: loadedVisibleCount ?? this.loadedVisibleCount,
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

  @override
  Future<SwipeSessionState> build() => _load();

  /// Clears a stale persisted queue and re-runs [build].
  Future<void> retry({bool clearQueue = true}) async {
    if (clearQueue) {
      await ref.read(roomRepositoryProvider).upsertMovieQueue(
            roomId: roomId,
            movieQueue: const <int>[],
          );
    }
    ref.invalidateSelf();
  }

  Future<SwipeSessionState> _load() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    final roomSnapshot = await ref.read(roomRepositoryProvider).getRoom(roomId);
    final roomData = roomSnapshot.data() ?? const <String, dynamic>{};

    final filters = await _resolveFilters(roomData['filters']);
    final swipedIds = uid == null
        ? <int>{}
        : await ref.read(swipeRepositoryProvider).getSwipedMovieIds(
            roomId: roomId,
            userId: uid,
          );

    var queueIds = _parseMovieQueueIds(roomData['movieQueue']);
    var movies = await _fetchDeckFromDiscover(
      filters: filters,
      swipedIds: swipedIds,
      minCount: _initialBatchSize,
    );

    if (movies.isEmpty) {
      return SwipeSessionState(
        endReached: true,
        queueIds: queueIds,
        visibleQueueIds: const <int>[],
      );
    }

    if (queueIds.isEmpty) {
      queueIds = movies.map((movie) => movie.id).toList(growable: false);
      await ref.read(roomRepositoryProvider).upsertMovieQueue(
            roomId: roomId,
            movieQueue: queueIds,
          );
    }

    final visibleQueueIds = queueIds
        .where((id) => !swipedIds.contains(id))
        .toList(growable: false);

    return SwipeSessionState(
      movies: movies,
      currentIndex: 0,
      endReached: false,
      queueIds: queueIds,
      visibleQueueIds: visibleQueueIds,
      loadedVisibleCount: movies.length,
    );
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

    for (var page = startPage; page <= 10 && movies.length < minCount; page += 1) {
      final pageMovies = await repo.discoverMovies(
        genreIds: filters.genreIds,
        providerIds: filters.providerIds,
        minRating: filters.minRating,
        releaseYear: filters.releaseYear,
        sortBy: filters.sortBy,
        page: page,
      );
      if (pageMovies.isEmpty) {
        break;
      }
      for (final movie in pageMovies) {
        if (!seen.add(movie.id) || swipedIds.contains(movie.id)) {
          continue;
        }
        movies.add(movie);
        if (movies.length >= minCount) {
          break;
        }
      }
    }

    return movies;
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
    if (current.currentIndex >= current.movies.length) {
      return;
    }

    final movie = current.movies[current.currentIndex];
    final queueIndex = current.queueIds.indexOf(movie.id);
    final nextIndex = queueIndex < 0 ? current.currentIndex + 1 : queueIndex + 1;

    ref
        .read(swipeRepositoryProvider)
        .submitSwipe(
          roomId: roomId,
          userId: uid,
          movie: movie,
          decision: decision,
          nextIndex: nextIndex,
        )
        .catchError((_) {});

    final nextLocalIndex = current.currentIndex + 1;
    final nextState = current.copyWith(
      currentIndex: nextLocalIndex,
      endReached: nextLocalIndex >= current.movies.length &&
          current.loadedVisibleCount >= current.visibleQueueIds.length,
    );
    state = AsyncData(nextState);

    await fetchMoreIfNeeded();
  }

  Future<void> fetchMoreIfNeeded() async {
    final current = state.asData?.value;
    if (current == null || current.isFetchingMore) {
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
}
