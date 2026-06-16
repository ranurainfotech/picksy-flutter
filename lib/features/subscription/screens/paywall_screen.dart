import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/theme/app_design_system.dart';
import '../exceptions/monetization_exceptions.dart';
import '../providers/subscription_providers.dart';
import '../providers/subscription_sync.dart';
import '../widgets/subscription_success_snackbar.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({
    super.key,
    this.reason = PaywallReason.profileUpgrade,
  });

  final PaywallReason reason;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  List<Package> _packages = const <Package>[];
  bool _loadingPackages = true;
  bool _purchasing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadPackages());
    });
  }

  Future<void> _loadPackages() async {
    try {
      final packages =
          await ref.read(subscriptionServiceProvider).fetchPackages();
      if (!mounted) {
        return;
      }
      setState(() {
        _packages = packages;
        _loadingPackages = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loadingPackages = false;
        _errorMessage = 'Could not load plans. Try again.';
      });
    }
  }

  String get _headline => switch (widget.reason) {
        PaywallReason.roomCap => 'You\'ve reached the free room limit',
        PaywallReason.swipeCap => 'Daily swipe limit reached',
        PaywallReason.profileUpgrade => 'Upgrade to Picksy Pro',
      };

  String get _subtitle => switch (widget.reason) {
        PaywallReason.roomCap =>
          'Free accounts can host 2 active rooms. Upgrade for unlimited rooms.',
        PaywallReason.swipeCap =>
          'Free accounts get 20 swipes per day. Upgrade for unlimited swiping.',
        PaywallReason.profileUpgrade =>
          'Unlock unlimited rooms, unlimited swipes, and an ad-free experience.',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.darkSurface),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.small),
                Text(_headline, style: AppTypography.heading2),
                const SizedBox(height: AppSpacing.small),
                Text(
                  _subtitle,
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSpacing.section),
                _BenefitRow(text: 'Unlimited room creation'),
                _BenefitRow(text: 'Unlimited daily swipes'),
                _BenefitRow(text: 'No ads — ever'),
                const Spacer(),
                if (_loadingPackages)
                  const Center(child: CircularProgressIndicator())
                else if (_packages.isEmpty)
                  Text(
                    'Subscriptions are not configured yet. Add RevenueCat keys to .env.',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.tertiaryText,
                    ),
                  )
                else
                  ..._packages.map(_packageButton),
                const SizedBox(height: AppSpacing.small),
                AppButton.secondary(
                  label: _purchasing ? 'Restoring...' : 'Restore purchases',
                  onPressed: _purchasing ? null : _restore,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    _errorMessage!,
                    style: AppTypography.caption.copyWith(color: AppColors.reject),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _packageButton(Package package) {
    final label = package.storeProduct.title;
    final price = package.storeProduct.priceString;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: AppButton.primary(
        label: _purchasing ? 'Processing...' : '$label — $price',
        onPressed: _purchasing ? null : () => _purchase(package),
      ),
    );
  }

  Future<void> _purchase(Package package) async {
    setState(() {
      _purchasing = true;
      _errorMessage = null;
    });

    try {
      await ref.read(subscriptionServiceProvider).purchase(package);
      final tier = await syncSubscriptionTier(ref);
      if (!mounted) {
        return;
      }

      if (tier.isPro) {
        showSubscriptionSuccessSnackBar(context, isPro: true);
      }

      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _purchasing = false;
        _errorMessage = 'Purchase failed. Try again.';
      });
    }
  }

  Future<void> _restore() async {
    setState(() {
      _purchasing = true;
      _errorMessage = null;
    });

    try {
      await ref.read(subscriptionServiceProvider).restore();
      final tier = await syncSubscriptionTier(ref);
      if (!mounted) {
        return;
      }

      if (tier.isPro) {
        showSubscriptionSuccessSnackBar(context, isPro: true);
      }

      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _purchasing = false;
        _errorMessage = 'Could not restore purchases.';
      });
    }
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.compact),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.neonPink, size: 18),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyRegular.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}