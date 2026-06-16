import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/firebase_auth_providers.dart';
import '../providers/entitlements_repository_provider.dart';
import 'subscription_providers.dart';

final subscriptionBootstrapProvider = FutureProvider<void>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.asData?.value;
  final service = ref.read(subscriptionServiceProvider);

  if (user == null) {
    if (service.isConfigured) {
      await service.logOut();
    }
    return;
  }

  if (!service.isConfigured) {
    await service.configure(uid: user.uid);
  } else {
    await service.logIn(user.uid);
  }

  if (!service.isConfigured) {
    return;
  }

  final tier = await service.fetchTier();
  await ref.read(entitlementsRepositoryProvider).setSubscriptionTier(
        uid: user.uid,
        tier: tier,
      );
  ref.read(resolvedSubscriptionTierProvider.notifier).setTier(tier);
});
