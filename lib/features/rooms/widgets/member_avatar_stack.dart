import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../theme/app_rooms_tokens.dart';

class MemberAvatarStack extends StatelessWidget {
  const MemberAvatarStack({
    super.key,
    required this.assetPaths,
    this.maxVisible = 3,
  });

  final List<String> assetPaths;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final visibleAvatars = assetPaths.take(maxVisible).toList(growable: false);
    final width =
        AppRoomsTokens.avatarSize +
        ((visibleAvatars.length - 1) * AppRoomsTokens.avatarOverlap);

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
        ],
      ),
    );
  }
}
