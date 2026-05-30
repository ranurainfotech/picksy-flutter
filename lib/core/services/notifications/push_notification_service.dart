import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/config/platform_capabilities.dart';
import '../../../core/repositories/push_token_repository.dart';
import 'push_notification_constants.dart';

typedef PushNotificationNavigate = void Function(String roomId);

class PushNotificationService {
  PushNotificationService(
    this._messaging,
    this._localNotifications,
    this._pushTokenRepository,
  );

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final PushTokenRepository _pushTokenRepository;

  StreamSubscription<String>? _tokenRefreshSubscription;
  String? _boundUid;
  String? _activeToken;
  PushNotificationNavigate? _onNavigate;

  static Future<void> ensureAndroidChannel(
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    if (!Platform.isAndroid) {
      return;
    }

    const channel = AndroidNotificationChannel(
      PushNotificationConstants.matchesChannelId,
      PushNotificationConstants.matchesChannelName,
      description: PushNotificationConstants.matchesChannelDescription,
      importance: Importance.high,
    );

    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> initialize({
    required PushNotificationNavigate onNavigate,
  }) async {
    _onNavigate = onNavigate;

    if (!PlatformCapabilities.matchPushNotificationsEnabled) {
      return;
    }

    await ensureAndroidChannel(_localNotifications);

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final roomId = response.payload;
        if (roomId != null && roomId.isNotEmpty) {
          _onNavigate?.call(roomId);
        }
      },
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessage);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleRemoteMessage(initialMessage);
    }
  }

  Future<void> bindUser(String uid) async {
    if (!PlatformCapabilities.matchPushNotificationsEnabled) {
      return;
    }

    if (_boundUid == uid) {
      return;
    }

    await unbindUser();
    _boundUid = uid;

    final settings = await _messaging.requestPermission();
    final authorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    if (!authorized) {
      return;
    }

    await _syncTokenForUser(uid);

    _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen(
      (token) => unawaited(_persistToken(uid: uid, token: token)),
    );
  }

  Future<void> unbindUser() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;

    final uid = _boundUid;
    final token = _activeToken;
    _boundUid = null;
    _activeToken = null;

    if (uid != null && token != null) {
      await _pushTokenRepository.removeToken(uid: uid, token: token);
    }
  }

  Future<void> _syncTokenForUser(String uid) async {
    if (kIsWeb) {
      return;
    }

    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) {
      return;
    }

    await _persistToken(uid: uid, token: token);
  }

  Future<void> _persistToken({
    required String uid,
    required String token,
  }) async {
    if (token == _activeToken && _boundUid == uid) {
      return;
    }

    final previousUid = _boundUid;
    final previousToken = _activeToken;
    _activeToken = token;
    _boundUid = uid;

    if (previousUid != null &&
        previousToken != null &&
        previousToken != token) {
      await _pushTokenRepository.removeToken(
        uid: previousUid,
        token: previousToken,
      );
    }

    final platform = Platform.isIOS
        ? 'ios'
        : Platform.isAndroid
        ? 'android'
        : 'unknown';

    await _pushTokenRepository.upsertToken(
      uid: uid,
      token: token,
      platform: platform,
    );
  }

  void _handleRemoteMessage(RemoteMessage message) {
    final roomId = message.data[PushNotificationConstants.dataRoomId];
    if (roomId == null || roomId.isEmpty) {
      return;
    }
    _onNavigate?.call(roomId.trim().toUpperCase());
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) {
      return;
    }

    final roomId = message.data[PushNotificationConstants.dataRoomId];
    final androidDetails = AndroidNotificationDetails(
      PushNotificationConstants.matchesChannelId,
      PushNotificationConstants.matchesChannelName,
      channelDescription: PushNotificationConstants.matchesChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
      ),
      payload: roomId,
    );
  }
}
