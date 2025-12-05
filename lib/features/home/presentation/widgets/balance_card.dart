import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.paddingAll20,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.balanceCardDark : AppColors.balanceCardLight,
        borderRadius: BorderRadius.circular(AppSizing.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.currentBalance,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textWhite.withValues(alpha: 0.8),
              fontSize: 14.sp,
            ),
          ),
          AppSpacing.gapH4,
          Text(
            "\$143,421.20",
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textWhite,
              fontWeight: FontWeight.bold,
              fontSize: 28.sp,
            ),
          ),
          AppSpacing.gapH12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.weeklyProfit,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textWhite,
                  fontSize: 14.sp,
                ),
              ),
              Container(
                padding: AppSpacing.paddingH10V4,
                decoration: BoxDecoration(
                  color: AppColors.textWhite.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizing.radius12),
                ),
                child: Text(
                  "2.35% ▲",
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
