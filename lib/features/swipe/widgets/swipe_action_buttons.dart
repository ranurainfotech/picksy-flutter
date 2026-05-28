import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';

class SwipeActionButtons extends StatelessWidget {
  const SwipeActionButtons({
    super.key,
    required this.onDislike,
    required this.onMaybe,
    required this.onLike,
  });

  final VoidCallback onDislike;
  final VoidCallback onMaybe;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircleButton(
          size: 74,
          icon: Icons.close_rounded,
          iconSize: 34,
          borderColor: const Color(0xFFFF2D55),
          bg: const Color(0x14FF2D55),
          glow: const Color(0x44FF2D55),
          onTap: onDislike,
        ),
        _CircleButton(
          size: 68,
          icon: AppIcons.unsure,
          iconSize: 30,
          borderColor: const Color(0xFFFFD60A),
          bg: const Color(0x14FFD60A),
          glow: const Color(0x33FFD60A),
          onTap: onMaybe,
        ),
        GestureDetector(
          onTap: onLike,
          child: Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF7B2CFF), Color(0xFFFF4DB8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x99FF4DB8),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(AppIcons.like, size: 34, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.size,
    required this.icon,
    required this.iconSize,
    required this.borderColor,
    required this.bg,
    required this.glow,
    required this.onTap,
  });

  final double size;
  final IconData icon;
  final double iconSize;
  final Color borderColor;
  final Color bg;
  final Color glow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg,
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [BoxShadow(color: glow, blurRadius: 18)],
        ),
        child: Icon(icon, size: iconSize, color: Colors.white),
      ),
    );
  }
}
