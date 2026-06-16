enum PaywallReason {
  roomCap,
  swipeCap,
  profileUpgrade,
}

enum MonetizationLimitType {
  roomCap,
  swipeCap,
}

class MonetizationLimitException implements Exception {
  const MonetizationLimitException(this.type);

  final MonetizationLimitType type;

  PaywallReason get paywallReason => switch (type) {
        MonetizationLimitType.roomCap => PaywallReason.roomCap,
        MonetizationLimitType.swipeCap => PaywallReason.swipeCap,
      };
}
