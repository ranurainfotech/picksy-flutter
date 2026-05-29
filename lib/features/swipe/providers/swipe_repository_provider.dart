import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/analytics_provider.dart';
import '../../onboarding/providers/user_repository_provider.dart';
import '../repositories/swipe_repository.dart';

final swipeRepositoryProvider = Provider<SwipeRepository>((ref) {
  return SwipeRepository(
    ref.watch(firestoreProvider),
    ref.watch(analyticsServiceProvider),
  );
});
