import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  const AuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
