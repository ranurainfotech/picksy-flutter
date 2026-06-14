/// Firebase Analytics event names (snake_case only).
abstract final class AnalyticsEvents {
  static const onboardingStarted = 'onboarding_started';
  static const usernameSelected = 'username_selected';
  static const onboardingCompleted = 'onboarding_completed';

  static const roomCreated = 'room_created';
  static const roomJoined = 'room_joined';
  static const inviteShared = 'invite_shared';

  static const movieLiked = 'movie_liked';
  static const movieDisliked = 'movie_disliked';
  static const movieMaybe = 'movie_maybe';

  static const majorityMatch = 'majority_match';
  static const perfectMatch = 'perfect_match';

  static const swipeSessionStarted = 'swipe_session_started';
  static const swipeSessionCompleted = 'swipe_session_completed';

  static const matchCardViewed = 'match_card_viewed';
  static const matchCardOpened = 'match_card_opened';
  static const matchShared = 'match_shared';
}
