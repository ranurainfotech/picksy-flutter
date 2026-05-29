abstract class AnalyticsService {
  Future<void> logOnboardingStarted();

  Future<void> logUsernameSelected({required String avatarId});

  Future<void> logOnboardingCompleted();

  Future<void> logRoomCreated({
    required int genreCount,
    required int providerCount,
    required String sortType,
  });

  Future<void> logRoomJoined({required int roomSize});

  Future<void> logInviteShared({required String shareMethod});

  Future<void> logMovieLiked({
    required int movieId,
    required String genre,
    required int roomSize,
  });

  Future<void> logMovieDisliked({
    required int movieId,
    required String genre,
    required int roomSize,
  });

  Future<void> logMovieMaybe({
    required int movieId,
    required String genre,
    required int roomSize,
  });

  Future<void> logMajorityMatch({
    required int memberCount,
    required int likeCount,
  });

  Future<void> logPerfectMatch({required int memberCount});

  Future<void> logSwipeSessionStarted();

  Future<void> logSwipeSessionCompleted({
    required int totalSwipes,
    required int totalMatches,
  });

  Future<void> logScreenView(String screenName);

  Future<void> setUserProperty({
    required String name,
    required String? value,
  });
}
