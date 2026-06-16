import 'monetization_config.dart';
import 'subscription_tier.dart';

class UserEntitlements {
  const UserEntitlements({
    required this.tier,
    required this.swipesToday,
    required this.swipesDayKey,
  });

  final SubscriptionTier tier;
  final int swipesToday;
  final String swipesDayKey;

  bool get isPro => tier.isPro;

  static String get todayKey => _todayKey();

  factory UserEntitlements.free() {
    return UserEntitlements(
      tier: SubscriptionTier.free,
      swipesToday: 0,
      swipesDayKey: _todayKey(),
    );
  }

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  factory UserEntitlements.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) {
      return UserEntitlements.free();
    }

    final subscription = data['subscription'] as Map<String, dynamic>?;
    final usage = data['usage'] as Map<String, dynamic>?;

    return UserEntitlements(
      tier: SubscriptionTier.fromWire(subscription?['tier'] as String?),
      swipesToday: (usage?['swipesToday'] as num?)?.toInt() ?? 0,
      swipesDayKey: usage?['swipesDayKey'] as String? ?? _todayKey(),
    );
  }

  int swipesUsedToday() {
    if (swipesDayKey != _todayKey()) {
      return 0;
    }
    return swipesToday;
  }

  int swipesRemaining(MonetizationConfig config) {
    if (!config.monetizationEnabled || isPro) {
      return 999999;
    }
    return (config.freeDailySwipeLimit - swipesUsedToday()).clamp(0, 999999);
  }

  bool canSwipe(MonetizationConfig config) => swipesRemaining(config) > 0;

  bool canCreateRoom({
    required MonetizationConfig config,
    required int activeRoomCount,
  }) {
    if (!config.monetizationEnabled || isPro) {
      return true;
    }
    return activeRoomCount < config.freeActiveRoomLimit;
  }
}
