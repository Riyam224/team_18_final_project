import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
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
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // ========= TITLES =========
  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 14,
    fontWeight: FontWeight.w600,
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
    fontWeight: FontWeight.w300,
  );

  // ========= BUTTON LABELS =========
  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 10,
    fontWeight: FontWeight.w300,
  );

  // ========= PRICE COLORS =========
  static const TextStyle priceUp = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Color(0xFF00CB6A),
  );

  static const TextStyle priceDown = TextStyle(
    fontFamily: AppStrings.appFontNameLato,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Color(0xFFF26666),
  );

  // ------------------------------------------------------
//               ONBOARDING
// ------------------------------------------------------
  static const TextStyle onboardingTitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle onboardingBody = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // ========= AUTH SCREENS =========
  static const TextStyle authTitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle authSubtitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle authButton = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle authFooter = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle authFooterLink = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle authFooterQuestion = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.47,
  );

  static const TextStyle authFooterAction = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.47,
  );

  static const TextStyle authSuccessTitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle authSuccessSubtitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Auth - Biometric Setup Screens (Face ID / Fingerprint)
  static const TextStyle authBiometricTitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle authBiometricDescription = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  static const TextStyle authBiometricLabel = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // Auth - Biometric Scanning Screens (Face ID / Fingerprint scanning)
  static const TextStyle authBiometricScanInstruction = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.40,
  );

  static const TextStyle authBiometricIconLabel = TextStyle(
    fontFamily: 'Lato',
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  // Auth - Biometric Success Screen Title
  static const TextStyle authBiometricSuccessTitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );

  // Auth - Biometric Illustration Description
  static const TextStyle authBiometricIllustrationDescription = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  // Auth - Success Section Title (for success widgets)
  static const TextStyle authSuccessSectionTitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  // Auth - Success Section Subtitle (for success widgets)
  static const TextStyle authSuccessSectionSubtitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // Auth - Header Title (26sp)
  static const TextStyle authHeaderTitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );

  // Auth - Header Subtitle (18sp)
  static const TextStyle authHeaderSubtitle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  // Auth - Text Field Input Style
  static const TextStyle authTextFieldInput = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Auth - Text Field Hint Style
  static const TextStyle authTextFieldHint = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    fontWeight: FontWeight.w400,
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