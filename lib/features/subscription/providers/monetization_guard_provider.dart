import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/firebase_auth_providers.dart';
import '../exceptions/monetization_exceptions.dart';
import '../repositories/entitlements_repository.dart';
import 'entitlements_repository_provider.dart';
import 'monetization_runtime.dart';
import 'subscription_providers.dart';

class MonetizationGuard {
  MonetizationGuard(this._ref);

  final Ref _ref;

  EntitlementsRepository get _repository =>
      _ref.read(entitlementsRepositoryProvider);

  String? get _uid => _ref.read(authRepositoryProvider).currentUser?.uid;

  Future<void> assertCanCreateRoom() async {
    final uid = _uid;
    if (uid == null) {
      return;
    }

    final config = await readMonetizationConfig(_ref);
    final entitlements = await readUserEntitlements(_ref, uid);

    try {
      await _repository.assertCanCreateRoom(
        uid: uid,
        config: config,
        entitlements: entitlements,
      );
    } on MonetizationLimitException catch (error) {
      _ref.read(paywallRequestProvider.notifier).request(error.paywallReason);
      rethrow;
    }
  }

  Future<void> assertCanSwipe() async {
    final uid = _uid;
    if (uid == null) {
      return;
    }

    final config = await readMonetizationConfig(_ref);
    final entitlements = await readUserEntitlements(_ref, uid);

    try {
      await _repository.assertCanSwipe(
        uid: uid,
        config: config,
        entitlements: entitlements,
      );
    } on MonetizationLimitException catch (error) {
      _ref.read(paywallRequestProvider.notifier).request(error.paywallReason);
      rethrow;
    }
  }

  Future<void> recordSwipe() async {
    final uid = _uid;
    if (uid == null) {
      return;
    }

    final config = await readMonetizationConfig(_ref);
    final entitlements = await readUserEntitlements(_ref, uid);

    try {
      await _repository.recordSwipe(
        uid: uid,
        config: config,
        entitlements: entitlements,
      );
    } on MonetizationLimitException catch (error) {
      _ref.read(paywallRequestProvider.notifier).request(error.paywallReason);
      rethrow;
    }
  }
}

final monetizationGuardProvider = Provider<MonetizationGuard>((ref) {
  return MonetizationGuard(ref);
});
