import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../../auth/providers/auth_providers.dart';
import '../../movies/domain/entities/movie.dart';
import '../../movies/domain/entities/genre.dart';
import '../../movies/domain/entities/streaming_provider.dart';
import '../../movies/presentation/providers/movies_providers.dart';
import '../../rooms/models/room_filters.dart';
import '../../rooms/providers/room_repository_provider.dart';
import '../../rooms/providers/rooms_provider.dart';
import '../../rooms/theme/app_rooms_tokens.dart';
import '../models/swipe_decision.dart';
import '../providers/swipe_realtime_providers.dart';
import '../providers/swipe_repository_provider.dart';
import '../widgets/swipe_action_buttons.dart';
import '../widgets/swipe_movie_card.dart';
import '../widgets/swipe_top_bar.dart';

class SwipeExperienceScreen extends ConsumerStatefulWidget {
  const SwipeExperienceScreen({super.key, required this.roomId});
  final String roomId;

  @override
  ConsumerState<SwipeExperienceScreen> createState() =>
      _SwipeExperienceScreenState();
}

class _SwipeExperienceScreenState extends ConsumerState<SwipeExperienceScreen> {
  static const _swipeThresholdX = 120.0;
  static const _swipeThresholdY = -120.0;

  final ValueNotifier<Offset> _dragOffset = ValueNotifier<Offset>(Offset.zero);
  bool _isAnimatingOut = false;
  final ValueNotifier<_SwipeUiState> _uiState = ValueNotifier<_SwipeUiState>(
    const _SwipeUiState(),
  );

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_loadInitialDeck);
  }

  @override
  void dispose() {
    _dragOffset.dispose();
    _uiState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomId = widget.roomId;
    final roomAsync = ref.watch(roomStreamProvider(roomId));

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppRoomsTokens.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildBody(context, roomAsync),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncValue<Map<String, dynamic>?> roomAsync,
  ) {
    final room = roomAsync.asData?.value ?? const <String, dynamic>{};
    final roomName = room['name'] as String? ?? 'Saturday Night 🍿';
    final memberIds = (room['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toList(growable: false);

    return ValueListenableBuilder<_SwipeUiState>(
      valueListenable: _uiState,
      builder: (context, currentUi, _) {
        if (currentUi.isInitialLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.neonPink),
          );
        }

        if (currentUi.movies.isEmpty || currentUi.currentIndex >= currentUi.movies.length) {
          return Column(
            children: [
              _Header(
                roomId: widget.roomId,
                roomName: roomName,
                memberIds: memberIds,
              ),
              const SizedBox(height: 10),
              Expanded(child: _EmptyState(onRetry: _loadInitialDeck)),
            ],
          );
        }

        final visibleMovie = currentUi.movies[currentUi.currentIndex];
        final likedUserIdsAsync = ref.watch(
          movieLikedUserIdsProvider((
            roomId: widget.roomId,
            movieId: visibleMovie.id,
          )),
        );
        return Column(
          children: [
            _Header(
              roomId: widget.roomId,
              roomName: roomName,
              memberIds: memberIds,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.92,
                  height: MediaQuery.sizeOf(context).height * 0.68,
                  child: ValueListenableBuilder<Offset>(
                    valueListenable: _dragOffset,
                    builder: (context, dragOffset, _) {
                      final dragProgress = _dragProgress(dragOffset);
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          for (var i = 2; i >= 0; i--)
                            if (currentUi.currentIndex + i < currentUi.movies.length)
                              _CardLayer(
                                movie: currentUi.movies[currentUi.currentIndex + i],
                                layerIndex: i,
                                dragProgress: dragProgress,
                                dragOffset: i == 0 ? dragOffset : Offset.zero,
                                likedUserIds: i == 0
                                    ? (likedUserIdsAsync.asData?.value ?? const <String>[])
                                    : const <String>[],
                                onPanUpdate: i == 0 ? _onPanUpdate : null,
                                onPanEnd: i == 0
                                    ? () => _onPanEnd(widget.roomId, visibleMovie)
                                    : null,
                              ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SwipeActionButtons(
              onDislike: () => _triggerAction(
                widget.roomId,
                visibleMovie,
                SwipeDecision.disliked,
              ),
              onMaybe: () =>
                  _triggerAction(widget.roomId, visibleMovie, SwipeDecision.maybe),
              onLike: () =>
                  _triggerAction(widget.roomId, visibleMovie, SwipeDecision.liked),
            ),
            const SizedBox(height: 14),
            Text(
              '${currentUi.currentIndex + 1} of ${currentUi.movies.length}',
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            if (currentUi.isFetchingMore) ...[
              const SizedBox(height: 8),
              Text(
                'Loading more movies...',
                style: AppTypography.caption.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
            if (currentUi.deckError != null) ...[
              const SizedBox(height: 8),
              Text(
                currentUi.deckError!,
                style: AppTypography.caption.copyWith(color: AppColors.reject),
              ),
            ],
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Future<void> _loadInitialDeck() async {
    _uiState.value = _uiState.value.copyWith(
      isInitialLoading: true,
      isFetchingMore: false,
      deckError: null,
      nextPage: 1,
      currentIndex: 0,
      movies: const <Movie>[],
    );

    try {
      final roomSnapshot = await ref
          .read(roomRepositoryProvider)
          .getRoom(widget.roomId);
      final roomData = roomSnapshot.data();
      if (roomData == null) {
        _uiState.value = _uiState.value.copyWith(
          isInitialLoading: false,
          deckError: 'Room not found.',
        );
        return;
      }

      final rawFilters = roomData['filters'];
      final filters = await _resolveFilters(rawFilters);

      final fetched = <Movie>[];
      var page = 1;
      while (fetched.length < 15 && page <= 3) {
        final pageItems = await ref
            .read(moviesRepositoryProvider)
            .discoverMovies(
              genreIds: filters.genreIds,
              providerIds: filters.providerIds,
              minRating: filters.minRating,
              releaseYear: filters.releaseYear,
              sortBy: filters.sortBy,
              page: page,
            );
        for (final movie in pageItems) {
          if (fetched.every((existing) => existing.id != movie.id)) {
            fetched.add(movie);
          }
        }
        if (pageItems.isEmpty) break;
        page += 1;
      }

      _uiState.value = _uiState.value.copyWith(
        movies: fetched,
        nextPage: page,
        filters: filters,
        isInitialLoading: false,
      );
      if (mounted && fetched.isNotEmpty) {
        _precacheUpcoming(context, 0);
      }
    } catch (_) {
      _uiState.value = _uiState.value.copyWith(
        isInitialLoading: false,
        deckError: 'Could not load swipe deck.',
      );
    }
  }

  Future<RoomFilters> _resolveFilters(Object? rawFilters) async {
    final map = _toStringDynamicMap(rawFilters);
    if (map == null) {
      return const RoomFilters();
    }

    final parsed = RoomFilters.fromJson(map);
    if (parsed.genreIds.isNotEmpty) {
      return parsed;
    }

    // Backward compatibility for old room docs that stored names instead of IDs.
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
      providerIds: matchedProviderIds.isEmpty ? parsed.providerIds : matchedProviderIds,
    );
  }

  Map<String, dynamic>? _toStringDynamicMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      final map = <String, dynamic>{};
      for (final entry in value.entries) {
        map['${entry.key}'] = entry.value;
      }
      return map;
    }
    return null;
  }

  List<String> _stringList(Object? value) {
    if (value is! List) {
      return const <String>[];
    }
    return value.map((item) => '$item'.trim()).where((item) => item.isNotEmpty).toList();
  }

  List<int> _matchGenreIds(List<Genre> genres, List<String> names) {
    if (names.isEmpty) {
      return const <int>[];
    }
    final normalized = names.map(_normalize).toSet();
    final ids = <int>[];
    for (final genre in genres) {
      if (normalized.contains(_normalize(genre.name))) {
        ids.add(genre.id);
      }
    }
    return ids;
  }

  List<int> _matchProviderIds(List<StreamingProvider> providers, List<String> names) {
    if (names.isEmpty) {
      return const <int>[];
    }
    final normalized = names.map(_normalize).toSet();
    final ids = <int>[];
    for (final provider in providers) {
      if (normalized.contains(_normalize(provider.name))) {
        ids.add(provider.id);
      }
    }
    return ids;
  }

  String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  double _dragProgress(Offset dragOffset) {
    if (dragOffset == Offset.zero) {
      return 0;
    }
    final horizontal = (dragOffset.dx.abs() / _swipeThresholdX).clamp(0.0, 1.0);
    final upward = ((-dragOffset.dy) / (-_swipeThresholdY)).clamp(0.0, 1.0);
    return horizontal > upward ? horizontal : upward;
  }

  Future<void> _fetchMoreIfNeeded() async {
    final ui = _uiState.value;
    if (ui.isFetchingMore || ui.isInitialLoading) return;
    if ((ui.movies.length - ui.currentIndex) > 4) return;

    _uiState.value = ui.copyWith(isFetchingMore: true, deckError: null);

    try {
      final pageItems = await ref
          .read(moviesRepositoryProvider)
          .discoverMovies(
            genreIds: ui.filters.genreIds,
            providerIds: ui.filters.providerIds,
            minRating: ui.filters.minRating,
            releaseYear: ui.filters.releaseYear,
            sortBy: ui.filters.sortBy,
            page: ui.nextPage,
          );

      final merged = List<Movie>.from(ui.movies);
      for (final movie in pageItems) {
        if (merged.every((existing) => existing.id != movie.id)) {
          merged.add(movie);
        }
      }

      _uiState.value = _uiState.value.copyWith(
        movies: merged,
        nextPage: ui.nextPage + 1,
        isFetchingMore: false,
      );
    } catch (_) {
      _uiState.value = _uiState.value.copyWith(
        isFetchingMore: false,
        deckError: 'Could not load more movies.',
      );
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimatingOut) return;
    _dragOffset.value += details.delta;
  }

  Future<void> _onPanEnd(String roomId, Movie movie) async {
    if (_isAnimatingOut) return;
    final dragOffset = _dragOffset.value;
    if (dragOffset.dx > _swipeThresholdX) {
      await _triggerAction(roomId, movie, SwipeDecision.liked);
      return;
    }
    if (dragOffset.dx < -_swipeThresholdX) {
      await _triggerAction(roomId, movie, SwipeDecision.disliked);
      return;
    }
    if (dragOffset.dy < _swipeThresholdY) {
      await _triggerAction(roomId, movie, SwipeDecision.maybe);
      return;
    }
    _dragOffset.value = Offset.zero;
  }

  Future<void> _triggerAction(
    String roomId,
    Movie movie,
    SwipeDecision decision,
  ) async {
    if (_isAnimatingOut) return;
    _isAnimatingOut = true;
    final currentUi = _uiState.value;
    if (currentUi.currentIndex >= currentUi.movies.length) {
      _isAnimatingOut = false;
      return;
    }

    final outOffset = switch (decision) {
      SwipeDecision.liked => const Offset(540, -120),
      SwipeDecision.disliked => const Offset(-540, -90),
      SwipeDecision.maybe => const Offset(0, -620),
    };
    _dragOffset.value = outOffset;

    await Future<void>.delayed(const Duration(milliseconds: 170));
    if (!mounted) return;
    _uiState.value = _uiState.value.copyWith(currentIndex: currentUi.currentIndex + 1);
    _dragOffset.value = Offset.zero;
    _isAnimatingOut = false;

    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid != null) {
      ref
          .read(swipeRepositoryProvider)
          .submitSwipe(
            roomId: roomId,
            userId: uid,
            movie: movie,
            decision: decision,
          )
          .catchError((_) {});
    }

    await _fetchMoreIfNeeded();
    if (!mounted) return;
    final latestUi = _uiState.value;
    if (latestUi.currentIndex < latestUi.movies.length) {
      _precacheUpcoming(context, latestUi.currentIndex);
    }
  }

  void _precacheUpcoming(BuildContext context, int fromIndex) {
    final movies = _uiState.value.movies;
    for (var i = fromIndex; i <= fromIndex + 2 && i < movies.length; i += 1) {
      final url = movies[i].posterUrl;
      if (url != null) {
        precacheImage(NetworkImage(url), context);
      }
    }
  }
}

class _SwipeUiState {
  const _SwipeUiState({
    this.currentIndex = 0,
    this.isInitialLoading = true,
    this.isFetchingMore = false,
    this.deckError,
    this.nextPage = 1,
    this.filters = const RoomFilters(),
    this.movies = const <Movie>[],
  });

  final int currentIndex;
  final bool isInitialLoading;
  final bool isFetchingMore;
  final String? deckError;
  final int nextPage;
  final RoomFilters filters;
  final List<Movie> movies;

  _SwipeUiState copyWith({
    int? currentIndex,
    bool? isInitialLoading,
    bool? isFetchingMore,
    String? deckError,
    bool clearDeckError = false,
    int? nextPage,
    RoomFilters? filters,
    List<Movie>? movies,
  }) {
    return _SwipeUiState(
      currentIndex: currentIndex ?? this.currentIndex,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      deckError: clearDeckError ? null : (deckError ?? this.deckError),
      nextPage: nextPage ?? this.nextPage,
      filters: filters ?? this.filters,
      movies: movies ?? this.movies,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.roomId,
    required this.roomName,
    required this.memberIds,
  });

  final String roomId;
  final String roomName;
  final List<String> memberIds;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              onPressed: () => context.go(AppRoutes.home),
              icon: const Icon(AppIcons.chevronLeft, color: Colors.white),
            ),
          ),
          Expanded(
            child: SwipeTopBar(roomName: roomName, memberIds: memberIds),
          ),
          SizedBox(
            width: 44,
            child: GestureDetector(
              onTap: () => context.go(AppRoutes.roomLobby(roomId, fromSwipe: true)),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.group_rounded, size: 16, color: Colors.white70),
                      const SizedBox(width: 2),
                      Text(
                        '${memberIds.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No movies found for selected filters.',
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        AppButton.secondary(label: 'Try Again', onPressed: onRetry),
      ],
    );
  }
}

class _CardLayer extends StatelessWidget {
  const _CardLayer({
    required this.movie,
    required this.layerIndex,
    required this.dragProgress,
    required this.dragOffset,
    required this.likedUserIds,
    this.onPanUpdate,
    this.onPanEnd,
  });

  final Movie movie;
  final int layerIndex;
  final double dragProgress;
  final Offset dragOffset;
  final List<String> likedUserIds;
  final ValueChanged<DragUpdateDetails>? onPanUpdate;
  final VoidCallback? onPanEnd;

  @override
  Widget build(BuildContext context) {
    final easedProgress = Curves.easeOutCubic.transform(dragProgress.clamp(0.0, 1.0));
    final scale = switch (layerIndex) {
      0 => 1.0,
      1 => lerpDouble(0.96, 1.0, easedProgress) ?? 1.0,
      _ => lerpDouble(0.92, 0.96, easedProgress) ?? 0.96,
    };
    final translateY = switch (layerIndex) {
      0 => 0.0,
      1 => lerpDouble(12.0, 0.0, easedProgress) ?? 0.0,
      _ => lerpDouble(24.0, 12.0, easedProgress) ?? 12.0,
    };
    const opacity = 1.0;
    final rotate = layerIndex == 0 ? (dragOffset.dx / 420) : 0.0;

    return Transform.translate(
      offset: Offset(
        layerIndex == 0 ? dragOffset.dx : 0.0,
        translateY + (layerIndex == 0 ? dragOffset.dy : 0),
      ),
      child: Transform.rotate(
        angle: rotate,
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: GestureDetector(
              onPanUpdate: onPanUpdate,
              onPanEnd: (_) => onPanEnd?.call(),
              child: RepaintBoundary(
                child: SwipeMovieCard(movie: movie, likedUserIds: likedUserIds),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
