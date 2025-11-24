import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return Column(
      children: [
        SizedBox(
          width: 316.w,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
            ).copyWith(
              color: isDark ? AppColors.textWhite : AppColors.primary,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: 316.w,
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ).copyWith(
              color: isDark
                  ? AppColors.textWhiteSoft2
                  : AppColors.textGray,
            ),
          ),
        ),
      ],
    );
  }
}
