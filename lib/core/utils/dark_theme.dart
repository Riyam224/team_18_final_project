import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

import '../config/app_text_styles.dart';

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primary,
    fontFamily: 'Lato',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      foregroundColor: AppColors.textWhite,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headlineMedium,
    ),
    cardColor: AppColors.darkCard,
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
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkBackground,
    ),
  );
}
