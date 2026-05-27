import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/providers/auth_providers.dart';
import '../features/home/screens/home_shell.dart';
import '../features/onboarding/screens/nickname_avatar_screen.dart';
import '../features/rooms/screens/create_join_room_screen.dart';
import '../features/rooms/providers/create_join_room_provider.dart';
import '../features/rooms/screens/create_room_details_screen.dart';
import '../features/rooms/screens/room_lobby_screen.dart';
import '../features/swipe/screens/swipe_experience_screen.dart';
import '../features/welcome/screens/welcome_screen.dart';
import 'app_routes.dart';

GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.root,
    redirect: (context, state) {
      final currentUser = ref.read(authRepositoryProvider).currentUser;
      final path = state.uri.path;

      if (path == AppRoutes.root) {
        return currentUser == null ? AppRoutes.welcome : AppRoutes.home;
      }

      if (currentUser != null &&
          (path == AppRoutes.welcome || path == AppRoutes.onboarding)) {
        return AppRoutes.home;
      }

      if (currentUser == null &&
          (path == AppRoutes.home || path.startsWith('/rooms/'))) {
        return AppRoutes.welcome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.root,
        redirect: (context, state) {
          final currentUser = ref.read(authRepositoryProvider).currentUser;
          return currentUser == null ? AppRoutes.welcome : AppRoutes.home;
        },
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const NicknameAvatarScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeShell(),
      ),
      GoRoute(
        path: AppRoutes.createJoinRoom,
        builder: (context, state) => const CreateJoinRoomScreen(),
      ),
      GoRoute(
        path: AppRoutes.roomSetup,
        builder: (context, state) {
          final category = state.extra is RoomDecisionCategory
              ? state.extra! as RoomDecisionCategory
              : RoomDecisionCategory.movies;

          return CreateRoomDetailsScreen(category: category);
        },
      ),
      GoRoute(
        path: AppRoutes.roomLobbyPattern,
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return RoomLobbyScreen(roomId: roomId);
        },
      ),
      GoRoute(
        path: AppRoutes.roomSwipePattern,
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return SwipeExperienceScreen(roomId: roomId);
        },
      ),
    ],
  );
}
