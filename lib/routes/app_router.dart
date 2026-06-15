import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picksy_flutter/features/rooms/screens/room_lobby_screen.dart';

import '../features/auth/providers/session_redirect_provider.dart';
import '../features/home/screens/home_shell.dart';
import '../features/matches/screens/match_details_screen.dart';
import '../features/matches/models/match_feed_item.dart';
import '../features/onboarding/screens/nickname_avatar_screen.dart';
import '../features/rooms/screens/create_join_room_screen.dart';
import '../features/rooms/providers/create_join_room_provider.dart';
import '../features/rooms/screens/create_room_details_screen.dart';
import '../features/swipe/screens/swipe_experience_screen.dart';
import '../features/welcome/screens/welcome_screen.dart';
import 'app_routes.dart';

bool _isProtectedRoute(String path) {
  return path == AppRoutes.home ||
      path.startsWith('/rooms/') ||
      path.startsWith('/matches/');
}

GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.root,
    redirect: (context, state) {
      final session = ref.read(sessionRedirectNotifierProvider);
      final path = state.uri.path;

      if (session == SessionRedirectState.resolving) {
        return null;
      }

      if (session == SessionRedirectState.unauthenticated) {
        if (path == AppRoutes.root) {
          return AppRoutes.welcome;
        }

        if (_isProtectedRoute(path) || path == AppRoutes.onboarding) {
          return AppRoutes.welcome;
        }

        return null;
      }

      if (session == SessionRedirectState.needsOnboarding) {
        if (path == AppRoutes.root || path == AppRoutes.welcome) {
          return AppRoutes.onboarding;
        }

        if (_isProtectedRoute(path)) {
          return AppRoutes.onboarding;
        }

        return null;
      }

      if (path == AppRoutes.root) {
        return AppRoutes.home;
      }

      if (path == AppRoutes.welcome || path == AppRoutes.onboarding) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.root,
        redirect: (context, state) {
          final session = ref.read(sessionRedirectNotifierProvider);

          return switch (session) {
            SessionRedirectState.resolving => null,
            SessionRedirectState.unauthenticated => AppRoutes.welcome,
            SessionRedirectState.needsOnboarding => AppRoutes.onboarding,
            SessionRedirectState.authenticated => AppRoutes.home,
          };
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
          final extra = state.extra;
          RoomDecisionCategory category = RoomDecisionCategory.movies;
          String? editRoomId;

          if (extra is RoomDecisionCategory) {
            category = extra;
          } else if (extra is Map<String, dynamic>) {
            final categoryId = (extra['category'] as String?)?.toLowerCase();
            editRoomId = (extra['roomId'] as String?)?.trim();
            category = switch (categoryId) {
              'restaurants' => RoomDecisionCategory.restaurants,
              'activities' => RoomDecisionCategory.activities,
              _ => RoomDecisionCategory.movies,
            };
          }

          return CreateRoomDetailsScreen(
            category: category,
            editRoomId: editRoomId,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.roomLobbyPattern,
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          final fromSwipe = state.uri.queryParameters['fromSwipe'] == '1';
          return RoomLobbyScreen(
            roomId: roomId,
            suppressAutoRedirectToSwipe: fromSwipe,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.roomSwipePattern,
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return SwipeExperienceScreen(roomId: roomId);
        },
      ),
      GoRoute(
        path: AppRoutes.matchDetailsPattern,
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          final itemId = Uri.decodeComponent(
            state.pathParameters['itemId'] ?? '',
          );
          final initialItem = state.extra is MatchFeedItem
              ? state.extra as MatchFeedItem
              : null;
          return MatchDetailsScreen(
            roomId: roomId,
            itemId: itemId,
            initialItem: initialItem,
          );
        },
      ),
    ],
  );
}
