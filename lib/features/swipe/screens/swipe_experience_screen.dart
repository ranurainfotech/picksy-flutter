import 'dart:ui';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../../movies/domain/entities/movie.dart';
import '../../monetization/providers/monetization_ad_provider.dart';
import '../../monetization/services/interstitial_ad_service.dart';
import '../../places/domain/entities/place.dart';
import '../../places/places_load_errors.dart';
import '../../rooms/providers/rooms_provider.dart';
import '../../rooms/theme/app_rooms_tokens.dart';
import '../models/swipe_decision.dart';
import '../models/swipe_match.dart';
import '../providers/swipe_realtime_providers.dart';
import '../providers/swipe_session_provider.dart';
import '../repositories/swipe_repository.dart';
import '../widgets/swipe_action_buttons.dart';
import '../widgets/swipe_drag_feedback_overlay.dart';
import '../models/match_overlay_data.dart';
import '../widgets/match_overlay/match_overlay_widget.dart';
import '../widgets/swipe_movie_card.dart';
import '../widgets/swipe_place_card.dart';
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
  static const _dragFeedbackMaxCards = 3;

  final ValueNotifier<Offset> _dragOffset = ValueNotifier<Offset>(Offset.zero);
  final Set<String> _celebratedMatchIds = <String>{};
  final List<MatchOverlayData> _matchOverlayQueue = <MatchOverlayData>[];
  MatchOverlayData? _activeMatchOverlay;
  bool _isAnimatingOut = false;
  bool _seededMatchIds = false;
  bool _matchAdShownThisSession = false;

  bool get _isMatchOverlayVisible => _activeMatchOverlay != null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dragOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomId = widget.roomId;
    final roomAsync = ref.watch(roomStreamProvider(roomId));
    final sessionAsync = ref.watch(swipeSessionProvider(roomId));

    ref.listen(roomMatchesProvider(roomId), (previous, next) {
      _onMatchesUpdated(context, previous, next);
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: AppRoomsTokens.backgroundGradient,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: IgnorePointer(
                  ignoring: _isMatchOverlayVisible,
                  child: _buildBody(context, roomAsync, sessionAsync),
                ),
              ),
            ),
          ),
          if (_activeMatchOverlay != null)
            MatchOverlayWidget(
              key: ValueKey(_activeMatchOverlay!.match.matchKey),
              data: _activeMatchOverlay!,
              onDismiss: () => unawaited(_onMatchOverlayDismissed()),
              onAddToWatchlist: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Watchlist coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncValue<Map<String, dynamic>?> roomAsync,
    AsyncValue<SwipeSessionState> sessionAsync,
  ) {
    final room = roomAsync.asData?.value ?? const <String, dynamic>{};
    final roomName = room['name'] as String? ?? 'Saturday Night 🍿';
    final roomCategory = (room['category'] as String? ?? 'movies').toLowerCase();
    final isRestaurantRoom = roomCategory == 'restaurants';
    final memberIds = (room['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toList(growable: false);
    final emptyLabel = isRestaurantRoom
        ? 'No restaurants found nearby.'
        : 'No movies found for selected filters.';

    if (sessionAsync.isLoading) {
      return Column(
        children: [
          _Header(
            roomId: widget.roomId,
            roomName: roomName,
            memberIds: memberIds,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: AppColors.neonPink),
                const SizedBox(height: 16),
                Text(
                  isRestaurantRoom
                      ? 'Finding restaurants nearby...'
                      : 'Loading picks...',
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return sessionAsync.when(
      loading: () => Column(
        children: [
          _Header(
            roomId: widget.roomId,
            roomName: roomName,
            memberIds: memberIds,
          ),
          const SizedBox(height: 10),
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.neonPink),
            ),
          ),
        ],
      ),
      error: (error, stackTrace) {
        debugPrint('[SwipeExperience] session error: $error');
        debugPrint('$stackTrace');
        return Column(
          children: [
            _Header(
              roomId: widget.roomId,
              roomName: roomName,
              memberIds: memberIds,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _EmptyState(
                message: placesLoadErrorMessage(
                  error,
                  category: roomCategory,
                ),
                emptyLabel: emptyLabel,
                onRetry: _retrySwipeSession,
              ),
            ),
          ],
        );
      },
      data: (currentUi) {
        if (currentUi.isRestaurantRoom) {
          return _buildRestaurantSwipe(context, roomName, memberIds, currentUi);
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
              Expanded(
                child: _EmptyState(
                  message: currentUi.errorMessage,
                  emptyLabel: emptyLabel,
                  onRetry: _retrySwipeSession,
                ),
              ),
            ],
          );
        }

        _precacheUpcoming(context, currentUi.movies, currentUi.currentIndex);
        final showDragFeedback = currentUi.currentIndex < _dragFeedbackMaxCards;
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
                      final horizontalLikeProgress = (dragOffset.dx / _swipeThresholdX).clamp(
                        0.0,
                        1.0,
                      );
                      final horizontalDislikeProgress = ((-dragOffset.dx) / _swipeThresholdX)
                          .clamp(0.0, 1.0);
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
                                showDragFeedback: showDragFeedback,
                                likeFeedbackProgress: i == 0
                                    ? horizontalLikeProgress
                                    : 0.0,
                                dislikeFeedbackProgress: i == 0
                                    ? horizontalDislikeProgress
                                    : 0.0,
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
            if (currentUi.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                currentUi.errorMessage!,
                style: AppTypography.caption.copyWith(color: AppColors.reject),
              ),
            ],
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  void _retrySwipeSession() {
    ref.read(swipeSessionProvider(widget.roomId).notifier).retry(clearQueue: true);
  }

  void _onMatchesUpdated(
    BuildContext context,
    AsyncValue<List<SwipeMatch>>? previous,
    AsyncValue<List<SwipeMatch>> next,
  ) {
    final matches = next.asData?.value;
    if (matches == null) {
      return;
    }

    final room = ref.read(roomStreamProvider(widget.roomId)).asData?.value;
    final memberIds = (room?['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toList(growable: false);
    final memberCount = memberIds.length;

    if (memberCount < 2) {
      return;
    }

    final previousMatches = previous?.asData?.value ?? const <SwipeMatch>[];
    final previousByMatchKey = {
      for (final match in previousMatches) match.matchKey: match,
    };

    if (!_seededMatchIds) {
      for (final match in matches) {
        if (isGroupMatch(match, memberCount)) {
          _celebratedMatchIds.add(match.matchKey);
        }
      }
      _seededMatchIds = true;
      return;
    }

    for (final match in matches) {
      if (!isGroupMatch(match, memberCount)) {
        continue;
      }

      final prior = previousByMatchKey[match.matchKey];
      if (!matchJustCrossedThreshold(
        previous: prior,
        current: match,
        memberCount: memberCount,
      )) {
        continue;
      }
      if (!_celebratedMatchIds.add(match.matchKey)) {
        continue;
      }
      if (!mounted) {
        return;
      }
      _enqueueMatchOverlay(_overlayDataForMatch(match));
    }
  }

  MatchOverlayData _overlayDataForMatch(SwipeMatch match) {
    final room = ref.read(roomStreamProvider(widget.roomId)).asData?.value;
    final memberIds = (room?['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toList(growable: false);
    final memberCount = memberIds.length;
    final session = ref.read(swipeSessionProvider(widget.roomId)).asData?.value;

    if (match.isPlace) {
      Place? place;
      if (session != null) {
        for (final entry in session.places) {
          if (entry.placeId == match.itemId) {
            place = entry;
            break;
          }
        }
      }
      place ??= placeFromMatch(match);
      return MatchOverlayData(
        match: match,
        place: place,
        memberCount: memberCount,
        likedUserIds: match.likedBy,
      );
    }

    Movie? movie;
    if (session != null) {
      for (final entry in session.movies) {
        if ('${entry.id}' == match.itemId) {
          movie = entry;
          break;
        }
      }
    }
    movie ??= movieFromMatch(match);
    return MatchOverlayData(
      match: match,
      movie: movie,
      memberCount: memberCount,
      likedUserIds: match.likedBy,
    );
  }

  Widget _buildRestaurantSwipe(
    BuildContext context,
    String roomName,
    List<String> memberIds,
    SwipeSessionState currentUi,
  ) {
    if (currentUi.places.isEmpty ||
        currentUi.currentIndex >= currentUi.places.length) {
      return Column(
        children: [
          _Header(
            roomId: widget.roomId,
            roomName: roomName,
            memberIds: memberIds,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _EmptyState(
              message: currentUi.errorMessage,
              onRetry: _retrySwipeSession,
              emptyLabel: 'No restaurants found for selected filters.',
            ),
          ),
        ],
      );
    }

    _precacheUpcomingPlaces(context, currentUi.places, currentUi.currentIndex);
    final showDragFeedback = currentUi.currentIndex < _dragFeedbackMaxCards;
    final visiblePlace = currentUi.places[currentUi.currentIndex];
    final likedUserIdsAsync = ref.watch(
      placeLikedUserIdsProvider((
        roomId: widget.roomId,
        placeId: visiblePlace.placeId,
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
                  final horizontalLikeProgress =
                      (dragOffset.dx / _swipeThresholdX).clamp(0.0, 1.0);
                  final horizontalDislikeProgress =
                      ((-dragOffset.dx) / _swipeThresholdX).clamp(0.0, 1.0);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      for (var i = 2; i >= 0; i--)
                        if (currentUi.currentIndex + i < currentUi.places.length)
                          _PlaceCardLayer(
                            place: currentUi.places[currentUi.currentIndex + i],
                            layerIndex: i,
                            dragProgress: dragProgress,
                            dragOffset: i == 0 ? dragOffset : Offset.zero,
                            showDragFeedback: showDragFeedback,
                            likeFeedbackProgress:
                                i == 0 ? horizontalLikeProgress : 0.0,
                            dislikeFeedbackProgress:
                                i == 0 ? horizontalDislikeProgress : 0.0,
                            likedUserIds: i == 0
                                ? (likedUserIdsAsync.asData?.value ??
                                    const <String>[])
                                : const <String>[],
                            onPanUpdate: i == 0 ? _onPanUpdate : null,
                            onPanEnd: i == 0
                                ? () => _onPanEndPlace(widget.roomId, visiblePlace)
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
          onDislike: () => _triggerPlaceAction(
            widget.roomId,
            visiblePlace,
            SwipeDecision.disliked,
          ),
          onMaybe: () => _triggerPlaceAction(
            widget.roomId,
            visiblePlace,
            SwipeDecision.maybe,
          ),
          onLike: () => _triggerPlaceAction(
            widget.roomId,
            visiblePlace,
            SwipeDecision.liked,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          '${currentUi.currentIndex + 1} of ${currentUi.places.length}',
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        if (currentUi.isFetchingMore) ...[
          const SizedBox(height: 8),
          Text(
            'Loading more restaurants...',
            style: AppTypography.caption.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
        if (currentUi.errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            currentUi.errorMessage!,
            style: AppTypography.caption.copyWith(color: AppColors.reject),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  void _onPanEndPlace(String roomId, Place place) async {
    if (_isAnimatingOut || _isMatchOverlayVisible) return;
    final dragOffset = _dragOffset.value;
    if (dragOffset.dx > _swipeThresholdX) {
      await _triggerPlaceAction(roomId, place, SwipeDecision.liked);
      return;
    }
    if (dragOffset.dx < -_swipeThresholdX) {
      await _triggerPlaceAction(roomId, place, SwipeDecision.disliked);
      return;
    }
    if (dragOffset.dy < _swipeThresholdY) {
      await _triggerPlaceAction(roomId, place, SwipeDecision.maybe);
      return;
    }
    _dragOffset.value = Offset.zero;
  }

  Future<void> _triggerPlaceAction(
    String roomId,
    Place place,
    SwipeDecision decision,
  ) async {
    if (_isAnimatingOut || _isMatchOverlayVisible) return;
    _isAnimatingOut = true;

    final outOffset = switch (decision) {
      SwipeDecision.liked => const Offset(540, -120),
      SwipeDecision.disliked => const Offset(-540, -90),
      SwipeDecision.maybe => const Offset(0, -620),
    };
    _dragOffset.value = outOffset;

    await Future<void>.delayed(const Duration(milliseconds: 170));
    if (!mounted) return;
    final persistFuture = ref
        .read(swipeSessionProvider(roomId).notifier)
        .submitSwipe(decision: decision);
    _dragOffset.value = Offset.zero;
    await persistFuture;
    if (!mounted) return;
    _isAnimatingOut = false;
  }

  void _precacheUpcomingPlaces(
    BuildContext context,
    List<Place> places,
    int fromIndex,
  ) {
    for (var i = fromIndex; i <= fromIndex + 2 && i < places.length; i += 1) {
      final url = places[i].photoUrl;
      if (url != null) {
        precacheImage(NetworkImage(url), context);
      }
    }
  }

  void _enqueueMatchOverlay(MatchOverlayData data) {
    if (_activeMatchOverlay == null) {
      setState(() => _activeMatchOverlay = data);
      return;
    }
    _matchOverlayQueue.add(data);
  }

  Future<void> _onMatchOverlayDismissed() async {
    if (!_matchAdShownThisSession) {
      _matchAdShownThisSession = true;
      await ref
          .read(monetizationAdCoordinatorProvider)
          .show(AdTrigger.matchCompleted);
    }

    if (!mounted) {
      return;
    }
    _dismissMatchOverlay();
  }

  void _dismissMatchOverlay() {
    if (!mounted) {
      return;
    }
    if (_matchOverlayQueue.isEmpty) {
      setState(() => _activeMatchOverlay = null);
      return;
    }
    setState(() => _activeMatchOverlay = _matchOverlayQueue.removeAt(0));
  }

  double _dragProgress(Offset dragOffset) {
    if (dragOffset == Offset.zero) {
      return 0;
    }
    final horizontal = (dragOffset.dx.abs() / _swipeThresholdX).clamp(0.0, 1.0);
    final upward = ((-dragOffset.dy) / (-_swipeThresholdY)).clamp(0.0, 1.0);
    return horizontal > upward ? horizontal : upward;
  }


  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimatingOut || _isMatchOverlayVisible) return;
    _dragOffset.value += details.delta;
  }

  Future<void> _onPanEnd(String roomId, Movie movie) async {
    if (_isAnimatingOut || _isMatchOverlayVisible) return;
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
    if (_isAnimatingOut || _isMatchOverlayVisible) return;
    _isAnimatingOut = true;

    final outOffset = switch (decision) {
      SwipeDecision.liked => const Offset(540, -120),
      SwipeDecision.disliked => const Offset(-540, -90),
      SwipeDecision.maybe => const Offset(0, -620),
    };
    _dragOffset.value = outOffset;

    await Future<void>.delayed(const Duration(milliseconds: 170));
    if (!mounted) return;
    final persistFuture = ref
        .read(swipeSessionProvider(roomId).notifier)
        .submitSwipe(decision: decision);
    _dragOffset.value = Offset.zero;
    await persistFuture;
    if (!mounted) return;
    _isAnimatingOut = false;
  }

  void _precacheUpcoming(BuildContext context, List<Movie> movies, int fromIndex) {
    for (var i = fromIndex; i <= fromIndex + 2 && i < movies.length; i += 1) {
      final url = movies[i].posterUrl;
      if (url != null) {
        precacheImage(NetworkImage(url), context);
      }
    }
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
  const _EmptyState({
    this.message,
    required this.onRetry,
    this.emptyLabel = 'No movies found for selected filters.',
  });

  final String? message;
  final VoidCallback onRetry;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message ?? emptyLabel,
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
    required this.showDragFeedback,
    required this.likeFeedbackProgress,
    required this.dislikeFeedbackProgress,
    required this.likedUserIds,
    this.onPanUpdate,
    this.onPanEnd,
  });

  final Movie movie;
  final int layerIndex;
  final double dragProgress;
  final Offset dragOffset;
  final bool showDragFeedback;
  final double likeFeedbackProgress;
  final double dislikeFeedbackProgress;
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SwipeMovieCard(movie: movie, likedUserIds: likedUserIds),
                    if (layerIndex == 0 && showDragFeedback)
                      SwipeDragFeedbackOverlay(
                        likeProgress: likeFeedbackProgress,
                        dislikeProgress: dislikeFeedbackProgress,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceCardLayer extends StatelessWidget {
  const _PlaceCardLayer({
    required this.place,
    required this.layerIndex,
    required this.dragProgress,
    required this.dragOffset,
    required this.showDragFeedback,
    required this.likeFeedbackProgress,
    required this.dislikeFeedbackProgress,
    required this.likedUserIds,
    this.onPanUpdate,
    this.onPanEnd,
  });

  final Place place;
  final int layerIndex;
  final double dragProgress;
  final Offset dragOffset;
  final bool showDragFeedback;
  final double likeFeedbackProgress;
  final double dislikeFeedbackProgress;
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SwipePlaceCard(place: place, likedUserIds: likedUserIds),
                    if (layerIndex == 0 && showDragFeedback)
                      SwipeDragFeedbackOverlay(
                        likeProgress: likeFeedbackProgress,
                        dislikeProgress: dislikeFeedbackProgress,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
