import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../auth/providers/firebase_auth_providers.dart';
import '../models/subscription_tier.dart';
import 'entitlements_repository_provider.dart';
import 'subscription_bootstrap_provider.dart';
import 'subscription_providers.dart';

Future<SubscriptionTier> syncSubscriptionTier(WidgetRef ref) async {
  final uid = ref.read(authRepositoryProvider).currentUser?.uid;
  if (uid == null) {
    return SubscriptionTier.free;
  }

  await ref.read(subscriptionBootstrapProvider.future);

  final service = ref.read(subscriptionServiceProvider);
  if (!service.isConfigured) {
    return SubscriptionTier.free;
  }

  final tier = await service.fetchTier();
  await ref.read(entitlementsRepositoryProvider).setSubscriptionTier(
        uid: uid,
        tier: tier,
      );
  ref.read(resolvedSubscriptionTierProvider.notifier).setTier(tier);

  return tier;
}

final subscriptionCustomerInfoListenerProvider = Provider<void>((ref) {
  ref.watch(subscriptionBootstrapProvider);

  final service = ref.read(subscriptionServiceProvider);
  if (!service.isConfigured) {
    return;
  }

  void onCustomerInfoUpdated(CustomerInfo info) {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) {
      return;
    }

    final tier = service.applyCustomerInfo(info);
    final currentTier = ref.read(resolvedSubscriptionTierProvider);
    if (tier == currentTier) {
      return;
    }

    ref.read(resolvedSubscriptionTierProvider.notifier).setTier(tier);
    ref.read(entitlementsRepositoryProvider).setSubscriptionTier(
          uid: uid,
          tier: tier,
        );
  }

  Purchases.addCustomerInfoUpdateListener(onCustomerInfoUpdated);
  ref.onDispose(
    () => Purchases.removeCustomerInfoUpdateListener(onCustomerInfoUpdated),
  );
});
