import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_design_system.dart';
import '../models/avatar_option.dart';

class AvatarChoiceGrid extends StatelessWidget {
  const AvatarChoiceGrid({
    super.key,
    required this.options,
    required this.selectedAvatarId,
    required this.onAvatarSelected,
  });

  final List<AvatarOption> options;
  final String selectedAvatarId;
  final ValueChanged<String> onAvatarSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: AppOnboardingTokens.avatarGridColumns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppOnboardingTokens.avatarGridSpacing,
      crossAxisSpacing: AppOnboardingTokens.avatarGridSpacing,
      childAspectRatio: 1,
      children: options.map((option) {
        return Center(
          child: AvatarChoiceTile(
            option: option,
            isSelected: option.id == selectedAvatarId,
            onTap: () => onAvatarSelected(option.id),
          ),
        );
      }).toList(),
    );
  }
}

class AvatarChoiceTile extends StatelessWidget {
  const AvatarChoiceTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final AvatarOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradient =
        AppOnboardingTokens.avatarGradients[option.gradientIndex %
            AppOnboardingTokens.avatarGradients.length];

    return Semantics(
      button: true,
      selected: isSelected,
      label: option.label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          duration: 180.ms,
          curve: Curves.easeOutBack,
          scale: isSelected
              ? AppOnboardingTokens.avatarSelectedScale
              : AppOnboardingTokens.avatarUnselectedScale,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: gradient,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.neonPink
                        : AppColors.primaryBorder,
                    width: isSelected
                        ? AppOnboardingTokens.avatarSelectedBorderWidth
                        : AppOnboardingTokens.avatarBorderWidth,
                  ),
                  boxShadow: isSelected
                      ? AppShadows.neonPinkGlow
                      : AppShadows.elevated,
                ),
                child: SizedBox.square(
                  dimension: AppOnboardingTokens.avatarSize,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      AppOnboardingTokens.avatarImagePadding,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        option.assetPath,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  top: AppOnboardingTokens.avatarCrownOffset,
                  right: AppOnboardingTokens.avatarCrownOffset,
                  child: Text(
                    '♛',
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppColors.neonPink,
                      fontSize: AppOnboardingTokens.avatarCrownSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
