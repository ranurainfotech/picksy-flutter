import '../../../core/theme/app_design_system.dart';
import 'avatar_option.dart';

class OnboardingProfileState {
  const OnboardingProfileState({
    required this.nickname,
    required this.selectedAvatarId,
  });

  factory OnboardingProfileState.initial() {
    return OnboardingProfileState(
      nickname: AppOnboardingTokens.defaultNickname,
      selectedAvatarId: AvatarOptions.all[1].id,
    );
  }

  final String nickname;
  final String selectedAvatarId;

  OnboardingProfileState copyWith({
    String? nickname,
    String? selectedAvatarId,
  }) {
    return OnboardingProfileState(
      nickname: nickname ?? this.nickname,
      selectedAvatarId: selectedAvatarId ?? this.selectedAvatarId,
    );
  }
}
