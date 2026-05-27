import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../theme/app_rooms_tokens.dart';

class MemberAvatarStack extends StatelessWidget {
  const MemberAvatarStack({
    super.key,
    required this.assetPaths,
    this.maxVisible = 3,
    this.totalCount,
  });

  final List<String> assetPaths;
  final int maxVisible;
  final int? totalCount;

  @override
  Widget build(BuildContext context) {
    final effectiveTotalCount = (totalCount ?? assetPaths.length).clamp(0, 9999).toInt();
    final visibleCount = effectiveTotalCount > maxVisible ? maxVisible : effectiveTotalCount;
    final visibleAvatars = assetPaths.take(visibleCount).toList(growable: false);
    final hasOverflow = effectiveTotalCount > visibleCount;
    final width = visibleCount == 0
        ? 0.0
        : AppRoomsTokens.avatarSize +
            ((visibleAvatars.length - 1) * AppRoomsTokens.avatarOverlap) +
            (hasOverflow ? AppRoomsTokens.avatarOverlap : 0);

    return SizedBox(
      width: width,
      height: AppRoomsTokens.avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final (index, assetPath) in visibleAvatars.indexed)
            Positioned(
              left: index * AppRoomsTokens.avatarOverlap,
              child: Container(
                width: AppRoomsTokens.avatarSize,
                height: AppRoomsTokens.avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cardBackground,
                    width: AppRoomsTokens.avatarBorderWidth,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(assetPath, fit: BoxFit.cover),
                ),
              ),
            ),
          if (hasOverflow)
            Positioned(
              left: visibleAvatars.length * AppRoomsTokens.avatarOverlap,
              child: Container(
                width: AppRoomsTokens.avatarSize,
                height: AppRoomsTokens.avatarSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardBackground,
                  border: Border.all(
                    color: AppColors.primaryBorder,
                    width: AppRoomsTokens.avatarBorderWidth,
                  ),
                ),
                child: Text(
                  '+${effectiveTotalCount - visibleCount}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
