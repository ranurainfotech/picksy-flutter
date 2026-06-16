import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/monetization_config.dart';
import '../models/user_entitlements.dart';
import 'entitlements_repository_provider.dart';
import 'subscription_providers.dart';

Future<MonetizationConfig> readMonetizationConfig(Ref ref) async {
  final streamed = ref.read(monetizationConfigProvider).asData?.value;
  if (streamed != null) {
    return streamed;
  }

  final streamState = ref.read(monetizationConfigProvider);
  if (streamState.hasError && kDebugMode) {
    debugPrint('[Monetization] Config stream error: ${streamState.error}');
  }

  final fetched =
      await ref.read(entitlementsRepositoryProvider).fetchMonetizationConfig();
  if (kDebugMode) {
    debugPrint(
      '[Monetization] Fetched config: monetizationEnabled=${fetched.monetizationEnabled}',
    );
  }
  return fetched;
}

Future<UserEntitlements> readUserEntitlements(Ref ref, String uid) async {
  final streamed = ref.read(userEntitlementsProvider).asData?.value;
  if (streamed != null) {
    return streamed;
  }

  return ref.read(entitlementsRepositoryProvider).fetchUserEntitlements(uid);
}
