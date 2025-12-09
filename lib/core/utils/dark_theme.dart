import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'app_colors.dart';

ThemeData buildDarkTheme() {
  final base = ThemeData.dark();

  return base.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground2,
    primaryColor: AppColors.primary,
    cardColor: const Color(0xFF0D0D0D), // #0D0D0D
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.textWhite,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge:
          AppTextStyles.displayLarge.copyWith(color: AppColors.textWhite),
      displayMedium:
          AppTextStyles.displayMedium.copyWith(color: AppColors.textWhite),
      headlineLarge:
          AppTextStyles.headlineLarge.copyWith(color: AppColors.textWhite),
      headlineMedium:
          AppTextStyles.headlineMedium.copyWith(color: AppColors.textWhite),
      headlineSmall:
          AppTextStyles.headlineSmall.copyWith(color: AppColors.textWhite),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.textWhite),
      titleMedium:
          AppTextStyles.titleMedium.copyWith(color: AppColors.textWhite),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.textWhite),
      bodyLarge:
          AppTextStyles.bodyLarge.copyWith(color: AppColors.textWhiteSoft),
      bodyMedium:
          AppTextStyles.bodyMedium.copyWith(color: AppColors.textWhiteSoft),
      bodySmall:
          AppTextStyles.bodySmall.copyWith(color: AppColors.textGrayDark),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textWhite),
      labelMedium:
          AppTextStyles.labelMedium.copyWith(color: AppColors.textWhite),
      labelSmall:
          AppTextStyles.labelSmall.copyWith(color: AppColors.textGrayDark),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground2,
      elevation: 0,
      foregroundColor: AppColors.textWhite,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textWhite,
      ),
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
