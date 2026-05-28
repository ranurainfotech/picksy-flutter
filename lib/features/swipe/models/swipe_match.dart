import 'package:cloud_firestore/cloud_firestore.dart';

class SwipeMatch {
  const SwipeMatch({
    required this.movieId,
    required this.title,
    required this.posterPath,
    required this.matchType,
    required this.likedBy,
    required this.createdAt,
  });

  final int movieId;
  final String title;
  final String? posterPath;
  final String matchType;
  final List<String> likedBy;
  final DateTime? createdAt;

  bool get isPerfect => matchType == 'perfect';

  factory SwipeMatch.fromMap(Map<String, dynamic> map) {
    return SwipeMatch(
      movieId: (map['movieId'] as num?)?.toInt() ?? 0,
      title: map['title'] as String? ?? 'Match',
      posterPath: map['posterPath'] as String?,
      matchType: map['matchType'] as String? ?? 'majority',
      likedBy: (map['likedBy'] as List? ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }
}
