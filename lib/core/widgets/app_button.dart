import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isExpanded = true,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = true,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = true,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = true,
  }) : variant = AppButtonVariant.ghost;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isExpanded;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _gradientController;
  bool _isPressed = false;

  bool get _isDisabled => widget.onPressed == null;
  bool get _shouldAnimateGradient =>
      widget.variant == AppButtonVariant.primary && !_isDisabled;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _syncGradientAnimation();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncGradientAnimation();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = AnimatedScale(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      scale: _isPressed && !_isDisabled ? 0.96 : 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _isDisabled ? null : (_) => _setPressed(true),
        onTapCancel: _isDisabled ? null : () => _setPressed(false),
        onTapUp: _isDisabled ? null : (_) => _setPressed(false),
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return DecoratedBox(decoration: _decoration, child: child);
          },
          child: SizedBox(
            height: AppSpacing.buttonHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.section,
              ),
              child: Row(
                mainAxisSize: widget.isExpanded
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 20, color: _contentColor),
                    const SizedBox(width: AppSpacing.small),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.button.copyWith(
                        color: _contentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  BoxDecoration get _decoration {
    final borderRadius = AppRadius.buttonBorder;

    if (_isDisabled) {
      return BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: borderRadius,
        border: Border.all(color: AppColors.divider),
      );
    }

    switch (widget.variant) {
      case AppButtonVariant.primary:
        return BoxDecoration(
          gradient: AppGradients.primaryCtaFlow(_gradientController.value),
          borderRadius: borderRadius,
          boxShadow: AppShadows.neonPinkGlow,
        );
      case AppButtonVariant.secondary:
        return BoxDecoration(
          color: AppColors.elevatedCard,
          borderRadius: borderRadius,
          border: Border.all(color: AppColors.primaryBorder),
        );
      case AppButtonVariant.ghost:
        return BoxDecoration(borderRadius: borderRadius);
    }
  }

  Color get _contentColor {
    if (_isDisabled) {
      return AppColors.disabledText;
    }

    return widget.variant == AppButtonVariant.ghost
        ? AppColors.secondaryText
        : AppColors.primaryText;
  }

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() => _isPressed = value);
  }

  void _syncGradientAnimation() {
    if (_shouldAnimateGradient) {
      if (!_gradientController.isAnimating) {
        _gradientController.repeat();
      }
      return;
    }

    _gradientController.stop();
    _gradientController.value = 0;
  }
}

class AppSwipeActionButton extends StatelessWidget {
  const AppSwipeActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.glow,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final List<BoxShadow>? glow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.elevatedCard,
        border: Border.all(color: color.withValues(alpha: 0.55), width: 1.4),
        boxShadow: glow,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        iconSize: 28,
        constraints: const BoxConstraints.tightFor(
          width: AppSpacing.swipeAction,
          height: AppSpacing.swipeAction,
        ),
      ),
    );
  }
}
