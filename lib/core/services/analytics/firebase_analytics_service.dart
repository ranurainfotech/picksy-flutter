import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_events.dart';
import 'analytics_params.dart';
import 'analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logOnboardingStarted() {
    return _logEvent(AnalyticsEvents.onboardingStarted);
  }

  @override
  Future<void> logUsernameSelected({required String avatarId}) {
    return _logEvent(
      AnalyticsEvents.usernameSelected,
      parameters: {AnalyticsParams.avatarId: _sanitize(avatarId)},
    );
  }

  @override
  Future<void> logOnboardingCompleted() {
    return _logEvent(AnalyticsEvents.onboardingCompleted);
  }

  @override
  Future<void> logRoomCreated({
    required int genreCount,
    required int providerCount,
    required String sortType,
  }) {
    return _logEvent(
      AnalyticsEvents.roomCreated,
      parameters: {
        AnalyticsParams.genreCount: genreCount,
        AnalyticsParams.providerCount: providerCount,
        AnalyticsParams.sortType: _sanitize(sortType),
      },
    );
  }

  @override
  Future<void> logRoomJoined({required int roomSize}) {
    return _logEvent(
      AnalyticsEvents.roomJoined,
      parameters: {AnalyticsParams.roomSize: roomSize},
    );
  }

  @override
  Future<void> logInviteShared({required String shareMethod}) {
    return _logEvent(
      AnalyticsEvents.inviteShared,
      parameters: {AnalyticsParams.shareMethod: _sanitize(shareMethod)},
    );
  }

  @override
  Future<void> logMovieLiked({
    required int movieId,
    required String genre,
    required int roomSize,
  }) {
    return _logSwipeEvent(
      AnalyticsEvents.movieLiked,
      movieId: movieId,
      genre: genre,
      roomSize: roomSize,
    );
  }

  @override
  Future<void> logMovieDisliked({
    required int movieId,
    required String genre,
    required int roomSize,
  }) {
    return _logSwipeEvent(
      AnalyticsEvents.movieDisliked,
      movieId: movieId,
      genre: genre,
      roomSize: roomSize,
    );
  }

  @override
  Future<void> logMovieMaybe({
    required int movieId,
    required String genre,
    required int roomSize,
  }) {
    return _logSwipeEvent(
      AnalyticsEvents.movieMaybe,
      movieId: movieId,
      genre: genre,
      roomSize: roomSize,
    );
  }

  @override
  Future<void> logMajorityMatch({
    required int memberCount,
    required int likeCount,
  }) {
    return _logEvent(
      AnalyticsEvents.majorityMatch,
      parameters: {
        AnalyticsParams.memberCount: memberCount,
        AnalyticsParams.likeCount: likeCount,
      },
    );
  }

  @override
  Future<void> logPerfectMatch({required int memberCount}) {
    return _logEvent(
      AnalyticsEvents.perfectMatch,
      parameters: {AnalyticsParams.memberCount: memberCount},
    );
  }

  @override
  Future<void> logSwipeSessionStarted() {
    return _logEvent(AnalyticsEvents.swipeSessionStarted);
  }

  @override
  Future<void> logSwipeSessionCompleted({
    required int totalSwipes,
    required int totalMatches,
  }) {
    return _logEvent(
      AnalyticsEvents.swipeSessionCompleted,
      parameters: {
        AnalyticsParams.moviesSwiped: totalSwipes,
        AnalyticsParams.matchesFound: totalMatches,
      },
    );
  }

  @override
  Future<void> logScreenView(String screenName) {
    return _analytics.logScreenView(screenName: _sanitize(screenName));
  }

  @override
  Future<void> logMatchCardViewed({
    required String roomType,
    required String matchType,
  }) {
    return _logEvent(
      AnalyticsEvents.matchCardViewed,
      parameters: {
        AnalyticsParams.roomType: _sanitize(roomType),
        AnalyticsParams.matchType: _sanitize(matchType),
      },
    );
  }

  @override
  Future<void> logMatchCardOpened({
    required String roomId,
    required String itemId,
  }) {
    return _logEvent(
      AnalyticsEvents.matchCardOpened,
      parameters: {
        AnalyticsParams.roomId: _sanitize(roomId),
        AnalyticsParams.itemId: _sanitize(itemId),
      },
    );
  }

  @override
  Future<void> logMatchShared({
    required String roomId,
    required String itemId,
  }) {
    return _logEvent(
      AnalyticsEvents.matchShared,
      parameters: {
        AnalyticsParams.roomId: _sanitize(roomId),
        AnalyticsParams.itemId: _sanitize(itemId),
      },
    );
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) {
    return _analytics.setUserProperty(
      name: _sanitize(name),
      value: value == null ? null : _sanitize(value),
    );
  }

  Future<void> _logSwipeEvent(
    String eventName, {
    required int movieId,
    required String genre,
    required int roomSize,
  }) {
    return _logEvent(
      eventName,
      parameters: {
        AnalyticsParams.movieId: movieId,
        AnalyticsParams.genre: _sanitize(genre),
        AnalyticsParams.roomSize: roomSize,
      },
    );
  }

  Future<void> _logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) {
    return _analytics.logEvent(
      name: _sanitize(name),
      parameters: _sanitizeParameters(parameters),
    );
  }

  Map<String, Object>? _sanitizeParameters(Map<String, Object>? parameters) {
    if (parameters == null || parameters.isEmpty) {
      return null;
    }

    final sanitized = <String, Object>{};
    for (final entry in parameters.entries.take(25)) {
      final value = entry.value;
      if (value is String) {
        sanitized[entry.key] = _sanitize(value);
      } else if (value is num) {
        sanitized[entry.key] = value;
      }
    }
    return sanitized.isEmpty ? null : sanitized;
  }

  String _sanitize(String value) {
    if (value.length <= 100) {
      return value;
    }
    return value.substring(0, 100);
  }
}
