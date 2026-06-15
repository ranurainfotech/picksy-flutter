import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/analytics/analytics_service.dart';
import '../../../core/services/analytics/swipe_submit_outcome.dart';
import '../../movies/domain/entities/movie.dart';
import '../../places/domain/entities/place.dart';
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

  Future<Set<String>> getSwipedPlaceIds({
    required String roomId,
    required String userId,
  }) async {
    final snapshot = await _swipes(roomId)
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          final itemType = data['itemType'] as String?;
          if (itemType == 'place') {
            return data['itemId'] as String?;
          }
          return null;
        })
        .whereType<String>()
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

  Stream<List<String>> watchLikedUserIdsForPlace({
    required String roomId,
    required String placeId,
  }) {
    return _swipes(roomId)
        .where('itemId', isEqualTo: placeId)
        .where('itemType', isEqualTo: 'place')
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
          .map((doc) => SwipeMatch.fromMap(doc.data(), docId: doc.id))
          .toList(growable: false);
    });
  }

  Future<SwipeSubmitOutcome> submitSwipe({
    required String roomId,
    required String userId,
    required Movie movie,
    required SwipeDecision decision,
    required int nextIndex,
  }) {
    return _submitItemSwipe(
      roomId: roomId,
      userId: userId,
      itemType: 'movie',
      itemId: '${movie.id}',
      matchDocId: '${movie.id}',
      title: movie.title,
      posterPath: movie.posterPath,
      googleMapsUri: null,
      movieId: movie.id,
      queryField: 'movieId',
      queryValue: movie.id,
      decision: decision,
      nextIndex: nextIndex,
    );
  }

  Future<SwipeSubmitOutcome> submitPlaceSwipe({
    required String roomId,
    required String userId,
    required Place place,
    required SwipeDecision decision,
    required int nextIndex,
  }) {
    return _submitItemSwipe(
      roomId: roomId,
      userId: userId,
      itemType: 'place',
      itemId: place.placeId,
      matchDocId: place.placeId,
      title: place.name,
      posterPath: place.photoUrl,
      googleMapsUri: place.googleMapsUri,
      movieId: null,
      queryField: 'itemId',
      queryValue: place.placeId,
      decision: decision,
      nextIndex: nextIndex,
    );
  }

  Future<SwipeSubmitOutcome> _submitItemSwipe({
    required String roomId,
    required String userId,
    required String itemType,
    required String itemId,
    required String matchDocId,
    required String title,
    required String? posterPath,
    required String? googleMapsUri,
    required int? movieId,
    required String queryField,
    required Object queryValue,
    required SwipeDecision decision,
    required int nextIndex,
  }) async {
    final swipeDocId = '${itemId}_$userId';
    final swipePayload = <String, dynamic>{
      'itemType': itemType,
      'itemId': itemId,
      'userId': userId,
      'action': decision.wireValue,
      'createdAt': FieldValue.serverTimestamp(),
    };
    if (movieId != null) {
      swipePayload['movieId'] = movieId;
    }

    await _swipes(roomId).doc(swipeDocId).set(
      swipePayload,
      SetOptions(merge: true),
    );

    await _progress(roomId).doc(userId).set({
      'currentIndex': nextIndex,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final roomSnapshot = await _room(roomId).get();
    final roomData = roomSnapshot.data() ?? const <String, dynamic>{};
    final members = (roomData['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toSet();

    if (members.length < 2) {
      return const SwipeSubmitOutcome();
    }

    Query<Map<String, dynamic>> swipeQuery = _swipes(roomId);
    swipeQuery = swipeQuery.where(queryField, isEqualTo: queryValue);
    if (itemType == 'place') {
      swipeQuery = swipeQuery.where('itemType', isEqualTo: 'place');
    }
    final itemSwipes = await swipeQuery.get();

    final likedUserIds = <String>{};
    final dislikedUserIds = <String>{};
    for (final doc in itemSwipes.docs) {
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
    final likeCount = likedUserIds.length;

    if (likeCount < threshold) {
      return SwipeSubmitOutcome(
        memberCount: memberCount,
        likeCount: likeCount,
      );
    }

    final matchRef = _matches(roomId).doc(matchDocId);
    final existingMatch = await matchRef.get();
    final previousLikeCount = existingMatch.exists
        ? _likedByCount(existingMatch.data())
        : 0;
    final matchJustQualified =
        previousLikeCount < threshold && likeCount >= threshold;

    final matchType = memberCount == 2 || likeCount >= memberCount
        ? 'perfect'
        : 'majority';
    final score = likedUserIds.length / memberCount;

    final matchPayload = <String, dynamic>{
      'itemType': itemType,
      'itemId': itemId,
      'title': title,
      'posterPath': posterPath,
      'likedBy': likedUserIds.toList(growable: false),
      'dislikedBy': dislikedUserIds.toList(growable: false),
      'matchType': matchType,
      'score': score,
    };
    if (movieId != null) {
      matchPayload['movieId'] = movieId;
    }
    if (googleMapsUri != null) {
      matchPayload['googleMapsUri'] = googleMapsUri;
    }
    if (!existingMatch.exists) {
      matchPayload['createdAt'] = FieldValue.serverTimestamp();
    }

    await matchRef.set(matchPayload, SetOptions(merge: true));

    if (matchJustQualified) {
      if (matchType == 'perfect') {
        unawaited(_analytics.logPerfectMatch(memberCount: memberCount));
      } else {
        unawaited(
          _analytics.logMajorityMatch(
            memberCount: memberCount,
            likeCount: likeCount,
          ),
        );
      }

      return SwipeSubmitOutcome(
        matchCreated: true,
        matchType: matchType,
        memberCount: memberCount,
        likeCount: likeCount,
      );
    }

    return SwipeSubmitOutcome(
      memberCount: memberCount,
      likeCount: likeCount,
    );
  }

  int _likedByCount(Map<String, dynamic>? data) {
    if (data == null) {
      return 0;
    }
    return (data['likedBy'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .length;
  }
}

/// Minimum number of **member** likes required before creating a match.
/// Returns a value greater than any possible like count when [memberCount] < 2.
int matchLikeThreshold(int memberCount) {
  if (memberCount < 2) {
    return memberCount + 1;
  }
  if (memberCount == 2) {
    return 2;
  }
  return (memberCount * 0.75).floor().clamp(2, memberCount);
}

/// Whether a match should trigger celebration for the current room size.
bool isGroupMatch(SwipeMatch match, int memberCount) {
  if (memberCount < 2) {
    return false;
  }
  return match.likedBy.length >= matchLikeThreshold(memberCount);
}

/// True when the match newly crossed the like threshold (e.g. 1 → 2 likes).
bool matchJustCrossedThreshold({
  required SwipeMatch? previous,
  required SwipeMatch current,
  required int memberCount,
}) {
  if (memberCount < 2) {
    return false;
  }
  final threshold = matchLikeThreshold(memberCount);
  final previousLikes = previous?.likedBy.length ?? 0;
  return previousLikes < threshold && current.likedBy.length >= threshold;
}
