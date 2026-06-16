import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/subscription_tier.dart';

class SubscriptionService {
  bool _configured = false;
  SubscriptionTier _resolvedTier = SubscriptionTier.free;
  String? _lastLoggedEntitlementSignature;

  bool get isConfigured => _configured;

  SubscriptionTier get resolvedTier => _resolvedTier;

  Future<void> configure({required String uid}) async {
    if (kIsWeb) {
      return;
    }

    final apiKey = _resolveApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('[Subscription] RevenueCat API key missing — purchases disabled.');
      return;
    }

    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.warn);
    await Purchases.configure(PurchasesConfiguration(apiKey)..appUserID = uid);
    _configured = true;
  }

  Future<void> logIn(String uid) async {
    if (!_configured) {
      return;
    }
    await Purchases.logIn(uid);
  }

  Future<void> logOut() async {
    if (!_configured) {
      return;
    }
    _resolvedTier = SubscriptionTier.free;
    await Purchases.logOut();
  }

  Future<SubscriptionTier> fetchTier() async {
    if (!_configured) {
      return SubscriptionTier.free;
    }

    final info = await Purchases.getCustomerInfo();
    return applyCustomerInfo(info);
  }

  Future<List<Package>> fetchPackages() async {
    if (!_configured) {
      return const <Package>[];
    }

    final offerings = await Purchases.getOfferings();
    final current = offerings.current;
    if (current == null) {
      return const <Package>[];
    }
    return current.availablePackages;
  }

  Future<SubscriptionTier> purchase(Package package) async {
    if (!_configured) {
      throw StateError('RevenueCat is not configured.');
    }

    final result = await Purchases.purchase(PurchaseParams.package(package));
    return _resolveTierAfterPurchase(result.customerInfo);
  }

  Future<SubscriptionTier> restore() async {
    if (!_configured) {
      throw StateError('RevenueCat is not configured.');
    }

    final info = await Purchases.restorePurchases();
    return applyCustomerInfo(info);
  }

  SubscriptionTier applyCustomerInfo(CustomerInfo info) {
    final tier = _tierFromCustomerInfo(info);
    _resolvedTier = tier;
    return tier;
  }

  Future<SubscriptionTier> _resolveTierAfterPurchase(CustomerInfo info) async {
    var tier = applyCustomerInfo(info);
    if (tier.isPro) {
      return tier;
    }

    for (var attempt = 0; attempt < 3; attempt++) {
      await Future<void>.delayed(Duration(milliseconds: 250 * (attempt + 1)));
      final refreshed = await Purchases.getCustomerInfo();
      tier = applyCustomerInfo(refreshed);
      if (tier.isPro) {
        return tier;
      }
    }

    return tier;
  }

  SubscriptionTier tierFromCustomerInfo(CustomerInfo info) {
    return _tierFromCustomerInfo(info);
  }

  SubscriptionTier _tierFromCustomerInfo(CustomerInfo info) {
    final active = info.entitlements.active;
    _logEntitlementsIfChanged(active.keys.toList());

    if (active.containsKey('pro') || active.containsKey('premium')) {
      return SubscriptionTier.pro;
    }

    for (final key in active.keys) {
      final normalized = key.toLowerCase();
      if (normalized.contains('pro') || normalized.contains('premium')) {
        return SubscriptionTier.pro;
      }
    }

    if (active.isNotEmpty) {
      return SubscriptionTier.pro;
    }

    return SubscriptionTier.free;
  }

  void _logEntitlementsIfChanged(List<String> entitlementKeys) {
    if (!kDebugMode) {
      return;
    }

    final signature = entitlementKeys.join('|');
    if (signature == _lastLoggedEntitlementSignature) {
      return;
    }

    _lastLoggedEntitlementSignature = signature;
    debugPrint('[Subscription] Active entitlements: $entitlementKeys');
  }

  String? _resolveApiKey() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _firstNonEmpty([
        dotenv.env['REVENUECAT_IOS_API_KEY'],
        dotenv.env['REVENUECAT_API_KEY'],
      ]);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _firstNonEmpty([
        dotenv.env['REVENUECAT_ANDROID_API_KEY'],
        dotenv.env['REVENUECAT_API_KEY'],
      ]);
    }
    return dotenv.env['REVENUECAT_API_KEY'];
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
