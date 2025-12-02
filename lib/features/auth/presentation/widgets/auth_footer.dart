import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AuthFooter extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooter({
    super.key,
    required this.question,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppSizing.w255,
        height: AppSizing.h52,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: question,
                style: AppTextStyles.authFooterQuestion.copyWith(
                  color: isDark
                      ? AppColors.textGrayLight
                      : AppColors.textGrayFooter,
                  fontSize: 16.sp,
                ),
              ),
              TextSpan(
                text: actionText,
                style: AppTextStyles.authFooterAction.copyWith(
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
