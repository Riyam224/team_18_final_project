import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AppSpacing - all padding, margin, and gap values used throughout the app
class AppSpacing {
  // ========= PADDING - ALL SIDES =========

  static EdgeInsets get paddingAll4 => EdgeInsets.all(4.w);
  static EdgeInsets get paddingAll8 => EdgeInsets.all(8.w);
  static EdgeInsets get paddingAll12 => EdgeInsets.all(12.w);
  static EdgeInsets get paddingAll16 => EdgeInsets.all(16.w);
  static EdgeInsets get paddingAll20 => EdgeInsets.all(20.w);
  static EdgeInsets get paddingAll24 => EdgeInsets.all(24.w);

  // ========= PADDING - HORIZONTAL =========

  static EdgeInsets get paddingH8 => EdgeInsets.symmetric(horizontal: 8.w);
  static EdgeInsets get paddingH10 => EdgeInsets.symmetric(horizontal: 10.w);
  static EdgeInsets get paddingH12 => EdgeInsets.symmetric(horizontal: 12.w);
  static EdgeInsets get paddingH16 => EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets get paddingH20 => EdgeInsets.symmetric(horizontal: 20.w);
  static EdgeInsets get paddingH24 => EdgeInsets.symmetric(horizontal: 24.w);
  static EdgeInsets get paddingH28 => EdgeInsets.symmetric(horizontal: 28.w);
  static EdgeInsets get paddingH40 => EdgeInsets.symmetric(horizontal: 40.w);

  // ========= PADDING - VERTICAL =========

  static EdgeInsets get paddingV4 => EdgeInsets.symmetric(vertical: 4.h);
  static EdgeInsets get paddingV8 => EdgeInsets.symmetric(vertical: 8.h);
  static EdgeInsets get paddingV10 => EdgeInsets.symmetric(vertical: 10.h);
  static EdgeInsets get paddingV12 => EdgeInsets.symmetric(vertical: 12.h);
  static EdgeInsets get paddingV16 => EdgeInsets.symmetric(vertical: 16.h);
  static EdgeInsets get paddingV20 => EdgeInsets.symmetric(vertical: 20.h);

  // ========= PADDING - COMBINED HORIZONTAL & VERTICAL =========

