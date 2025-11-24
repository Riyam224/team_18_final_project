import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'app_colors.dart';

ThemeData buildDarkTheme() {
  final base = ThemeData.dark();

  return base.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground2,
    primaryColor: AppColors.primary,
    fontFamily: 'Lato',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground2,
      elevation: 0,
      foregroundColor: AppColors.textWhite,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headlineMedium,
    ),
    cardColor: AppColors.darkBackground,
    //  AppColors.darkCard,
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
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkBackground,

      // surfaceContainerHighest:
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textWhiteSoft,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textGrayDark,
    ),
  );
}
