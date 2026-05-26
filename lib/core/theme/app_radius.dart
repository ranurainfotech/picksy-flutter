import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double small = 10;
  static const double medium = 16;
  static const double button = 18;
  static const double large = 22;
  static const double xl = 28;
  static const double full = 999;

  static BorderRadius get smallBorder => BorderRadius.circular(small);
  static BorderRadius get mediumBorder => BorderRadius.circular(medium);
  static BorderRadius get buttonBorder => BorderRadius.circular(button);
  static BorderRadius get largeBorder => BorderRadius.circular(large);
  static BorderRadius get xlBorder => BorderRadius.circular(xl);
  static BorderRadius get fullBorder => BorderRadius.circular(full);
}
