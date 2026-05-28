import 'package:flutter/material.dart';

class SwipeAvatarStack extends StatelessWidget {
  const SwipeAvatarStack({
    super.key,
    required this.userIds,
    required this.size,
    required this.overlap,
    this.maxVisible = 4,
  });

  final List<String> userIds;
  final double size;
  final double overlap;
  final int maxVisible;

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
    final visible = userIds.take(maxVisible).toList(growable: false);
    final width = visible.isEmpty
        ? 0.0
        : size + ((visible.length - 1) * (size - overlap));

    return SizedBox(
      width: width,
      height: size,
      child: Stack(
        children: [
          for (final (index, userId) in visible.indexed)
            Positioned(
              left: index * (size - overlap),
              child: Container(
                width: size,
                height: size,
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.75),
                    width: 1,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    _avatarAssets[userId.hashCode.abs() % _avatarAssets.length],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
