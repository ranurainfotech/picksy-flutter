import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract class CrashReportingService {
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  });
}

class NoOpCrashReportingService implements CrashReportingService {
  const NoOpCrashReportingService();

  static Future<void> configureGlobalHandlers() async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  }) async {}
}

class FirebaseCrashReportingService implements CrashReportingService {
  FirebaseCrashReportingService(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  static Future<void> configureGlobalHandlers() async {
    if (kIsWeb) {
      return NoOpCrashReportingService.configureGlobalHandlers();
    }

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
    if (kIsWeb) {
      return Future<void>.value();
    }

    return _crashlytics.recordError(error, stackTrace, fatal: fatal);
  }
}
