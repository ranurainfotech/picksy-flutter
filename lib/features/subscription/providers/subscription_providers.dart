import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/firebase_auth_providers.dart';
import '../exceptions/monetization_exceptions.dart';
import '../models/monetization_config.dart';
import '../models/user_entitlements.dart';
import '../models/subscription_tier.dart';
import '../services/subscription_service.dart';
import 'entitlements_repository_provider.dart';

class MonetizationState {
  const MonetizationState({
    required this.config,
    required this.entitlements,
    required this.activeRoomCount,
    required this.liveTier,
  });

  final MonetizationConfig config;
  final UserEntitlements entitlements;
  final int activeRoomCount;
  final SubscriptionTier liveTier;

  bool get isPro => entitlements.isPro || liveTier.isPro;
  bool get monetizationEnabled => config.monetizationEnabled;
  bool get shouldShowAds => monetizationEnabled && !isPro;

  bool get canCreateRoom =>
      entitlements.canCreateRoom(
        config: config,
        activeRoomCount: activeRoomCount,
      );

  int get swipesRemaining => entitlements.swipesRemaining(config);

  bool get canSwipe => entitlements.canSwipe(config);
}

final monetizationConfigProvider = StreamProvider<MonetizationConfig>((ref) {
  return ref.watch(entitlementsRepositoryProvider).watchMonetizationConfig();
});

final userEntitlementsProvider = StreamProvider<UserEntitlements>((ref) {
  final uid = ref.watch(authRepositoryProvider).currentUser?.uid;
  if (uid == null) {
    return Stream.value(UserEntitlements.free());
  }
  return ref.watch(entitlementsRepositoryProvider).watchUserEntitlements(uid);
});

final activeRoomCountProvider = FutureProvider<int>((ref) async {
  final uid = ref.watch(authRepositoryProvider).currentUser?.uid;
  if (uid == null) {
    return 0;
  }
  return ref.watch(entitlementsRepositoryProvider).countActiveRoomsCreatedBy(uid);
});

final monetizationStateProvider = Provider<AsyncValue<MonetizationState>>((ref) {
  final config = ref.watch(monetizationConfigProvider);
  final entitlements = ref.watch(userEntitlementsProvider);
  final activeRooms = ref.watch(activeRoomCountProvider);
  final liveTier = ref.watch(resolvedSubscriptionTierProvider);

  return config.when(
    data: (configValue) => entitlements.when(
      data: (entitlementsValue) => activeRooms.when(
        data: (roomCount) => AsyncData(
          MonetizationState(
            config: configValue,
            entitlements: entitlementsValue,
            activeRoomCount: roomCount,
            liveTier: liveTier,
          ),
        ),
        loading: () => const AsyncLoading(),
        error: (error, stackTrace) => AsyncError(error, stackTrace),
      ),
      loading: () => const AsyncLoading(),
      error: (error, stackTrace) => AsyncError(error, stackTrace),
    ),
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
  );
});

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService();
});

class ResolvedSubscriptionTierNotifier extends Notifier<SubscriptionTier> {
  @override
  SubscriptionTier build() => SubscriptionTier.free;

  void setTier(SubscriptionTier tier) {
    if (state == tier) {
      return;
    }
    state = tier;
  }
}

final resolvedSubscriptionTierProvider =
    NotifierProvider<ResolvedSubscriptionTierNotifier, SubscriptionTier>(
  ResolvedSubscriptionTierNotifier.new,
);

final paywallRequestProvider =
    NotifierProvider<PaywallRequestNotifier, PaywallReason?>(
      PaywallRequestNotifier.new,
    );

class PaywallRequestNotifier extends Notifier<PaywallReason?> {
  @override
  PaywallReason? build() => null;

  void request(PaywallReason reason) => state = reason;

  void clear() => state = null;
}
