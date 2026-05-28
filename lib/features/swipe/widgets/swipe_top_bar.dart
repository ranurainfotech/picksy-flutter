import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import 'swipe_avatar_stack.dart';

class SwipeTopBar extends StatelessWidget {
  const SwipeTopBar({
    super.key,
    required this.roomName,
    required this.memberIds,
  });

  final String roomName;
  final List<String> memberIds;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            roomName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppTypography.primaryFont,
              fontFamilyFallback: AppTypography.fallbackFonts,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          SwipeAvatarStack(
            userIds: memberIds,
            size: 22,
            overlap: 6,
            maxVisible: 5,
          ),
        ],
      ),
    );
  }
}
