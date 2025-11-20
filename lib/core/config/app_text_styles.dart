import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AppTextStyles {
  // ========= DISPLAY (big numbers, portfolio balance) =========
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Lato',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Lato',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  // ========= HEADLINES (screen titles) =========
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Lato',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Lato',
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textBlack,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textBlack,
  );

  // ========= TITLES (section titles) =========
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textBlack,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textBlack,
  );

  // ========= BODY =========
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Lato',
    fontSize: 12,
    fontWeight: FontWeight.w300, // Light
    color: AppColors.textGraySecondary,
  );

  // ========= LABELS (buttons, chips, tabs) =========
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textGray,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Lato',
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textGray,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Lato',
    fontSize: 10,
    fontWeight: FontWeight.w300, // Light
    color: AppColors.textGraySecondary,
  );

  // ========= SPECIAL (price up/down) =========
  static const TextStyle priceUp = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.priceUp,
  );

  static const TextStyle priceDown = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.priceDown,
  );
}
