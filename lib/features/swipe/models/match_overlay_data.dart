import '../../movies/domain/entities/movie.dart';
import 'swipe_match.dart';

/// Presentation model for the cinematic match celebration overlay.
class MatchOverlayData {
  const MatchOverlayData({
    required this.match,
    required this.movie,
    required this.memberCount,
    required this.likedUserIds,
  });

  final SwipeMatch match;
  final Movie movie;
  final int memberCount;
  final List<String> likedUserIds;

  bool get isPerfect => match.isPerfect;

  int get likeCount => likedUserIds.length;

  String get primaryLine => isPerfect
      ? 'Everyone liked this! 🍿'
      : '$likeCount out of $memberCount liked this 👍';
}
