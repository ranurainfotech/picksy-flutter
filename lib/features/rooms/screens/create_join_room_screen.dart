import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_design_system.dart';
import '../../../routes/app_routes.dart';
import '../providers/create_join_room_provider.dart';
import '../theme/app_create_join_room_tokens.dart';
import '../widgets/room_code_input_section.dart';

class CreateJoinRoomScreen extends ConsumerStatefulWidget {
  const CreateJoinRoomScreen({super.key});

  @override
  ConsumerState<CreateJoinRoomScreen> createState() =>
      _CreateJoinRoomScreenState();
}

class _CreateJoinRoomScreenState extends ConsumerState<CreateJoinRoomScreen> {
  late final TextEditingController _roomCodeController;

  @override
  void initState() {
    super.initState();
    _roomCodeController = TextEditingController(
      text: ref.read(createJoinRoomProvider).roomCode,
    )..addListener(_syncRoomCode);
  }

  @override
  void dispose() {
    _roomCodeController
      ..removeListener(_syncRoomCode)
      ..dispose();
    super.dispose();
  }

  void _syncRoomCode() {
    ref
        .read(createJoinRoomProvider.notifier)
        .updateRoomCode(_roomCodeController.text);
  }

  @override
  Widget build(BuildContext context) {
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
                0,
                AppCreateJoinRoomTokens.horizontalPadding,
                AppSpacing.section,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _CreateJoinBackButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                          return;
                        }

                        context.go(AppRoutes.home);
                      },
                    ),
                  ).animate().fadeIn(duration: 220.ms).slideX(begin: -0.08),
                  const SizedBox(height: AppSpacing.regular),
                  Text(
                    'What are\nwe deciding?',
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.primaryText,
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
                  Spacer(),
                  const SizedBox(
                    height: AppCreateJoinRoomTokens.joinSectionTopGap,
                  ),
                  RoomCodeInputSection(
                        controller: _roomCodeController,
                        isLoading: isLoading,
                        onJoin: () async {
                          final roomId = await actionNotifier.joinRoom();

                          if (!context.mounted || roomId == null) {
                            return;
                          }

                          context.go(AppRoutes.roomLobby(roomId));
                        },
                      )
                      .animate()
                      .fadeIn(delay: 260.ms, duration: 280.ms)
                      .slideY(begin: 0.12, curve: Curves.easeOutCubic),
                  if (errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      errorMessage,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.reject,
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: AppCreateJoinRoomTokens.dividerVerticalMargin,
                  ),
                  const _OrDivider().animate().fadeIn(
                    delay: 340.ms,
                    duration: 260.ms,
                  ),
                  const SizedBox(
                    height: AppCreateJoinRoomTokens.dividerVerticalMargin,
                  ),
                  _CreateRoomButton(
                        isLoading: isLoading,
                        onPressed: () {
                          context.push(
                            AppRoutes.roomSetup,
                            extra: roomState.selectedCategory,
                          );
                        },
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 300.ms)
                      .slideY(begin: 0.14, curve: Curves.easeOutCubic),
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

class _CreateJoinBackButton extends StatelessWidget {
  const _CreateJoinBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.elevatedCard.withValues(alpha: 0.72),
          borderRadius: AppRadius.mediumBorder,
          border: Border.all(color: AppColors.primaryBorder),
          boxShadow: AppShadows.elevated,
        ),
        child: const SizedBox(
          width: AppSpacing.hero,
          height: AppSpacing.hero,
          child: Icon(
            AppIcons.chevronLeft,
            color: AppColors.primaryText,
            size: AppSpacing.icon,
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
      return const SizedBox(
        width: AppCreateJoinRoomTokens.selectionIndicatorSize,
        height: AppCreateJoinRoomTokens.selectionIndicatorSize,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryText,
        shape: BoxShape.circle,
        boxShadow: AppCreateJoinRoomTokens.buttonPurpleGlow,
      ),
      child: const SizedBox(
        width: AppCreateJoinRoomTokens.selectionIndicatorSize,
        height: AppCreateJoinRoomTokens.selectionIndicatorSize,
        child: Icon(
          Icons.check_rounded,
          color: AppColors.like,
          size: AppCreateJoinRoomTokens.selectionCheckSize,
        ),
      ),
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
    return AppButton.primary(
      label: 'Create a New Room',
      onPressed: isLoading ? null : onPressed,
    );
  }
}
