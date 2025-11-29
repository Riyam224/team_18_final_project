import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

/// Page indicator widget for onboarding screens.
class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentPage;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeColor =
        isDarkMode ? AppColors.textWhiteSoft : AppColors.primary;
    final inactiveColor = isDarkMode ? AppColors.gray2 : AppColors.gray4;

    return Row(
      children: List.generate(count, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.only(right: 8.w),
          height: 6.h,
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
