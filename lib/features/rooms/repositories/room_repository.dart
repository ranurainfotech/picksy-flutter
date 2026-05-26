import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<String> createRoom({
    required String type,
    required String createdBy,
  }) async {
    final roomId = await _generateUniqueRoomId();
    final roomRef = _rooms.doc(roomId);

    await roomRef.set({
      'roomId': roomId,
      'type': type,
      'createdBy': createdBy,
      'members': [createdBy],
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'waiting',
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

    await roomRef.update({
      'members': FieldValue.arrayUnion([uid]),
    });

    return normalizedRoomId;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getRoom(String roomId) {
    return _rooms.doc(roomId.trim().toUpperCase()).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchRoomsForUser(String uid) {
    return _rooms.where('members', arrayContains: uid).snapshots();
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
