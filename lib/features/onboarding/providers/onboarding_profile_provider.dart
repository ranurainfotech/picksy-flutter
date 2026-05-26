import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/onboarding_profile_state.dart';
import '../repositories/user_repository.dart';
import '../services/username_validator.dart';
import 'user_repository_provider.dart';

final onboardingProfileProvider =
    NotifierProvider<OnboardingProfileNotifier, OnboardingProfileState>(
      OnboardingProfileNotifier.new,
    );

class OnboardingProfileNotifier extends Notifier<OnboardingProfileState> {
  @override
  OnboardingProfileState build() => OnboardingProfileState.initial();

  void updateNickname(String nickname) {
    state = state.copyWith(nickname: UsernameValidator.normalize(nickname));
  }

  void selectAvatar(String avatarId) {
    state = state.copyWith(selectedAvatarId: avatarId);
  }
}

final usernameAvailabilityProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, username) {
      final normalizedUsername = UsernameValidator.normalize(username);
      return ref
          .watch(userRepositoryProvider)
          .isUsernameAvailable(normalizedUsername);
    });

final onboardingSubmitProvider =
    AsyncNotifierProvider<OnboardingSubmitNotifier, void>(
      OnboardingSubmitNotifier.new,
    );

class OnboardingSubmitNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit() async {
    final profile = ref.read(onboardingProfileProvider);
    final username = UsernameValidator.normalize(profile.nickname);
    final validationError = UsernameValidator.validate(username);

    if (validationError != null) {
      state = AsyncError(validationError, StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    try {
      final isUsernameAvailable = await ref.read(
        usernameAvailabilityProvider(username).future,
      );

      if (!isUsernameAvailable) {
        throw const UsernameTakenException();
      }

      final userCredential = await ref
          .read(authRepositoryProvider)
          .signInAnonymously();
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw const OnboardingFailureException(
          'Could not create your session. Try again.',
        );
      }

      await ref
          .read(userRepositoryProvider)
          .createUser(
            uid: firebaseUser.uid,
            username: username,
            avatarId: profile.selectedAvatarId,
            isAnonymous: firebaseUser.isAnonymous,
          );

      state = const AsyncData(null);
      return true;
    } on UsernameTakenException catch (error, stackTrace) {
      state = AsyncError('That username is already taken.', stackTrace);
      return false;
    } on OnboardingFailureException catch (error, stackTrace) {
      state = AsyncError(error.message, stackTrace);
      return false;
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncError(_friendlyAuthError(error), stackTrace);
      return false;
    } on FirebaseException catch (error, stackTrace) {
      state = AsyncError(_friendlyFirestoreError(error), stackTrace);
      return false;
    } catch (error, stackTrace) {
      state = AsyncError(
        'Something went wrong. Check your connection and try again.',
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
      case 'operation-not-allowed':
        return 'Anonymous sign-in is not enabled yet.';
      case 'network-request-failed':
        return 'Network issue. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Give it a moment and try again.';
      default:
        return 'Could not create your session. Try again.';
    }
  }

  String _friendlyFirestoreError(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Firestore rules blocked username setup.';
      case 'unavailable':
        return 'Firestore is temporarily unavailable. Try again.';
      case 'not-found':
        return 'Firestore is not ready for this project yet.';
      case 'deadline-exceeded':
        return 'This is taking too long. Check your connection.';
      default:
        return 'Could not save your profile. Try again.';
    }
  }
}

class OnboardingFailureException implements Exception {
  const OnboardingFailureException(this.message);

  final String message;
}
