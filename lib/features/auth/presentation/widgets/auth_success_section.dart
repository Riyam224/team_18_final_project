import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AuthSuccessSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthSuccessSection({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor:
              isDark ? Colors.white10 : AppColors.primary.withOpacity(.1),
          child: Icon(
            Icons.check,
            size: 45.sp,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          title,
          style: AppTextStyles.authSuccessSectionTitle.copyWith(
            fontSize: 22.sp,
            color: isDark ? AppColors.textWhite : AppColors.textDark,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.authSuccessSectionSubtitle.copyWith(
            fontSize: 16.sp,
            color: isDark ? AppColors.textWhiteSoft : AppColors.textGray,
          ),
        ),
      ],
    );
  }
}
