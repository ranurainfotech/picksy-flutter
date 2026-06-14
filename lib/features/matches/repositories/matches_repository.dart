import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../rooms/repositories/room_repository.dart';
import '../../swipe/models/swipe_match.dart';
import '../../swipe/repositories/swipe_repository.dart';
import '../models/match_feed_item.dart';

class MatchesRepository {
  MatchesRepository(this._roomRepository, this._swipeRepository);

  final RoomRepository _roomRepository;
  final SwipeRepository _swipeRepository;

  static const feedPageSize = 20;

  Stream<List<MatchFeedItem>> watchFeedForUser(String uid) {
    return _roomRepository.watchRoomsForUser(uid).asyncExpand((roomsSnapshot) {
      final roomDocs = roomsSnapshot.docs;
      if (roomDocs.isEmpty) {
        return Stream.value(const <MatchFeedItem>[]);
      }

      final controller = StreamController<List<MatchFeedItem>>();
      final latestByRoom = <String, List<MatchFeedItem>>{};
      final subscriptions = <StreamSubscription<List<SwipeMatch>>>[];

      void emitMerged() {
        if (controller.isClosed) {
          return;
        }
        final merged = latestByRoom.values
            .expand((items) => items)
            .toList(growable: false)
          ..sort((a, b) {
            final aTime = a.matchedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime = b.matchedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });
        controller.add(merged);
      }

      for (final roomDoc in roomDocs) {
        final roomId = roomDoc.id;
        final roomData = roomDoc.data();
        final members = (roomData['members'] as List? ?? const <dynamic>[])
            .whereType<String>()
            .length;
        final memberCountField = roomData['memberCount'] as int? ?? 0;
        final memberCount = memberCountField > members ? memberCountField : members;

        final subscription = _swipeRepository.watchMatches(roomId).listen(
          (matches) {
            latestByRoom[roomId] = matches
                .where((match) => isGroupMatch(match, memberCount))
                .map(
                  (match) => MatchFeedItem.fromRoomMatch(
                    roomId: roomId,
                    roomData: roomData,
                    match: match,
                  ),
                )
                .toList(growable: false);
            emitMerged();
          },
          onError: controller.addError,
        );
        subscriptions.add(subscription);
      }

      controller.onCancel = () async {
        for (final subscription in subscriptions) {
          await subscription.cancel();
        }
      };

      return controller.stream;
    });
  }

  Future<MatchFeedItem?> getMatch({
    required String roomId,
    required int itemId,
  }) async {
    final snapshot = await _roomRepository.getRoom(roomId);
    final roomData = snapshot.data();
    if (roomData == null) {
      return null;
    }

    final matchDoc = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId.trim().toUpperCase())
        .collection('matches')
        .doc('$itemId')
        .get();
    if (!matchDoc.exists) {
      return null;
    }

    final match = SwipeMatch.fromMap(matchDoc.data() ?? const {});
    final members = (roomData['members'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .length;
    final memberCountField = roomData['memberCount'] as int? ?? 0;
    final memberCount = memberCountField > members ? memberCountField : members;

    if (!isGroupMatch(match, memberCount)) {
      return null;
    }

    return MatchFeedItem.fromRoomMatch(
      roomId: roomId.trim().toUpperCase(),
      roomData: roomData,
      match: match,
    );
  }
}
