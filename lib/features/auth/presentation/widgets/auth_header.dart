import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 400 ? 350.w : screenWidth - 32.w,
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.authHeaderTitle.copyWith(
                fontSize: 26.sp,
                color: isDark ? AppColors.textWhite : AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 400 ? 350.w : screenWidth - 32.w,
            ),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.authHeaderSubtitle.copyWith(
                fontSize: 18.sp,
                color: isDark ? AppColors.textWhiteSoft2 : AppColors.textGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
