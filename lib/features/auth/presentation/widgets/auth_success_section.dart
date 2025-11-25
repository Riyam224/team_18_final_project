import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
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
          radius: AppSizing.avatarRadius,
          backgroundColor:
              isDark ? Colors.white10 : AppColors.primary.withValues(alpha: 0.1),
          child: Icon(
            Icons.check,
            size: AppSizing.iconLarge,
            color: AppColors.primary,
          ),
        ),
        AppSpacing.vSpace24,
        Text(
          title,
          style: AppTextStyles.authSuccessSectionTitle.copyWith(
            fontSize: 22.sp,
            color: isDark ? AppColors.textWhite : AppColors.textDark,
          ),
        ),
        AppSpacing.vSpace12,
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
