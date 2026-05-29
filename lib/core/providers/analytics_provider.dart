import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/analytics/analytics_service.dart';
import '../services/analytics/crash_reporting_service.dart';
import '../services/analytics/firebase_analytics_service.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return FirebaseAnalyticsService(FirebaseAnalytics.instance);
});

final crashReportingServiceProvider = Provider<CrashReportingService>((ref) {
  return FirebaseCrashReportingService(FirebaseCrashlytics.instance);
});
