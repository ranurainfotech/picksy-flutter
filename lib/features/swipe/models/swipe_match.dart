import 'package:cloud_firestore/cloud_firestore.dart';

import '../../movies/domain/entities/movie.dart';
import '../../places/domain/entities/place.dart';

class SwipeMatch {
  const SwipeMatch({
    required this.itemType,
    required this.itemId,
    required this.title,
    required this.posterPath,
    required this.matchType,
    required this.likedBy,
    required this.createdAt,
    this.movieId,
    this.googleMapsUri,
  });

  final String itemType;
  final String itemId;
  final int? movieId;
  final String title;
  final String? posterPath;
  final String? googleMapsUri;
  final String matchType;
  final List<String> likedBy;
  final DateTime? createdAt;

  bool get isPerfect => matchType == 'perfect';
  bool get isPlace => itemType == 'place';

  String get matchKey => itemId;

  factory SwipeMatch.fromMap(Map<String, dynamic> map, {String? docId}) {
    final itemType = map['itemType'] as String? ?? 'movie';
    final legacyMovieId = (map['movieId'] as num?)?.toInt();
    final itemId = map['itemId'] as String? ??
        legacyMovieId?.toString() ??
        docId ??
        '0';

    return SwipeMatch(
      itemType: itemType,
      itemId: itemId,
      movieId: legacyMovieId,
      title: map['title'] as String? ?? 'Match',
      posterPath: map['posterPath'] as String?,
      googleMapsUri: map['googleMapsUri'] as String?,
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

Movie movieFromMatch(SwipeMatch match) {
  final parsedId = int.tryParse(match.itemId) ?? match.movieId ?? 0;
  return Movie(
    id: parsedId,
    title: match.title,
    overview: '',
    posterPath: match.posterPath,
    voteAverage: 0,
  );
}

Place placeFromMatch(SwipeMatch match) {
  return Place(
    placeId: match.itemId,
    name: match.title,
    rating: 0,
    photoUrl: match.posterPath,
    googleMapsUri: match.googleMapsUri,
  );
}
