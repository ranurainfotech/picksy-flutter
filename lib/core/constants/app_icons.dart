import 'package:flutter/cupertino.dart';

import '../theme/app_colors.dart';

class PicksyCategoryIcon {
  const PicksyCategoryIcon({
    required this.label,
    required this.emoji,
    required this.icon,
    required this.color,
  });

  final String label;
  final String emoji;
  final IconData icon;
  final Color color;
}

abstract final class AppIcons {
  static const IconData rooms = CupertinoIcons.person_3_fill;
  static const IconData matches = CupertinoIcons.heart_fill;
  static const IconData profile = CupertinoIcons.person_crop_circle_fill;

  static const IconData createRoom = CupertinoIcons.plus_circle_fill;
  static const IconData joinRoom = CupertinoIcons.arrow_right_circle_fill;
  static const IconData invite = CupertinoIcons.paperplane_fill;
  static const IconData roomCode = CupertinoIcons.number_circle_fill;
  static const IconData chevronRight = CupertinoIcons.chevron_right;

  static const IconData movies = CupertinoIcons.film_fill;
  static const IconData restaurants = CupertinoIcons.house_fill;
  static const IconData activities = CupertinoIcons.sparkles;
  static const IconData outings = CupertinoIcons.location_fill;

  static const IconData reject = CupertinoIcons.xmark;
  static const IconData unsure = CupertinoIcons.question;
  static const IconData like = CupertinoIcons.heart_fill;
  static const IconData favorite = CupertinoIcons.heart_circle_fill;
  static const IconData trending = CupertinoIcons.flame_fill;
  static const IconData fastAction = CupertinoIcons.bolt_fill;
  static const IconData chat = CupertinoIcons.chat_bubble_2_fill;
  static const IconData watchlist = CupertinoIcons.bookmark_fill;
  static const IconData filter = CupertinoIcons.slider_horizontal_3;

  static const Map<String, PicksyCategoryIcon> categories = {
    'movies': PicksyCategoryIcon(
      label: 'Movies',
      emoji: '🍿',
      icon: movies,
      color: AppColors.neonPink,
    ),
    'restaurants': PicksyCategoryIcon(
      label: 'Restaurants',
      emoji: '🍔',
      icon: restaurants,
      color: AppColors.neonOrange,
    ),
    'activities': PicksyCategoryIcon(
      label: 'Activities',
      emoji: '🎉',
      icon: activities,
      color: AppColors.neonYellow,
    ),
    'outings': PicksyCategoryIcon(
      label: 'Outings',
      emoji: '⚡',
      icon: outings,
      color: AppColors.cyan,
    ),
  };
}
