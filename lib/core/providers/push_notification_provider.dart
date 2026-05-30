import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/onboarding/providers/user_repository_provider.dart';
import '../repositories/push_token_repository.dart';
import '../services/notifications/push_notification_service.dart';

final flutterLocalNotificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
      return FlutterLocalNotificationsPlugin();
    });

final pushTokenRepositoryProvider = Provider<PushTokenRepository>((ref) {
  return PushTokenRepository(ref.watch(firestoreProvider));
});

final pushNotificationServiceProvider = Provider<PushNotificationService>((
  ref,
) {
  return PushNotificationService(
    FirebaseMessaging.instance,
    ref.watch(flutterLocalNotificationsPluginProvider),
    ref.watch(pushTokenRepositoryProvider),
  );
});
