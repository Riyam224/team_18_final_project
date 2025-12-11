import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'app_colors.dart';

ThemeData buildLightTheme() {
  final base = ThemeData.light();

  return base.copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primary,
    cardColor: AppColors.lightSurface,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.textBlack,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    textTheme: TextTheme(
      headlineLarge:
          AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
      headlineMedium:
          AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
          
      headlineSmall: AppTextStyles.headlineSmallBold.copyWith(color: AppColors.primary),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),

      titleMedium:
          AppTextStyles.titleMedium.copyWith(color: AppColors.textBlack),
      
      
      titleSmall:
          AppTextStyles.titleSmall.copyWith(color: AppColors.lightBackground),

      bodySmall:
          AppTextStyles.bodySmall.copyWith(color: AppColors.textGraySecondary),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGray),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textBlack),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      foregroundColor: AppColors.textBlack,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textGray,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.gray3,
    ),
  );
}