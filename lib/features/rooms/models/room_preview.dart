import 'package:flutter/material.dart';

import '../../../core/theme/app_design_system.dart';

class RoomPreview {
  const RoomPreview({
    required this.id,
    required this.title,
    required this.category,
    required this.emoji,
    required this.membersCount,
    required this.posterIcon,
    required this.posterColors,
    required this.avatarAssetPaths,
  });

  final String id;
  final String title;
  final String category;
  final String emoji;
  final int membersCount;
  final IconData posterIcon;
  final List<Color> posterColors;
  final List<String> avatarAssetPaths;

  factory RoomPreview.fromRoomData({required String roomId, required Map<String, dynamic> data}) {
    final categoryId = (data['category'] as String? ?? data['type'] as String? ?? 'movies')
        .toLowerCase();
    final membersCount = data['memberCount'] as int? ??
        (data['members'] is List ? (data['members'] as List).length : 1);
    final title = data['name'] as String? ?? '${roomId.toUpperCase()} Room';

    return RoomPreview(
      id: roomId.toUpperCase(),
      title: title,
      category: categoryLabel(categoryId),
      emoji: categoryEmoji(categoryId),
      membersCount: membersCount,
      posterIcon: categoryIcon(categoryId),
      posterColors: categoryColors(categoryId),
      avatarAssetPaths: const [
        'assets/avatars/avatar1.png',
        'assets/avatars/avatar2.png',
        'assets/avatars/avatar3.png',
      ],
    );
  }

  static String categoryLabel(String type) {
    return switch (type) {
      'restaurants' => 'Restaurants',
      'activities' => 'Activities',
      _ => 'Movies',
    };
  }

  static String categoryEmoji(String type) {
    return switch (type) {
      'restaurants' => '🍔',
      'activities' => '🎉',
      _ => '🍿',
    };
  }

  static IconData categoryIcon(String type) {
    return switch (type) {
      'restaurants' => AppIcons.restaurants,
      'activities' => AppIcons.activities,
      _ => AppIcons.movies,
    };
  }

  static List<Color> categoryColors(String type) {
    return switch (type) {
      'restaurants' => const [Color(0xFF12375A), Color(0xFFFF7A00), Color(0xFF0D1320)],
      'activities' => const [Color(0xFF144B69), Color(0xFFFFD60A), Color(0xFF101421)],
      _ => const [Color(0xFF5B1B7A), Color(0xFFEF2D7C), Color(0xFF101423)],
    };
  }
}
