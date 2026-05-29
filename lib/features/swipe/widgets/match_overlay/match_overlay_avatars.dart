import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../theme/app_match_overlay_tokens.dart';

class MatchOverlayAvatars extends StatelessWidget {
  const MatchOverlayAvatars({
    super.key,
    required this.userIds,
    this.baseDelayMs = 800,
    this.size = AppMatchOverlayTokens.avatarSize,
    this.overlap = AppMatchOverlayTokens.avatarOverlap,
  });

  final List<String> userIds;
  final int baseDelayMs;
  final double size;
  final double overlap;

  static const _avatarAssets = <String>[
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
    'assets/avatars/avatar5.png',
    'assets/avatars/avatar6.png',
  ];

  @override
  Widget build(BuildContext context) {
    final visible = userIds.take(6).toList(growable: false);
    if (visible.isEmpty) {
      return const SizedBox.shrink();
    }

    final width = size + ((visible.length - 1) * (size - overlap));

    return SizedBox(
      width: width,
      height: size + 8,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final (index, userId) in visible.indexed)
            Positioned(
              left: index * (size - overlap),
              child: _AvatarBubble(
                assetPath: _assetForUser(userId),
                delayMs: baseDelayMs + (index * 180),
                size: size,
              ),
            ),
        ],
      ),
    );
  }

  static String _assetForUser(String userId) {
    return _avatarAssets[userId.hashCode.abs() % _avatarAssets.length];
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({
    required this.assetPath,
    required this.delayMs,
    required this.size,
  });

  final String assetPath;
  final int delayMs;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPink.withValues(alpha: 0.55),
            blurRadius: 14,
            spreadRadius: -2,
          ),
        ],
        gradient: const LinearGradient(
          colors: [AppColors.neonPink, AppColors.softPurple],
        ),
      ),
      child: ClipOval(
        child: Image.asset(assetPath, fit: BoxFit.cover),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          delay: delayMs.ms,
          duration: AppMatchOverlayTokens.avatarPopDuration,
          curve: Curves.elasticOut,
        )
        .fadeIn(delay: delayMs.ms, duration: 120.ms);
  }
}
