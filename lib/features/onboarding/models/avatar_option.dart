class AvatarOption {
  const AvatarOption({
    required this.id,
    required this.assetPath,
    required this.label,
    required this.gradientIndex,
  });

  final String id;
  final String assetPath;
  final String label;
  final int gradientIndex;
}

abstract final class AvatarOptions {
  static const all = [
    AvatarOption(
      id: 'film_friend',
      assetPath: 'assets/avatars/avatar1.png',
      label: 'Film Friend',
      gradientIndex: 0,
    ),
    AvatarOption(
      id: 'night_pick',
      assetPath: 'assets/avatars/avatar2.png',
      label: 'Night Pick',
      gradientIndex: 1,
    ),
    AvatarOption(
      id: 'cool_critic',
      assetPath: 'assets/avatars/avatar3.png',
      label: 'Cool Critic',
      gradientIndex: 2,
    ),
    AvatarOption(
      id: 'food_hunter',
      assetPath: 'assets/avatars/avatar4.png',
      label: 'Food Hunter',
      gradientIndex: 3,
    ),
    AvatarOption(
      id: 'vibe_planner',
      assetPath: 'assets/avatars/avatar5.png',
      label: 'Vibe Planner',
      gradientIndex: 4,
    ),
    AvatarOption(
      id: 'party_scout',
      assetPath: 'assets/avatars/avatar6.png',
      label: 'Party Scout',
      gradientIndex: 5,
    ),
  ];
}
