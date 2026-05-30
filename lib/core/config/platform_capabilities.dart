import 'dart:io';

import 'package:flutter/foundation.dart';

/// Platform-gated features that need a paid Apple Developer account.
abstract final class PlatformCapabilities {
  /// FCM on iOS requires APNs + Apple Developer Program.
  static bool get matchPushNotificationsEnabled =>
      !kIsWeb && Platform.isAndroid;

  /// Universal Links (`applinks:picksy.app`) need Associated Domains entitlement.
  static bool get iosUniversalLinksEnabled => false;
}
