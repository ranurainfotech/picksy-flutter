import '../../rooms/models/room_preview.dart';
import '../../swipe/models/swipe_match.dart';

/// A group match enriched with room context for the global Matches feed.
class MatchFeedItem {
  const MatchFeedItem({
    required this.id,
    required this.roomId,
    required this.roomName,
    required this.roomCategoryId,
    required this.roomEmoji,
    required this.itemId,
    required this.itemName,
    required this.posterPath,
    required this.matchType,
    required this.matchedMemberIds,
    required this.matchedCount,
    required this.roomMemberCount,
    required this.matchedAt,
  });

  final String id;
  final String roomId;
  final String roomName;
  final String roomCategoryId;
  final String roomEmoji;
  final int itemId;
  final String itemName;
  final String? posterPath;
  final String matchType;
  final List<String> matchedMemberIds;
  final int matchedCount;
  final int roomMemberCount;
  final DateTime? matchedAt;

  bool get isPerfect => matchType == 'perfect';

  String? get posterUrl {
    if (posterPath == null || posterPath!.isEmpty) {
      return null;
    }
    if (posterPath!.startsWith('http')) {
      return posterPath;
    }
    return 'https://image.tmdb.org/t/p/w500/$posterPath';
  }

  String get roomCategoryLabel => RoomPreview.categoryLabel(roomCategoryId);

  String get roomContextLabel => '$roomEmoji $roomName';

  String get matchResultLabel =>
      '$matchedCount/$roomMemberCount members agreed';

  factory MatchFeedItem.fromRoomMatch({
    required String roomId,
    required Map<String, dynamic> roomData,
    required SwipeMatch match,
  }) {
    final categoryId = (roomData['category'] as String? ?? 'movies').toLowerCase();
    final members = (roomData['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toList(growable: false);
    final memberCountField = roomData['memberCount'] as int? ?? 0;
    final roomMemberCount = memberCountField > members.length
        ? memberCountField
        : members.length;

    return MatchFeedItem(
      id: '${roomId}_${match.movieId}',
      roomId: roomId.toUpperCase(),
      roomName: roomData['name'] as String? ?? '${roomId.toUpperCase()} Room',
      roomCategoryId: categoryId,
      roomEmoji: RoomPreview.categoryEmoji(categoryId),
      itemId: match.movieId,
      itemName: match.title,
      posterPath: match.posterPath,
      matchType: match.matchType,
      matchedMemberIds: match.likedBy,
      matchedCount: match.likedBy.length,
      roomMemberCount: roomMemberCount,
      matchedAt: match.createdAt,
    );
  }
}
