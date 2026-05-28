import 'package:cloud_firestore/cloud_firestore.dart';

import '../../movies/domain/entities/movie.dart';
import '../models/swipe_decision.dart';
import '../models/swipe_match.dart';

class SwipeRepository {
  SwipeRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _swipes(String roomId) =>
      _firestore.collection('rooms').doc(roomId).collection('swipes');

  CollectionReference<Map<String, dynamic>> _matches(String roomId) =>
      _firestore.collection('rooms').doc(roomId).collection('matches');

  DocumentReference<Map<String, dynamic>> _room(String roomId) =>
      _firestore.collection('rooms').doc(roomId);

  Stream<List<String>> watchLikedUserIdsForMovie({
    required String roomId,
    required int movieId,
  }) {
    return _swipes(roomId)
        .where('movieId', isEqualTo: movieId)
        .where('action', isEqualTo: SwipeDecision.liked.wireValue)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => doc.data()['userId'] as String?)
              .whereType<String>()
              .toSet()
              .toList(growable: false);
        });
  }

  Stream<List<SwipeMatch>> watchMatches(String roomId) {
    return _matches(
      roomId,
    ).orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => SwipeMatch.fromMap(doc.data()))
          .toList(growable: false);
    });
  }

  Future<void> submitSwipe({
    required String roomId,
    required String userId,
    required Movie movie,
    required SwipeDecision decision,
  }) async {
    final swipeDocId = '${userId}_${movie.id}';
    await _swipes(roomId).doc(swipeDocId).set({
      'movieId': movie.id,
      'userId': userId,
      'action': decision.wireValue,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (decision != SwipeDecision.liked) return;

    final likedSnapshot = await _swipes(roomId)
        .where('movieId', isEqualTo: movie.id)
        .where('action', isEqualTo: SwipeDecision.liked.wireValue)
        .get();

    final roomSnapshot = await _room(roomId).get();
    final roomData = roomSnapshot.data() ?? const <String, dynamic>{};
    final members = (roomData['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toSet();

    if (members.isEmpty) return;

    final likedUserIds = likedSnapshot.docs
        .map((doc) => doc.data()['userId'] as String?)
        .whereType<String>()
        .toSet();

    if (!members.every(likedUserIds.contains)) return;

    await _matches(roomId).doc('${movie.id}').set({
      'movieId': movie.id,
      'title': movie.title,
      'posterPath': movie.posterPath,
      'voteAverage': movie.voteAverage,
      'releaseDate': movie.releaseDate,
      'likedBy': likedUserIds.toList(growable: false),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
