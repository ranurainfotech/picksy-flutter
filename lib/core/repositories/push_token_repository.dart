import 'package:cloud_firestore/cloud_firestore.dart';

class PushTokenRepository {
  const PushTokenRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _pushTokens =>
      _firestore.collection('pushTokens');

  Future<void> upsertToken({
    required String uid,
    required String token,
    required String platform,
  }) async {
    await _pushTokens.doc(uid).set({
      'tokens': FieldValue.arrayUnion([token]),
      'platform': platform,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeToken({
    required String uid,
    required String token,
  }) async {
    await _pushTokens.doc(uid).update({
      'tokens': FieldValue.arrayRemove([token]),
    });
  }

  Future<List<String>> collectTokensForMembers(List<String> memberIds) async {
    final tokens = <String>{};
    for (final uid in memberIds) {
      final snapshot = await _pushTokens.doc(uid).get();
      final data = snapshot.data();
      if (data == null) {
        continue;
      }
      final raw = data['tokens'];
      if (raw is! List) {
        continue;
      }
      for (final entry in raw) {
        if (entry is String && entry.isNotEmpty) {
          tokens.add(entry);
        }
      }
    }
    return tokens.toList(growable: false);
  }
}
