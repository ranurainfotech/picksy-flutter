import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../exceptions/monetization_exceptions.dart';
import '../models/monetization_config.dart';
import '../models/subscription_tier.dart';
import '../models/user_entitlements.dart';

class EntitlementsRepository {
  EntitlementsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _user(String uid) =>
      _firestore.collection('users').doc(uid);

  DocumentReference<Map<String, dynamic>> get _monetizationConfigRef =>
      _firestore.collection('app_config').doc('monetization');

  Stream<MonetizationConfig> watchMonetizationConfig() {
    return _monetizationConfigRef.snapshots().map((snapshot) {
      return MonetizationConfig.fromFirestore(snapshot.data());
    });
  }

  Future<MonetizationConfig> fetchMonetizationConfig() async {
    try {
      final snapshot = await _monetizationConfigRef.get();
      return MonetizationConfig.fromFirestore(snapshot.data());
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        debugPrint(
          '[Monetization] Config fetch failed (${error.code}): ${error.message}',
        );
      }
      return MonetizationConfig.disabled;
    }
  }

  Future<UserEntitlements> fetchUserEntitlements(String uid) async {
    try {
      final snapshot = await _user(uid).get();
      return UserEntitlements.fromFirestore(snapshot.data());
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        debugPrint(
          '[Monetization] Entitlements fetch failed (${error.code}): ${error.message}',
        );
      }
      return UserEntitlements.free();
    }
  }

  Stream<UserEntitlements> watchUserEntitlements(String uid) {
    return _user(uid).snapshots().map((snapshot) {
      return UserEntitlements.fromFirestore(snapshot.data());
    });
  }

  Future<int> countActiveRoomsCreatedBy(String uid) async {
    // Query by membership so Firestore security rules allow the list operation.
    final snapshot = await _firestore
        .collection('rooms')
        .where('members', arrayContains: uid)
        .get();

    var count = 0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data['createdBy'] != uid) {
        continue;
      }
      final status = (data['status'] as String? ?? 'waiting').toLowerCase();
      if (status == 'closed') {
        continue;
      }
      count += 1;
    }
    return count;
  }

  Future<void> assertCanCreateRoom({
    required String uid,
    required MonetizationConfig config,
    required UserEntitlements entitlements,
  }) async {
    if (!config.monetizationEnabled || entitlements.isPro) {
      return;
    }

    final activeRooms = await countActiveRoomsCreatedBy(uid);
    if (!entitlements.canCreateRoom(
      config: config,
      activeRoomCount: activeRooms,
    )) {
      throw const MonetizationLimitException(MonetizationLimitType.roomCap);
    }
  }

  Future<void> assertCanSwipe({
    required String uid,
    required MonetizationConfig config,
    required UserEntitlements entitlements,
  }) async {
    if (!config.monetizationEnabled || entitlements.isPro) {
      return;
    }

    if (!entitlements.canSwipe(config)) {
      throw const MonetizationLimitException(MonetizationLimitType.swipeCap);
    }
  }

  Future<void> recordSwipe({
    required String uid,
    required MonetizationConfig config,
    required UserEntitlements entitlements,
  }) async {
    if (!config.monetizationEnabled || entitlements.isPro) {
      return;
    }

    final todayKey = UserEntitlements.todayKey;
    final userRef = _user(uid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final current = UserEntitlements.fromFirestore(snapshot.data());
      final usedToday = current.swipesDayKey == todayKey
          ? current.swipesToday
          : 0;

      if (usedToday >= config.freeDailySwipeLimit) {
        throw const MonetizationLimitException(MonetizationLimitType.swipeCap);
      }

      transaction.set(
        userRef,
        {
          'usage': {
            'swipesToday': usedToday + 1,
            'swipesDayKey': todayKey,
          },
        },
        SetOptions(merge: true),
      );
    });
  }

  Future<void> setSubscriptionTier({
    required String uid,
    required SubscriptionTier tier,
    DateTime? expiresAt,
    String source = 'revenuecat',
  }) {
    return _user(uid).set(
      {
        'subscription': {
          'tier': tier.wireValue,
          if (expiresAt != null) 'expiresAt': Timestamp.fromDate(expiresAt),
          'source': source,
        },
      },
      SetOptions(merge: true),
    );
  }

  Map<String, dynamic> defaultUserMonetizationFields() {
    return {
      'subscription': {
        'tier': SubscriptionTier.free.wireValue,
        'source': 'default',
      },
      'usage': {
        'swipesToday': 0,
        'swipesDayKey': UserEntitlements.free().swipesDayKey,
      },
    };
  }
}