  static EdgeInsets paddingHV({
    required double horizontal,
    required double vertical,
  }) =>
      EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h);

  static EdgeInsets symmetricPadding({
    required double horizontal,
    required double vertical,
  }) =>
      EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h);

  static EdgeInsets get paddingH12V12 =>
      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h);
  static EdgeInsets get paddingH16V8 =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
  static EdgeInsets get paddingH24V12 =>
      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);
  static EdgeInsets get paddingH10V4 =>
      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h);
  static EdgeInsets get paddingH12V6 =>
      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h);
  static EdgeInsets get paddingH16V14 =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h);
  static EdgeInsets get paddingH24V24 =>
      EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h);

  // ========= PADDING - CUSTOM SIDES =========

  static EdgeInsets paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(
        left: left.w,
        top: top.h,
        right: right.w,
        bottom: bottom.h,
      );

  static EdgeInsets get paddingL28R24 =>
      EdgeInsets.only(left: 28.w, right: 24.w);
  static EdgeInsets get paddingR20T10 =>
      EdgeInsets.only(right: 20.w, top: 10.h);

  // ========= MARGIN - ALL SIDES =========

  static EdgeInsets get marginAll4 => EdgeInsets.all(4.w);
  static EdgeInsets get marginAll8 => EdgeInsets.all(8.w);
  static EdgeInsets get marginAll12 => EdgeInsets.all(12.w);
  static EdgeInsets get marginAll16 => EdgeInsets.all(16.w);
  static EdgeInsets get marginAll20 => EdgeInsets.all(20.w);
  static EdgeInsets get marginAll24 => EdgeInsets.all(24.w);

  // ========= MARGIN - HORIZONTAL =========

  static EdgeInsets get marginH8 => EdgeInsets.symmetric(horizontal: 8.w);
  static EdgeInsets get marginH12 => EdgeInsets.symmetric(horizontal: 12.w);
  static EdgeInsets get marginH16 => EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets get marginH20 => EdgeInsets.symmetric(horizontal: 20.w);
  static EdgeInsets get marginH24 => EdgeInsets.symmetric(horizontal: 24.w);

  // ========= MARGIN - VERTICAL =========

  static EdgeInsets get marginV4 => EdgeInsets.symmetric(vertical: 4.h);
  static EdgeInsets get marginV8 => EdgeInsets.symmetric(vertical: 8.h);
  static EdgeInsets get marginV12 => EdgeInsets.symmetric(vertical: 12.h);
  static EdgeInsets get marginV16 => EdgeInsets.symmetric(vertical: 16.h);
  static EdgeInsets get marginV20 => EdgeInsets.symmetric(vertical: 20.h);

  // ========= MARGIN - CUSTOM SIDES =========

  static EdgeInsets marginOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(
        left: left.w,
        top: top.h,
        right: right.w,
        bottom: bottom.h,
      );

  static EdgeInsets get marginR8 => EdgeInsets.only(right: 8.w);

  // ========= VERTICAL GAPS (SizedBox heights) =========

  static SizedBox get gapH2 => SizedBox(height: 2.h);
  static SizedBox get gapH4 => SizedBox(height: 4.h);
  static SizedBox get gapH8 => SizedBox(height: 8.h);
  static SizedBox get gapH12 => SizedBox(height: 12.h);
  static SizedBox get gapH16 => SizedBox(height: 16.h);
  static SizedBox get gapH20 => SizedBox(height: 20.h);
  static SizedBox get gapH24 => SizedBox(height: 24.h);
  static SizedBox get gapH28 => SizedBox(height: 28.h);
  static SizedBox get gapH30 => SizedBox(height: 30.h);
  static SizedBox get gapH32 => SizedBox(height: 32.h);
  static SizedBox get gapH40 => SizedBox(height: 40.h);
  static SizedBox get gapH50 => SizedBox(height: 50.h);
  static SizedBox get gapH53 => SizedBox(height: 53.19.h);
  static SizedBox get gapH58 => SizedBox(height: 58.h);
  static SizedBox get gapH59 => SizedBox(height: 59.h);
  static SizedBox get gapH70 => SizedBox(height: 70.h);
  static SizedBox get gapH88 => SizedBox(height: 88.h);
  static SizedBox get gapH100 => SizedBox(height: 100.h);

  // ========= HORIZONTAL GAPS (SizedBox widths) =========

  static SizedBox get gapW4 => SizedBox(width: 4.w);
  static SizedBox get gapW8 => SizedBox(width: 8.w);
  static SizedBox get gapW12 => SizedBox(width: 12.w);
  static SizedBox get gapW16 => SizedBox(width: 16.w);
  static SizedBox get gapW20 => SizedBox(width: 20.w);
  static SizedBox get gapW24 => SizedBox(width: 24.w);
  static SizedBox get gapW48 => SizedBox(width: 48.w);

  // ========= GRID SPACING =========

  static double get gridCrossSpacing => 12.w;
  static double get gridMainSpacing => 12.h;
  static double get gridMainExtent => 110.h;

  // ========= CUSTOM GAPS =========

  static SizedBox customGapH(double height) => SizedBox(height: height.h);
  static SizedBox customGapW(double width) => SizedBox(width: width.w);

  // ========= HELPER METHODS (Factory methods) =========

  static SizedBox horizontal(double horizontal) => SizedBox(width: horizontal.w);
  static SizedBox vertical(double vertical) => SizedBox(height: vertical.h);

  static EdgeInsets horizontalPadding(double horizontal) =>
      EdgeInsets.symmetric(horizontal: horizontal.w);

  static EdgeInsets verticalPadding(double vertical) =>
      EdgeInsets.symmetric(vertical: vertical.h);

  static EdgeInsets allPadding(double value) => EdgeInsets.all(value.w);

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

  // ========= LEGACY ALIASES (for backward compatibility) =========

  static SizedBox get vSpaceXSmall => gapH8;
  static SizedBox get vSpace12 => gapH12;
  static SizedBox get vSpace16 => gapH16;
  static SizedBox get vSpace20 => gapH20;
  static SizedBox get vSpace24 => gapH24;
  static SizedBox get vSpace30 => gapH30;
  static SizedBox get vSpace40 => gapH40;
  static SizedBox get vSpace50 => gapH50;
  static SizedBox get vSpace70 => gapH70;
  static SizedBox get vSpace88 => gapH88;
  static SizedBox get vSpace100 => gapH100;

  static SizedBox get hSpaceXSmall => gapW8;
  static SizedBox get hSpace16 => gapW16;
  static SizedBox get hSpace20 => gapW20;
  static SizedBox get hSpace48 => gapW48;

  static EdgeInsets get screenPaddingH => paddingH20;
  static EdgeInsets get screenPaddingH16 => paddingH16;
  static EdgeInsets get buttonPadding => paddingH20;
  static EdgeInsets get textFieldPadding => paddingH20;
}
