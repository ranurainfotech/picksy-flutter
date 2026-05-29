import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract class CrashReportingService {
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  });
}

class FirebaseCrashReportingService implements CrashReportingService {
  FirebaseCrashReportingService(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  static Future<void> configureGlobalHandlers() async {
    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    FlutterError.onError = crashlytics.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  }) {
    return _crashlytics.recordError(error, stackTrace, fatal: fatal);
  }
}
