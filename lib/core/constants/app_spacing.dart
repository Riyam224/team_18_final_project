import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  static SizedBox horizontal(double horizontal, {Widget? child}) =>
      SizedBox(width: horizontal.w, child: child);
  static SizedBox vertical(double vertical, {Widget? child}) => SizedBox(
        height: vertical.h,
        child: child,
      );
}
