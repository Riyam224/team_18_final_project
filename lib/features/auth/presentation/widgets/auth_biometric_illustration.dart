import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 140.w,
            height: 140.h,
            colorFilter: ColorFilter.mode(
              isDark ? AppColors.textWhiteSoft : AppColors.gray2,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 117.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.authBiometricIllustrationDescription.copyWith(
              fontSize: 16.sp,
              color: isDark ? AppColors.textWhiteSoft : AppColors.darkSurface,
            ),
          ),
        ],
      ),
    );
  }
}
