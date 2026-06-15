import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_auth_providers.dart';

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
