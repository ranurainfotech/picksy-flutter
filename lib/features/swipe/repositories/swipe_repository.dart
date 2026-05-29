import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/analytics/analytics_service.dart';
import '../../../core/services/analytics/swipe_submit_outcome.dart';
import '../../movies/domain/entities/movie.dart';
import '../models/swipe_decision.dart';
import '../models/swipe_match.dart';

class SwipeRepository {
  SwipeRepository(this._firestore, this._analytics);

  final FirebaseFirestore _firestore;
  final AnalyticsService _analytics;

  CollectionReference<Map<String, dynamic>> _swipes(String roomId) =>
      _firestore.collection('rooms').doc(roomId).collection('swipes');

  CollectionReference<Map<String, dynamic>> _matches(String roomId) =>
      _firestore.collection('rooms').doc(roomId).collection('matches');

  CollectionReference<Map<String, dynamic>> _progress(String roomId) =>
      _firestore.collection('rooms').doc(roomId).collection('progress');

  DocumentReference<Map<String, dynamic>> _room(String roomId) =>
      _firestore.collection('rooms').doc(roomId);

  Future<Set<int>> getSwipedMovieIds({
    required String roomId,
    required String userId,
  }) async {
    final snapshot = await _swipes(roomId)
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => (doc.data()['movieId'] as num?)?.toInt())
        .whereType<int>()
        .toSet();
  }

  Future<int> getUserProgressIndex({
    required String roomId,
    required String userId,
  }) async {
    final snapshot = await _progress(roomId).doc(userId).get();
    final data = snapshot.data();
    return (data?['currentIndex'] as num?)?.toInt() ?? 0;
  }

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

  Future<SwipeSubmitOutcome> submitSwipe({
    required String roomId,
    required String userId,
    required Movie movie,
    required SwipeDecision decision,
    required int nextIndex,
  }) async {
    final swipeDocId = '${movie.id}_$userId';
    await _swipes(roomId).doc(swipeDocId).set({
      'movieId': movie.id,
      'userId': userId,
      'action': decision.wireValue,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _progress(roomId).doc(userId).set({
      'currentIndex': nextIndex,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final existingMatch = await _matches(roomId).doc('${movie.id}').get();
    if (existingMatch.exists) {
      return const SwipeSubmitOutcome();
    }

    final movieSwipes = await _swipes(roomId)
        .where('movieId', isEqualTo: movie.id)
        .get();

    final roomSnapshot = await _room(roomId).get();
    final roomData = roomSnapshot.data() ?? const <String, dynamic>{};
    final members = (roomData['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toSet();

    if (members.isEmpty) {
      return const SwipeSubmitOutcome();
    }

    final likedUserIds = <String>{};
    final dislikedUserIds = <String>{};
    for (final doc in movieSwipes.docs) {
      final data = doc.data();
      final uid = data['userId'] as String?;
      final action = data['action'] as String?;
      if (uid == null || action == null || !members.contains(uid)) {
        continue;
      }
      if (action == SwipeDecision.liked.wireValue) {
        likedUserIds.add(uid);
      } else if (action == SwipeDecision.disliked.wireValue) {
        dislikedUserIds.add(uid);
      }
    }

    final memberCount = members.length;
    final threshold = matchLikeThreshold(memberCount);
    if (likedUserIds.length < threshold) {
      return SwipeSubmitOutcome(
        memberCount: memberCount,
        likeCount: likedUserIds.length,
      );
    }

    final matchType = memberCount == 2 || likedUserIds.length >= memberCount
        ? 'perfect'
        : 'majority';
    final score = memberCount == 0 ? 0.0 : likedUserIds.length / memberCount;

    await _matches(roomId).doc('${movie.id}').set({
      'movieId': movie.id,
      'title': movie.title,
      'posterPath': movie.posterPath,
      'likedBy': likedUserIds.toList(growable: false),
      'dislikedBy': dislikedUserIds.toList(growable: false),
      'matchType': matchType,
      'score': score,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (matchType == 'perfect') {
      unawaited(_analytics.logPerfectMatch(memberCount: memberCount));
    } else {
      unawaited(
        _analytics.logMajorityMatch(
          memberCount: memberCount,
          likeCount: likedUserIds.length,
        ),
      );
    }

    return SwipeSubmitOutcome(
      matchCreated: true,
      matchType: matchType,
      memberCount: memberCount,
      likeCount: likedUserIds.length,
    );
  }
}

/// Minimum number of **member** likes required before creating a match.
int matchLikeThreshold(int memberCount) {
  if (memberCount <= 1) {
    return 1;
  }
  if (memberCount == 2) {
    return 2;
  }
  return (memberCount * 0.75).floor().clamp(1, memberCount);
}
