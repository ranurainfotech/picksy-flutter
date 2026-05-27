abstract final class AppRoutes {
  static const root = '/';
  static const welcome = '/welcome';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const createJoinRoom = '/rooms/create';
  static const roomSetup = '/rooms/setup';
  static const roomLobbyPattern = '/rooms/:roomId';
  static const roomSwipePattern = '/rooms/:roomId/swipe';

  static String roomLobby(String roomId) => '/rooms/$roomId';
  static String roomSwipe(String roomId) => '/rooms/$roomId/swipe';
}
