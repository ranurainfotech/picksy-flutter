abstract final class AppRoutes {
  static const root = '/';
  static const welcome = '/welcome';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const createJoinRoom = '/rooms/create';
  static const roomSetup = '/rooms/setup';
  static const roomLobbyPattern = '/rooms/:roomId';
  static const roomSwipePattern = '/rooms/:roomId/swipe';

  static String roomLobby(String roomId, {bool fromSwipe = false}) {
    final base = '/rooms/$roomId';
    if (!fromSwipe) {
      return base;
    }
    return '$base?fromSwipe=1';
  }

  static String roomSwipe(String roomId) => '/rooms/$roomId/swipe';

  static const matchDetailsPattern = '/matches/:roomId/:itemId';

  static String matchDetails(String roomId, int itemId) =>
      '/matches/$roomId/$itemId';
}
