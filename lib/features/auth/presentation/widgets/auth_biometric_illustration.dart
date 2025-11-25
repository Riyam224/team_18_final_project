import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AuthBiometricIllustration extends StatelessWidget {
  final String iconPath;
  final String description;

  const AuthBiometricIllustration({
    super.key,
    required this.iconPath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Image.asset(
          iconPath,
          height: 100.h,
          width: 100.w,
          color: isDark ? AppColors.textWhite : AppColors.primary,
        ),
        SizedBox(height: 24.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: isDark ? AppColors.textWhiteSoft : AppColors.textGray,
          ),
        ),
      ],
    );
  }
}
