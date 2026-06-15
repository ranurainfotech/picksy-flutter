import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repository.dart';
import 'firebase_auth_providers.dart';
import 'session_redirect_provider.dart';

export 'firebase_auth_providers.dart';

final googleSignInActionProvider =
    AsyncNotifierProvider<GoogleSignInActionNotifier, void>(
      GoogleSignInActionNotifier.new,
    );

class GoogleSignInActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> signIn() async {
    state = const AsyncLoading();

    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      await ref.read(sessionRedirectNotifierProvider.notifier).refresh();
      state = const AsyncData(null);
      return true;
    } on GoogleSignInCancelledException {
      state = const AsyncData(null);
      return false;
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncError(_friendlyAuthError(error), stackTrace);
      return false;
    } catch (error, stackTrace) {
      state = AsyncError(
        'Could not sign in with Google. Try again.',
        stackTrace,
      );
      return false;
    }
  }

  void clearError() {
    if (state.hasError) {
      state = const AsyncData(null);
    }
  }

  String _friendlyAuthError(FirebaseAuthException error) {
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

final signOutProvider = AsyncNotifierProvider<SignOutNotifier, void>(
  SignOutNotifier.new,
);

class SignOutNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> signOut() async {
    state = const AsyncLoading();

    try {
      await ref.read(authRepositoryProvider).signOut();
      await ref.read(sessionRedirectNotifierProvider.notifier).refresh();
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError('Could not log out. Try again.', stackTrace);
      return false;
    }
  }

  void clearError() {
    if (state.hasError) {
      state = const AsyncData(null);
    }
  }
}
