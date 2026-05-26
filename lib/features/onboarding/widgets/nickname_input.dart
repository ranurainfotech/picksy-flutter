import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';
import '../theme/app_onboarding_tokens.dart';

class NicknameInput extends StatelessWidget {
  const NicknameInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      cursorColor: AppColors.neonPink,
      style: AppTypography.bodyRegular,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        suffixIcon: const Icon(
          Icons.check_circle,
          color: AppColors.like,
          size: AppOnboardingTokens.inputSuffixIconSize,
        ),
        border: _border(AppColors.primaryBorder),
        enabledBorder: _border(AppColors.primaryBorder),
        focusedBorder: _border(AppColors.activeBorder),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppOnboardingTokens.inputRadius),
      borderSide: BorderSide(color: color),
    );
  }
}
