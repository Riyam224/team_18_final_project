import 'package:flutter/material.dart';

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
}
