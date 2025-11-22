import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundImage: const AssetImage("assets/images/profile.png"),
              backgroundColor: isDark ? AppColors.darkCard : AppColors.gray5,
            ),
            SizedBox(width: 12.w),
            Text("Hi, riyam 👋",
                style: AppTextStyles.headlineMedium.copyWith(
                  color: isDark ? AppColors.textWhite : AppColors.textBlack,
                ))
          ],
        ),
        Icon(
          Icons.notifications_none,
          size: 26.sp,
          color: isDark ? AppColors.textWhite : AppColors.textGray,
        ),
      ],
    );
  }
}
