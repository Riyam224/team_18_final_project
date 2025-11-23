import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

/// A page indicator widget for the onboarding screens.
///
/// Displays a row of animated dots representing each page, with the current
/// page highlighted by a longer, differently-colored indicator.
/// Automatically adapts colors based on the current theme (light/dark).
class OnboardingIndicator extends StatelessWidget {
  /// Total number of pages to display indicators for
  final int count;

  /// Index of the currently active page (0-based)
  final int currentPage;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Theme-aware indicator colors
    // Active: prominent color, Inactive: subtle gray
    final activeColor = isDarkMode ? AppColors.textWhiteSoft : AppColors.primary;
    final inactiveColor = isDarkMode ? AppColors.gray2 : AppColors.gray4;

    return Row(
      children: List.generate(count, (index) {
        final isActive = index == currentPage;
        // Animated container that smoothly transitions between active/inactive states
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.only(right: 8.w),
          height: 6.h,
          // Active indicator is wider (24w) than inactive (12w)
          width: isActive ? 24.w : 12.w,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
        );
      }),
    );
  }
}
