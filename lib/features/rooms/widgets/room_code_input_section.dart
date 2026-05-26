import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_design_system.dart';
import '../theme/app_create_join_room_tokens.dart';

class RoomCodeInputSection extends StatelessWidget {
  const RoomCodeInputSection({
    super.key,
    required this.controller,
    required this.onJoin,
    required this.isLoading,
  });

  final TextEditingController controller;
  final VoidCallback onJoin;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Join a room',
          style: AppTypography.caption.copyWith(
            fontSize: 16,
            color: AppColors.primaryText.withValues(alpha: 0.70),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppCreateJoinRoomTokens.joinLabelBottomGap),
        Container(
          height: AppCreateJoinRoomTokens.joinInputHeight,
          decoration: BoxDecoration(
            color: AppCreateJoinRoomTokens.inputBackground,
            borderRadius: BorderRadius.circular(AppCreateJoinRoomTokens.joinInputRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isLoading,
                  cursorColor: const Color(0xFFB026FF),
                  maxLength: 8,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                    LengthLimitingTextInputFormatter(8),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      return newValue.copyWith(
                        text: newValue.text.trim().toUpperCase(),
                        selection: newValue.selection,
                        composing: TextRange.empty,
                      );
                    }),
                  ],
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.characters,
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Enter room code',
                    hintStyle: AppTypography.bodyRegular.copyWith(
                      color: AppColors.primaryText.withValues(alpha: 0.38),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    fillColor: AppCreateJoinRoomTokens.inputBackground,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppCreateJoinRoomTokens.joinInputHorizontalPadding,
                    ),
                  ),
                ),
              ),
              _InlineJoinButton(isLoading: isLoading, onJoin: onJoin),
            ],
          ),
        ),
      ],
    );
  }
}

class _InlineJoinButton extends StatefulWidget {
  const _InlineJoinButton({required this.isLoading, required this.onJoin});

  final bool isLoading;
  final VoidCallback onJoin;

  @override
  State<_InlineJoinButton> createState() => _InlineJoinButtonState();
}

class _InlineJoinButtonState extends State<_InlineJoinButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOutCubic,
      scale: _isPressed && !widget.isLoading ? AppCreateJoinRoomTokens.joinButtonPressedScale : 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.isLoading ? null : (_) => _setPressed(true),
        onTapCancel: widget.isLoading ? null : () => _setPressed(false),
        onTapUp: widget.isLoading ? null : (_) => _setPressed(false),
        onTap: widget.isLoading ? null : widget.onJoin,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppCreateJoinRoomTokens.joinButtonGradient,
            boxShadow: [
              BoxShadow(
                color: AppCreateJoinRoomTokens.glowPurple.withValues(
                  alpha: AppCreateJoinRoomTokens.joinButtonGlowOpacity,
                ),
                blurRadius: 12,
              ),
            ],
          ),
          child: SizedBox(
            width: AppCreateJoinRoomTokens.joinButtonWidth,
            height: AppCreateJoinRoomTokens.joinInputHeight,
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
                      'Join',
                      style: AppTypography.button.copyWith(
                        color: AppColors.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() => _isPressed = value);
  }
}
