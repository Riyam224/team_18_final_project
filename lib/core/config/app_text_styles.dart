import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';

class AppTextStyles {
  // ========= DISPLAY (big numbers, portfolio balance) =========
  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  // ========= HEADLINES (screen titles) =========
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // ========= TITLES (section titles) =========
  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
  );

  // ========= BODY =========
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 12,
    fontWeight: FontWeight.w300, // Light
  );

  // ========= LABELS (buttons, chips, tabs) =========
  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 10,
    fontWeight: FontWeight.w300, // Light
  );

  // ========= SPECIAL (price up/down) =========
  static const TextStyle priceUp = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Color(0xFF00CB6A), // GREEN - Always same
  );

  static const TextStyle priceDown = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Color(0xFFF26666), // RED - Always same
  );
}
