import '../../../routes/app_routes.dart';
import '../../onboarding/repositories/user_repository.dart';
import '../repositories/auth_repository.dart';

Future<String> resolveInitialLocation({
  required AuthRepository authRepository,
  required UserRepository userRepository,
}) async {
  final user =
      authRepository.currentUser ??
      await authRepository.authStateChanges().first;

  if (user == null) {
    return AppRoutes.welcome;
  }

  try {
    final hasProfile = await userRepository.userExists(user.uid);
    return hasProfile ? AppRoutes.home : AppRoutes.onboarding;
  } catch (_) {
    return AppRoutes.onboarding;
  }
}
