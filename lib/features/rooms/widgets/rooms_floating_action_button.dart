import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../theme/app_rooms_tokens.dart';

class RoomsFloatingActionButton extends StatelessWidget {
  const RoomsFloatingActionButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppRoomsTokens.createRoomGradient,
          shape: BoxShape.circle,
          boxShadow: AppRoomsTokens.createButtonShadow,
        ),
        child: const SizedBox(
          width: AppRoomsTokens.createButtonSize,
          height: AppRoomsTokens.createButtonSize,
          child: Icon(
            AppIcons.plus,
            color: AppColors.primaryText,
            size: AppRoomsTokens.createButtonIconSize - 2,
          ),
        ),
      ),
    );
  }
}
