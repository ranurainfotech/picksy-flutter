import '../constants/monetization_limits.dart';

class MonetizationConfig {
  const MonetizationConfig({
    required this.monetizationEnabled,
    required this.freeActiveRoomLimit,
    required this.freeDailySwipeLimit,
  });

  final bool monetizationEnabled;
  final int freeActiveRoomLimit;
  final int freeDailySwipeLimit;

  static const MonetizationConfig disabled = MonetizationConfig(
    monetizationEnabled: false,
    freeActiveRoomLimit: MonetizationLimits.defaultFreeActiveRoomLimit,
    freeDailySwipeLimit: MonetizationLimits.defaultFreeDailySwipeLimit,
  );

  factory MonetizationConfig.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) {
      return MonetizationConfig.disabled;
    }

    return MonetizationConfig(
      monetizationEnabled: _readBool(data['monetizationEnabled']),
      freeActiveRoomLimit:
          (data['freeActiveRoomLimit'] as num?)?.toInt() ??
          MonetizationLimits.defaultFreeActiveRoomLimit,
      freeDailySwipeLimit:
          (data['freeDailySwipeLimit'] as num?)?.toInt() ??
          MonetizationLimits.defaultFreeDailySwipeLimit,
    );
  }

  static bool _readBool(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return false;
  }
}
