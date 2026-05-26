import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../providers/create_join_room_provider.dart';
import '../theme/app_create_join_room_tokens.dart';

class CreateJoinRoomScreen extends ConsumerWidget {
  const CreateJoinRoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(createJoinRoomProvider);
    final actionState = ref.watch(createJoinRoomActionProvider);
    final notifier = ref.read(createJoinRoomProvider.notifier);
    final actionNotifier = ref.read(createJoinRoomActionProvider.notifier);
    final isLoading = actionState.isLoading;
    final errorMessage =
        roomState.errorMessage ?? actionState.error?.toString();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: _CreateJoinBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppCreateJoinRoomTokens.horizontalPadding,
                AppCreateJoinRoomTokens.topPadding,
                AppCreateJoinRoomTokens.horizontalPadding,
                AppSpacing.section,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'What are\nwe deciding?',
                    style: AppTypography.heading2.copyWith(
                      fontSize: AppCreateJoinRoomTokens.headingFontSize,
                      height: AppCreateJoinRoomTokens.headingLineHeight,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                    ),
                  ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.12),
                  const SizedBox(
                    height: AppCreateJoinRoomTokens.headingBottomGap,
                  ),
                  for (final (index, category)
                      in RoomDecisionCategory.values.indexed) ...[
                    _CategoryOption(
                          category: category,
                          isSelected: roomState.selectedCategory == category,
                          onTap: () => notifier.selectCategory(category),
                        )
                        .animate()
                        .fadeIn(delay: (70 * index).ms, duration: 260.ms)
                        .slideX(begin: 0.08, curve: Curves.easeOutCubic),
                    if (index != RoomDecisionCategory.values.length - 1)
                      const SizedBox(
                        height: AppCreateJoinRoomTokens.categoryGap,
                      ),
                  ],
                  const SizedBox(
                    height: AppCreateJoinRoomTokens.joinSectionTopGap,
                  ),
                  Text(
                    'Join a room',
                    style: AppTypography.caption.copyWith(
                      fontSize: 15,
                      color: AppColors.primaryText.withValues(alpha: 0.70),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: AppCreateJoinRoomTokens.joinLabelBottomGap,
                  ),
                  _JoinRoomRow(
                    errorMessage: errorMessage,
                    isLoading: isLoading,
                    onChanged: notifier.updateRoomCode,
                    onJoin: () async {
                      final roomId = await actionNotifier.joinRoom();

                      if (!context.mounted || roomId == null) {
                        return;
                      }

                      context.go(AppRoutes.roomLobby(roomId));
                    },
                  ),
                  const SizedBox(
                    height: AppCreateJoinRoomTokens.dividerVerticalMargin,
                  ),
                  const _OrDivider(),
                  const SizedBox(
                    height: AppCreateJoinRoomTokens.dividerVerticalMargin,
                  ),
                  _CreateRoomButton(
                    isLoading: isLoading,
                    onPressed: () async {
                      final roomId = await actionNotifier.createRoom();

                      if (!context.mounted || roomId == null) {
                        return;
                      }

                      context.go(AppRoutes.roomLobby(roomId));
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateJoinBackground extends StatelessWidget {
  const _CreateJoinBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppCreateJoinRoomTokens.backgroundGradient,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _AmbientGlow(
            alignment: Alignment(0.92, -0.94),
            color: AppColors.electricPurple,
          ),
          const _AmbientGlow(
            alignment: Alignment(-0.88, 0.96),
            color: AppColors.neonPink,
          ),
          child,
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: AppCreateJoinRoomTokens.ambientGlowSize,
          height: AppCreateJoinRoomTokens.ambientGlowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(
                  alpha: AppCreateJoinRoomTokens.ambientGlowOpacity,
                ),
                blurRadius: AppCreateJoinRoomTokens.ambientGlowBlur,
                spreadRadius: AppCreateJoinRoomTokens.ambientGlowSpread,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryOption extends StatelessWidget {
  const _CategoryOption({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final RoomDecisionCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          gradient: isSelected
              ? AppCreateJoinRoomTokens.selectedCategoryGradient
              : null,
          borderRadius: BorderRadius.circular(
            AppCreateJoinRoomTokens.categoryRadius,
          ),
          boxShadow: isSelected
              ? AppCreateJoinRoomTokens.selectedCategoryShadow
              : AppShadows.elevated,
        ),
        padding: EdgeInsets.all(
          isSelected ? AppCreateJoinRoomTokens.selectedBorderWidth : 0,
        ),
        child: Container(
          height: AppCreateJoinRoomTokens.categoryHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.section),
          decoration: BoxDecoration(
            color: AppCreateJoinRoomTokens.categoryBackground,
            borderRadius: BorderRadius.circular(
              AppCreateJoinRoomTokens.categoryRadius,
            ),
            border: isSelected
                ? null
                : Border.all(
                    color: AppColors.primaryBorder,
                    width: AppCreateJoinRoomTokens.selectedBorderWidth,
                  ),
          ),
          child: Row(
            children: [
              Text(
                category.emoji,
                style: const TextStyle(
                  fontSize: AppCreateJoinRoomTokens.categoryIconSize,
                ),
              ),
              const SizedBox(width: AppSpacing.regular),
              Expanded(
                child: Text(
                  category.label,
                  style: AppTypography.bodyLarge.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _SelectionIndicator(isSelected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (!isSelected) {
      return Container(
        width: AppCreateJoinRoomTokens.selectionIndicatorSize,
        height: AppCreateJoinRoomTokens.selectionIndicatorSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryText.withValues(alpha: 0.26),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.like,
        shape: BoxShape.circle,
        boxShadow: AppCreateJoinRoomTokens.buttonPurpleGlow,
      ),
      child: const SizedBox(
        width: AppCreateJoinRoomTokens.selectionIndicatorSize,
        height: AppCreateJoinRoomTokens.selectionIndicatorSize,
        child: Icon(
          Icons.check_rounded,
          color: AppColors.primaryText,
          size: AppCreateJoinRoomTokens.selectionCheckSize,
        ),
      ),
    );
  }
}

class _JoinRoomRow extends StatelessWidget {
  const _JoinRoomRow({
    required this.errorMessage,
    required this.isLoading,
    required this.onChanged,
    required this.onJoin,
  });

  final String? errorMessage;
  final bool isLoading;
  final ValueChanged<String> onChanged;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: AppCreateJoinRoomTokens.joinInputHeight,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  enabled: !isLoading,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      return newValue.copyWith(
                        text: newValue.text.toUpperCase(),
                        selection: newValue.selection,
                      );
                    }),
                  ],
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.characters,
                  style: AppTypography.button.copyWith(letterSpacing: 0.8),
                  decoration: InputDecoration(
                    hintText: 'Enter room code',
                    hintStyle: AppTypography.caption.copyWith(
                      color: AppColors.primaryText.withValues(alpha: 0.38),
                      fontWeight: FontWeight.w700,
                    ),
                    filled: true,
                    fillColor: AppCreateJoinRoomTokens.inputBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.medium,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppCreateJoinRoomTokens.joinInputRadius,
                      ),
                      borderSide: const BorderSide(
                        color: AppColors.primaryBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppCreateJoinRoomTokens.joinInputRadius,
                      ),
                      borderSide: const BorderSide(color: AppColors.like),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppCreateJoinRoomTokens.joinInputRadius,
                      ),
                      borderSide: const BorderSide(
                        color: AppColors.primaryBorder,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              _TactileGradientButton(
                label: 'Join',
                isLoading: isLoading,
                isExpanded: false,
                height: AppCreateJoinRoomTokens.joinInputHeight,
                horizontalPadding:
                    AppCreateJoinRoomTokens.joinButtonHorizontalPadding,
                borderRadius: AppCreateJoinRoomTokens.joinInputRadius,
                gradient: AppCreateJoinRoomTokens.joinButtonGradient,
                boxShadow: AppCreateJoinRoomTokens.buttonPurpleGlow,
                onPressed: onJoin,
              ),
            ],
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            errorMessage!,
            style: AppTypography.caption.copyWith(color: AppColors.reject),
          ),
        ],
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        const SizedBox(width: AppCreateJoinRoomTokens.dividerLabelGap),
        Text(
          'or',
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: AppCreateJoinRoomTokens.dividerLabelGap),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}

class _CreateRoomButton extends StatelessWidget {
  const _CreateRoomButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _TactileGradientButton(
      label: 'Create a New Room',
      isLoading: isLoading,
      height: AppCreateJoinRoomTokens.createButtonHeight,
      horizontalPadding: AppSpacing.section,
      borderRadius: AppCreateJoinRoomTokens.createButtonRadius,
      gradient: AppCreateJoinRoomTokens.createRoomGradient,
      boxShadow: AppCreateJoinRoomTokens.createButtonGlow,
      onPressed: onPressed,
    );
  }
}

class _TactileGradientButton extends StatefulWidget {
  const _TactileGradientButton({
    required this.label,
    required this.isLoading,
    required this.height,
    required this.horizontalPadding,
    required this.borderRadius,
    required this.gradient,
    required this.boxShadow,
    required this.onPressed,
    this.isExpanded = true,
  });

  final String label;
  final bool isLoading;
  final double height;
  final double horizontalPadding;
  final double borderRadius;
  final Gradient gradient;
  final List<BoxShadow> boxShadow;
  final VoidCallback onPressed;
  final bool isExpanded;

  @override
  State<_TactileGradientButton> createState() => _TactileGradientButtonState();
}

class _TactileGradientButtonState extends State<_TactileGradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final child = AnimatedScale(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      scale: _isPressed && !widget.isLoading
          ? AppCreateJoinRoomTokens.buttonPressedScale
          : 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.isLoading ? null : (_) => _setPressed(true),
        onTapCancel: widget.isLoading ? null : () => _setPressed(false),
        onTapUp: widget.isLoading ? null : (_) => _setPressed(false),
        onTap: widget.isLoading ? null : widget.onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.boxShadow,
          ),
          child: SizedBox(
            height: widget.height,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
              ),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: AppColors.primaryText,
                        ),
                      )
                    : Text(
                        widget.label,
                        style: AppTypography.button.copyWith(
                          fontSize: widget.label == 'Create a New Room'
                              ? 17
                              : 16,
                          color: AppColors.primaryText,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!widget.isExpanded) {
      return child;
    }

    return SizedBox(width: double.infinity, child: child);
  }

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() => _isPressed = value);
  }
}
