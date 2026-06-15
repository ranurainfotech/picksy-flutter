import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routes/app_routes.dart';
import '../../onboarding/providers/user_repository_provider.dart';
import '../models/auth_exceptions.dart';
import '../services/auth_error_messages.dart';
import 'firebase_auth_providers.dart';

final googleSignInActionProvider =
    AsyncNotifierProvider<GoogleSignInActionNotifier, void>(
      GoogleSignInActionNotifier.new,
    );

class GoogleSignInActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Signs in with Google and returns the route the app should open next.
  Future<String?> signInAndResolveRoute() async {
    state = const AsyncLoading();

    try {
      final userCredential = await ref
          .read(authRepositoryProvider)
          .signInWithGoogle();
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw const AuthFailureException(
          'Could not sign in with Google. Try again.',
        );
      }

      final hasProfile = await ref
          .read(userRepositoryProvider)
          .userExists(firebaseUser.uid);

      state = const AsyncData(null);
      return hasProfile ? AppRoutes.home : AppRoutes.onboarding;
    } on GoogleSignInCancelledException {
      state = const AsyncData(null);
      return null;
    } on AuthFailureException catch (error, stackTrace) {
      state = AsyncError(error.message, stackTrace);
      return null;
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncError(AuthErrorMessages.fromFirebaseAuth(error), stackTrace);
      return null;
    } catch (error, stackTrace) {
      state = AsyncError(
        'Could not sign in with Google. Try again.',
        stackTrace,
      );
      return null;
    }
  }

  void clearError() {
    if (state.hasError) {
      state = const AsyncData(null);
    }
  }
}
