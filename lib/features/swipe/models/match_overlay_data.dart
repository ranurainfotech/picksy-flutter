import '../../movies/domain/entities/movie.dart';
import '../../places/domain/entities/place.dart';
import 'swipe_match.dart';

/// Presentation model for the cinematic match celebration overlay.
class MatchOverlayData {
  const MatchOverlayData({
    required this.match,
    required this.memberCount,
    required this.likedUserIds,
    this.movie,
    this.place,
  });

  final SwipeMatch match;
  final Movie? movie;
  final Place? place;
  final int memberCount;
  final List<String> likedUserIds;

  bool get isPerfect => match.isPerfect;
  bool get isRestaurant => match.isPlace;

  int get likeCount => likedUserIds.length;

  String get primaryLine => isPerfect
      ? isRestaurant
          ? 'Everyone liked this spot! 🍔'
          : 'Everyone liked this! 🍿'
      : '$likeCount out of $memberCount liked this 👍';
}
