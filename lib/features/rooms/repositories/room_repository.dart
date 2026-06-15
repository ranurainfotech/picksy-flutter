import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/room.dart';
import '../../places/domain/entities/place.dart';

class RoomNotFoundException implements Exception {
  const RoomNotFoundException();
}

class RoomRepository {
  RoomRepository(this._firestore, {Random? random})
    : _random = random ?? Random.secure();

  final FirebaseFirestore _firestore;
  final Random _random;

  CollectionReference<Map<String, dynamic>> get _rooms =>
      _firestore.collection('rooms');

  Future<String> createRoom({required Room room}) async {
    final roomId = room.id.isNotEmpty ? room.id : await _generateUniqueRoomId();
    final roomRef = _rooms.doc(roomId);
    final payload = room.copyWith(id: roomId).toJson()
      ..remove('createdAt');
    final filters = payload['filters'];
    if (filters is! Map<String, dynamic>) {
      payload['filters'] = room.filters.toJson();
    }

    await roomRef.set({
      ...payload,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return roomId;
  }

  Future<String> joinRoom({required String roomId, required String uid}) async {
    final normalizedRoomId = roomId.trim().toUpperCase();
    final roomRef = _rooms.doc(normalizedRoomId);
    final snapshot = await roomRef.get();

    if (!snapshot.exists) {
      throw const RoomNotFoundException();
    }

    final data = snapshot.data();
    final members = List<String>.from(data?['members'] as List? ?? []);

    if (members.contains(uid)) {
      return normalizedRoomId;
    }

    await roomRef.update({
      'members': FieldValue.arrayUnion([uid]),
      'memberCount': members.length + 1,
    });

    return normalizedRoomId;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getRoom(String roomId) {
    return _rooms.doc(roomId.trim().toUpperCase()).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchRoomsForUser(String uid) {
    return _rooms.where('members', arrayContains: uid).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchRoom(String roomId) {
    return _rooms.doc(roomId.trim().toUpperCase()).snapshots();
  }

  Future<void> updateRoomName({required String roomId, required String name}) {
    return _rooms.doc(roomId.trim().toUpperCase()).update({'name': name.trim()});
  }

  Future<void> updateRoomStatus({required String roomId, required String status}) {
    return _rooms.doc(roomId.trim().toUpperCase()).update({'status': status});
  }

  Future<void> updateRoomSetup({
    required String roomId,
    required String name,
    required String mood,
    required Map<String, dynamic> filters,
  }) {
    return _rooms.doc(roomId.trim().toUpperCase()).update({
      'name': name.trim(),
      'mood': mood,
      'filters': filters,
    });
  }

  Future<void> upsertMovieQueue({
    required String roomId,
    required List<int> movieQueue,
  }) {
    return _rooms.doc(roomId.trim().toUpperCase()).set({
      'movieQueue': movieQueue,
    }, SetOptions(merge: true));
  }

  Future<void> upsertPlaceQueue({
    required String roomId,
    required List<String> placeQueue,
  }) {
    return _rooms.doc(roomId.trim().toUpperCase()).set({
      'placeQueue': placeQueue,
    }, SetOptions(merge: true));
  }

  Future<void> mergePlaceCache({
    required String roomId,
    required List<Place> places,
  }) async {
    if (places.isEmpty) {
      return;
    }

    final normalizedRoomId = roomId.trim().toUpperCase();
    final snapshot = await _rooms.doc(normalizedRoomId).get();
    final existing = Map<String, dynamic>.from(
      snapshot.data()?['placeCache'] as Map? ?? const <String, dynamic>{},
    );

    for (final place in places) {
      if (place.placeId.isEmpty) {
        continue;
      }
      existing[place.placeId] = place.toCacheJson();
    }

    await _rooms.doc(normalizedRoomId).set({
      'placeCache': existing,
    }, SetOptions(merge: true));
  }

  Future<void> upsertPlaceDeck({
    required String roomId,
    required List<String> placeQueue,
    required List<Place> places,
  }) async {
    final normalizedRoomId = roomId.trim().toUpperCase();
    final snapshot = await _rooms.doc(normalizedRoomId).get();
    final existing = Map<String, dynamic>.from(
      snapshot.data()?['placeCache'] as Map? ?? const <String, dynamic>{},
    );

    for (final place in places) {
      if (place.placeId.isEmpty) {
        continue;
      }
      existing[place.placeId] = place.toCacheJson();
    }

    await _rooms.doc(normalizedRoomId).set({
      'placeQueue': placeQueue,
      'placeCache': existing,
    }, SetOptions(merge: true));
  }

  Future<void> clearPlaceDeck({required String roomId}) {
    return _rooms.doc(roomId.trim().toUpperCase()).set({
      'placeQueue': const <String>[],
      'placeCache': const <String, dynamic>{},
    }, SetOptions(merge: true));
  }

  Future<void> leaveRoom({required String roomId, required String uid}) async {
    final roomRef = _rooms.doc(roomId.trim().toUpperCase());
    final snapshot = await roomRef.get();

    if (!snapshot.exists) {
      throw const RoomNotFoundException();
    }

    final data = snapshot.data() ?? <String, dynamic>{};
    final members = List<String>.from(data['members'] as List? ?? const <String>[]);

    if (!members.contains(uid)) {
      return;
    }

    final nextCount = (members.length - 1).clamp(0, 9999);
    await roomRef.update({
      'members': FieldValue.arrayRemove([uid]),
      'memberCount': nextCount,
    });
  }

  Future<void> deleteRoom(String roomId) {
    return _rooms.doc(roomId.trim().toUpperCase()).delete();
  }

  Future<String> _generateUniqueRoomId() async {
    for (var attempt = 0; attempt < 8; attempt += 1) {
      final roomId = _generateRoomId();
      final snapshot = await _rooms.doc(roomId).get();

      if (!snapshot.exists) {
        return roomId;
      }
    }

    throw StateError('Could not generate a unique room code.');
  }

  String _generateRoomId() {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final buffer = StringBuffer('PKSY');

    for (var index = 0; index < 2; index += 1) {
      buffer.write(alphabet[_random.nextInt(alphabet.length)]);
    }

    return buffer.toString();
  }
}
