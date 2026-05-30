import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_providers.dart';
import '../../routes/app_routes.dart';
import '../providers/push_notification_provider.dart';

class PushNotificationListener extends ConsumerStatefulWidget {
  const PushNotificationListener({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<PushNotificationListener> createState() =>
      _PushNotificationListenerState();
}

class _PushNotificationListenerState
    extends ConsumerState<PushNotificationListener> {
  var _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_initializeMessaging());
    });
  }

  Future<void> _initializeMessaging() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    final service = ref.read(pushNotificationServiceProvider);
    await service.initialize(
      onNavigate: (roomId) {
        if (!mounted) {
          return;
        }
        context.go(AppRoutes.roomSwipe(roomId));
      },
    );

    final user = ref.read(authStateProvider).asData?.value;
    if (user != null) {
      await service.bindUser(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (previous, next) {
      final service = ref.read(pushNotificationServiceProvider);
      final user = next.asData?.value;
      if (user == null) {
        unawaited(service.unbindUser());
        return;
      }
      unawaited(service.bindUser(user.uid));
    });

    return widget.child;
  }
}
