import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AppTextStyles {
  // ========= DISPLAY (big numbers, portfolio balance) =========
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Lato',
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Lato',
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  // ========= HEADLINES (screen titles) =========
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Lato',
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Lato',
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // ========= TITLES (section titles) =========
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
  );

  // ========= BODY =========
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Lato',
    fontSize: 12,
    fontWeight: FontWeight.w300, // Light
  );

  // ========= LABELS (buttons, chips, tabs) =========
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Lato',
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Lato',
    fontSize: 10,
    fontWeight: FontWeight.w300, // Light
  );

  // ========= SPECIAL (price up/down) =========
  static const TextStyle priceUp = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Color(0xFF00CB6A), // GREEN - Always same
  );

  static const TextStyle priceDown = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Color(0xFFF26666), // RED - Always same
  );


// rahma
  static const TextStyle errorLoading = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.error, 
  );


  static const TextStyle baseSmall = TextStyle(
      fontSize: 12,
  );


  static const TextStyle labelMoreLarge = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700, 
  );

  static const TextStyle headlineSmallBold = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );


  static const TextStyle titleMoreSmall = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle headlineMediumBold = TextStyle(
    fontFamily: 'Lato',
    fontSize: 20,
    fontWeight: FontWeight.w700, // SemiBold
  );


  static const TextStyle titleLargesemiBold = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

}