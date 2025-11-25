// app_spacing.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AppSpacing – spacing, padding, margin, SizedBox helpers only
class AppSpacing {
  // ========= SIZEDBOX FACTORY =========

  static SizedBox horizontal(double horizontal) =>
      SizedBox(width: horizontal.w);

  static SizedBox vertical(double vertical) => SizedBox(height: vertical.h);

  // ========= PADDING HELPERS =========

  static EdgeInsets horizontalPadding(double horizontal) =>
      EdgeInsets.symmetric(horizontal: horizontal.w);

  static EdgeInsets verticalPadding(double vertical) =>
      EdgeInsets.symmetric(vertical: vertical.h);

  static EdgeInsets allPadding(double value) => EdgeInsets.all(value.w);

  static EdgeInsets symmetricPadding({
    required double horizontal,
    required double vertical,
  }) =>
      EdgeInsets.symmetric(
        horizontal: horizontal.w,
        vertical: vertical.h,
      );

  static EdgeInsets customPadding({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) =>
      EdgeInsets.only(
        left: (left ?? 0).w,
        top: (top ?? 0).h,
        right: (right ?? 0).w,
        bottom: (bottom ?? 0).h,
      );

  // ========= COMMON SIZEDBOX PRESETS =========

  static SizedBox get vSpaceXSmall => vertical(8);
  static SizedBox get vSpace12 => vertical(12);
  static SizedBox get vSpace16 => vertical(16);
  static SizedBox get vSpace20 => vertical(20);
  static SizedBox get vSpace24 => vertical(24);
  static SizedBox get vSpace30 => vertical(30);
  static SizedBox get vSpace40 => vertical(40);
  static SizedBox get vSpace50 => vertical(50);
  static SizedBox get vSpace70 => vertical(70);
  static SizedBox get vSpace88 => vertical(88);
  static SizedBox get vSpace100 => vertical(100);

  static SizedBox get hSpaceXSmall => horizontal(8);
  static SizedBox get hSpace16 => horizontal(16);
  static SizedBox get hSpace20 => horizontal(20);
  static SizedBox get hSpace48 => horizontal(48);

  // ========= COMMON PADDING PRESETS =========

  static EdgeInsets get paddingH16 => horizontalPadding(16);
  static EdgeInsets get paddingH20 => horizontalPadding(20);
  static EdgeInsets get paddingH24 => horizontalPadding(24);
  static EdgeInsets get paddingH40 => horizontalPadding(40);

  static EdgeInsets get paddingV16 => verticalPadding(16);

  static EdgeInsets get paddingAll20 => allPadding(20);
  static EdgeInsets get paddingAll16 => allPadding(16);

  static EdgeInsets get screenPaddingH => horizontalPadding(20);
  static EdgeInsets get screenPaddingH16 => horizontalPadding(16);

  static EdgeInsets get buttonPadding => horizontalPadding(20);
  static EdgeInsets get textFieldPadding => horizontalPadding(20);
}
