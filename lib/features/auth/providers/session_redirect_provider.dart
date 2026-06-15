import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../onboarding/providers/user_repository_provider.dart';
import 'firebase_auth_providers.dart';

enum SessionRedirectState {
  resolving,
  unauthenticated,
  needsOnboarding,
  authenticated,
}

final sessionRedirectNotifierProvider =
    NotifierProvider<SessionRedirectNotifier, SessionRedirectState>(
      SessionRedirectNotifier.new,
    );

class SessionRedirectNotifier extends Notifier<SessionRedirectState> {
  @override
  SessionRedirectState build() {
    ref.listen(authStateProvider, (_, _) {
      unawaited(refresh());
    });
    unawaited(refresh());
    return SessionRedirectState.resolving;
  }

  Future<void> refresh() async {
    final user = ref.read(authRepositoryProvider).currentUser;

    if (user == null) {
      state = SessionRedirectState.unauthenticated;
      return;
    }

    try {
      final hasProfile = await ref
          .read(userRepositoryProvider)
          .userExists(user.uid);
      state = hasProfile
          ? SessionRedirectState.authenticated
          : SessionRedirectState.needsOnboarding;
    } catch (_) {
      state = SessionRedirectState.needsOnboarding;
    }
  }
}
