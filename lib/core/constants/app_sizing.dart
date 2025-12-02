import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AppSizing - widget sizes, heights, widths, icons, radii, shadows, positions
class AppSizing {
  // ========= HEIGHTS =========

  static double get h4 => 4.h;
  static double get h6 => 6.h;
  static double get h8 => 8.h;
  static double get h12 => 12.h;
  static double get h15 => 15.h;
  static double get h16 => 16.h;
  static double get h20 => 20.h;
  static double get h23 => 23.h;
  static double get h24 => 24.h;
  static double get h25 => 25.h;
  static double get h26 => 26.h;
  static double get h28 => 28.h;
  static double get h30 => 30.h;
  static double get h32 => 32.h;
  static double get h33 => 33.h;
  static double get h40 => 40.h;
  static double get h44 => 44.h;
  static double get h45 => 45.h;
  static double get h46 => 46.31.h;
  static double get h50 => 50.h;
  static double get h52 => 52.h;
  static double get h55 => 55.h;
  static double get h56 => 56.h;
  static double get h58 => 58.h;
  static double get h59 => 59.h;
  static double get h60 => 60.h;
  static double get h70 => 70.h;
  static double get h72 => 72.h;
  static double get h75 => 75.h;
  static double get h80 => 80.h;
  static double get h84 => 84.h;
  static double get h85 => 85.h;
  static double get h86 => 86.21.h;
  static double get h88 => 88.h;
  static double get h100 => 100.h;
  static double get h103 => 103.h;
  static double get h106 => 106.h;
  static double get h110 => 110.h;
  static double get h117 => 117.h;
  static double get h119 => 119.h;
  static double get h120 => 120.h;
  static double get h140 => 140.h;
  static double get h145 => 145.h;
  static double get h155 => 155.h;
  static double get h160 => 160.h;
  static double get h180 => 180.h;
  static double get h190 => 190.93.h;
  static double get h327 => 327.h;
  static double get h330 => 330.h;
  static double get h360 => 360.h;
  static double get h671 => 671.h;
  static double get h812 => 812.h;

  // ========= WIDTHS =========

  static double get w8 => 8.w;
  static double get w12 => 12.w;
  static double get w16 => 16.w;
  static double get w20 => 20.w;
  static double get w24 => 24.w;
  static double get w25 => 25.w;
  static double get w28 => 28.w;
  static double get w32 => 32.w;
  static double get w40 => 40.w;
  static double get w48 => 48.w;
  static double get w50 => 50.w;
  static double get w55 => 55.w;
  static double get w75 => 75.w;
  static double get w80 => 80.w;
  static double get w86 => 86.21.w;
  static double get w110 => 110.w;
  static double get w140 => 140.w;
  static double get w155 => 155.w;
  static double get w160 => 160.w;
  static double get w180 => 180.w;
  static double get w192 => 192.w;
  static double get w255 => 255.w;
  static double get w283 => 283.w;
  static double get w300 => 300.w;
  static double get w310 => 310.w;
  static double get w333 => 333.65.w;
  static double get w342 => 342.w;
  static double get w350 => 350.w;
  static double get w375 => 375.w;
  static double get w638 => 638.w;

  // ========= ICON SIZES =========

  static double get iconXSmall => 20.w;
  static double get iconSmall => 22.sp;
  static double get iconMedium => 26.sp;
  static double get iconLarge => 28.w;
  static double get iconXLarge => 32.w;

  // Biometric icons (auth feature specific)
  static double get biometricIconSmall => 45.0;
  static double get biometricIconMedium => 75.w;
  static double get biometricIconLarge => 80.w;
  static double get biometricIconXLarge => 140.w;

  // ========= BORDER RADIUS =========

  static double get radiusXSmall => 4.r;
  static double get radiusSmall => 10.r;
  static double get radius12 => 12.r;
  static double get radius16 => 16.r;
  static double get radius20 => 20.r;
  static double get radius22 => 22.r;
  static double get radiusMedium => 28.r;
  static double get radiusLarge => 30.r;
  static double get radiusXLarge => 20.r;
  static double get radiusXXLarge => 25.r;
  static double get radiusButton => 32.r;

  // ========= CONTAINER & COMPONENT SIZES =========

  static double get buttonHeight => 56.h;
  static double get buttonHeightLarge => 75.h;
  static double get textFieldHeight => 56.h;

  static double get avatarRadius => 50.r;
  static double get iconContainerSmall => 25.w;
  static double get iconContainerMedium => 50.w;

  static double get bottomNavHeight => 70.h;

  // Biometric/Auth specific sizes
  static double get faceIDContainerWidth => 155.w;
  static double get faceIDContainerHeight => 180.h;
  static double get faceIDIconContainerSize => 180.w;
  static double get successCircleSize => 110.w;

  static double get screenWidth => 375.w;
  static double get screenHeight => 812.h;

  // ========= BORDERS & DIVIDERS =========

  static double get borderThin => 1.w;
  static double get borderMedium => 1.6.w;
  static double get borderThick => 2.w;
  static double get dividerThickness => 1.h;

  // ========= SHADOWS =========

  static double get shadowBlurRadius => 2.r;
  static double get shadowOffsetY => 1.h;

  // ========= SPECIAL POSITIONS (Auth feature specific) =========

  static double get eclipseRight => -66.w;
  static double get eclipseTop => -90.h;

  static double get faceIDBoxLeft => 110.w;
  static double get faceIDBoxTop => 327.h;
  static double get faceIDBoxTopAlt => 330.h;

  static double get scanTextLeft => 55.w;
  static double get scanTextTop => 119.h;

  static double get footerTextTop => 671.h;
  static double get footerTextBottom => 120.h;

  static double get continueButtonBottom => 70.h;
}
