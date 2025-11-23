import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';

/// A theme-aware splash icon widget.
///
/// Displays the app logo on the splash screen, automatically switching between
/// light and dark variants based on the current theme brightness.
/// - Shows light icon when in dark mode
/// - Shows dark icon when in light mode
class SplashIcon extends StatelessWidget {
  const SplashIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if current theme is dark mode
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Display theme-appropriate icon
    return SvgPicture.asset(
      isDark ? AppAssets.splashLightIcon : AppAssets.splashDarkIcon,
      width: 165.w,
      height: 165.h,
    );
  }
}
