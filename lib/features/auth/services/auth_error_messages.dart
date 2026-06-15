import 'package:firebase_auth/firebase_auth.dart';

abstract final class AuthErrorMessages {
  static String fromFirebaseAuth(FirebaseAuthException error) {
    switch (error.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'operation-not-allowed':
        return 'Google sign-in is not enabled yet.';
      case 'network-request-failed':
        return 'Network issue. Check your connection and try again.';
      case 'popup-closed-by-user':
        return 'Sign-in was cancelled.';
      case 'too-many-requests':
        return 'Too many attempts. Give it a moment and try again.';
      default:
        return 'Could not sign in with Google. Try again.';
    }
  }
}
