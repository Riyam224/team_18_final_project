import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'app_colors.dart';

ThemeData buildDarkTheme() {
  final base = ThemeData.dark();

  return base.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground2,
    primaryColor: AppColors.primary,
    cardColor: AppColors.darkCard,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      onBackground: AppColors.textWhite,
      onSurface: AppColors.textWhite,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
      headlineMedium:
          AppTextStyles.headlineMedium.copyWith(color: Colors.white),
      titleMedium:
          AppTextStyles.titleMedium.copyWith(color: AppColors.textWhiteSoft),
      bodySmall:
          AppTextStyles.bodySmall.copyWith(color: AppColors.textGrayDark),
      bodyMedium:
          AppTextStyles.bodyMedium.copyWith(color: AppColors.textWhiteSoft),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground2,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textWhiteSoft,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0D0D0D),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textGrayDark,
    ),
  );
}
