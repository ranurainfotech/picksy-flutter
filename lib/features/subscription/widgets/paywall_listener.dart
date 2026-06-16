import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/app_routes.dart';
import '../exceptions/monetization_exceptions.dart';
import '../providers/subscription_providers.dart';

class PaywallListener extends ConsumerWidget {
  const PaywallListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PaywallReason?>(paywallRequestProvider, (previous, next) {
      if (next == null) {
        return;
      }
      ref.read(paywallRequestProvider.notifier).clear();
      context.push(AppRoutes.paywall, extra: next);
    });

    return child;
  }
}
