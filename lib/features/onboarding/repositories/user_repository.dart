import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/models/app_user.dart';

class UsernameTakenException implements Exception {
  const UsernameTakenException();
}

class UserRepository {
  const UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _usernames =>
      _firestore.collection('usernames');

  Future<bool> isUsernameAvailable(String username) async {
    final usernameSnapshot = await _usernames.doc(username).get();
    return !usernameSnapshot.exists;
  }

  Future<bool> userExists(String uid) async {
    final userSnapshot = await _users.doc(uid).get();
    return userSnapshot.exists;
  }

  Future<void> createUser({
    required String uid,
    required String username,
    required String avatarId,
    required bool isAnonymous,
  }) async {
    final usernameRef = _usernames.doc(username);
    final userRef = _users.doc(uid);

    await _firestore.runTransaction((transaction) async {
      final usernameSnapshot = await transaction.get(usernameRef);

      if (usernameSnapshot.exists) {
        throw const UsernameTakenException();
      }

      final user = AppUser(
        uid: uid,
        username: username,
        avatarId: avatarId,
        isAnonymous: isAnonymous,
        roomsCount: 0,
        matchesCount: 0,
      );
      final userJson = user.toJson()
        ..['createdAt'] = FieldValue.serverTimestamp()
        ..['lastSeen'] = FieldValue.serverTimestamp();

      transaction
        ..set(usernameRef, {'uid': uid})
        ..set(userRef, userJson);
    });
  }
}
