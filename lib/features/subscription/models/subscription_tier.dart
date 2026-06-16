enum SubscriptionTier {
  free,
  pro;

  bool get isPro => this == SubscriptionTier.pro;

  static SubscriptionTier fromWire(String? value) {
    return switch (value?.toLowerCase()) {
      'pro' => SubscriptionTier.pro,
      _ => SubscriptionTier.free,
    };
  }

  String get wireValue => switch (this) {
        SubscriptionTier.free => 'free',
        SubscriptionTier.pro => 'pro',
      };
}
