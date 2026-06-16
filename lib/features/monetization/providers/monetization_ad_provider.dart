import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../subscription/providers/monetization_runtime.dart';
import '../../subscription/providers/subscription_providers.dart';
import '../services/interstitial_ad_service.dart';

final monetizationBootstrapProvider = FutureProvider<void>((ref) async {
  if (kIsWeb) {
    return;
  }

  final service = ref.read(interstitialAdServiceProvider);
  await service.initialize();
  await service.ensureReady();
});

class MonetizationAdCoordinator {
  MonetizationAdCoordinator(this._ref);

  final Ref _ref;

  Future<bool> _resolveShouldShowAds(AdTrigger trigger) async {
    final config = await readMonetizationConfig(_ref);
    final liveTier = _ref.read(resolvedSubscriptionTierProvider);
    final isPro = liveTier.isPro;

    if (kDebugMode) {
      debugPrint(
        '[Ads] ${trigger.name} check: monetizationEnabled=${config.monetizationEnabled} '
        'liveTier=${liveTier.name}',
      );
    }

    if (!config.monetizationEnabled) {
      if (kDebugMode) {
        debugPrint(
          '[Ads] Skipping ${trigger.name}: monetizationEnabled is false in Firestore.',
        );
      }
      return false;
    }

    if (isPro) {
      if (kDebugMode) {
        debugPrint('[Ads] Skipping ${trigger.name}: user is Pro.');
      }
      return false;
    }

    return true;
  }

  Future<void> show(AdTrigger trigger) async {
    if (!await _resolveShouldShowAds(trigger)) {
      return;
    }

    final service = _ref.read(interstitialAdServiceProvider);
    await service.ensureReady();

    if (kDebugMode) {
      debugPrint('[Ads] Attempting interstitial for ${trigger.name}');
    }

    await service.showIfReady(trigger);
  }
}

final monetizationAdCoordinatorProvider = Provider<MonetizationAdCoordinator>(
  (ref) => MonetizationAdCoordinator(ref),
);

final interstitialAdServiceProvider = Provider<InterstitialAdService>((ref) {
  final service = InterstitialAdService();
  ref.onDispose(service.dispose);
  return service;
});
