import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/user_repository.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(firestoreProvider));
});
