import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    color: AppColors.white,
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    color: AppColors.white70,
    fontSize: 15,
  );

  static const TextStyle label = TextStyle(
    color: AppColors.white70,
    fontSize: 13,
  );

  static const TextStyle button = TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle link = TextStyle(
    color: Colors.redAccent,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle normalWhite = TextStyle(color: AppColors.white);
}
