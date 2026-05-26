import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  static const List<BoxShadow> neonPinkGlow = [
    BoxShadow(color: AppColors.pinkGlow, blurRadius: 24, spreadRadius: 0),
  ];

  static const List<BoxShadow> purpleGlow = [
    BoxShadow(color: AppColors.purpleGlow, blurRadius: 24, spreadRadius: 0),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(color: AppColors.black35, blurRadius: 20, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> rejectGlow = [
    BoxShadow(color: Color(0x59FF2D55), blurRadius: 22),
  ];

  static const List<BoxShadow> likeGlow = [
    BoxShadow(color: Color(0x59C026FF), blurRadius: 22),
  ];
}
