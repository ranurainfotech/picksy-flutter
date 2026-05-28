class SwipeMatch {
  const SwipeMatch({
    required this.movieId,
    required this.title,
    required this.posterPath,
    required this.createdAt,
  });

  final int movieId;
  final String title;
  final String? posterPath;
  final DateTime? createdAt;

  factory SwipeMatch.fromMap(Map<String, dynamic> map) {
    return SwipeMatch(
      movieId: (map['movieId'] as num?)?.toInt() ?? 0,
      title: map['title'] as String? ?? 'Match',
      posterPath: map['posterPath'] as String?,
      createdAt: (map['createdAt'] as dynamic).toDate() as DateTime?,
    );
  }
}
