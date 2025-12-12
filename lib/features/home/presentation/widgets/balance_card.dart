// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BalanceCard extends StatelessWidget {
  final double? totalBalance;
  final double? weeklyChangePercentage;

  const BalanceCard({
    super.key,
    this.totalBalance,
    this.weeklyChangePercentage,
  });

  String _formatBalance(double balance) {
    if (balance >= 1000000) {
      return '\$${(balance / 1000000).toStringAsFixed(2)}M';
    } else if (balance >= 1000) {
      return '\$${(balance / 1000).toStringAsFixed(2)}K';
    } else {
      return '\$${balance.toStringAsFixed(2)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final balance = totalBalance ?? 143421.20;
    final weeklyChange = weeklyChangePercentage ?? 10.14;
    final isPositive = weeklyChange >= 0;

    return Container(
      padding: AppSpacing.paddingH24V24,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primary : AppColors.balanceCardBg,
        borderRadius: BorderRadius.circular(AppSizing.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ---- CURRENT BALANCE ----
          Text(
            context.tr.currentBalance,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.balanceCardText.withOpacity(0.7),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3.w,
            ),
          ),

          AppSpacing.gapH8,

          Text(
            _formatBalance(balance),
            style: theme.textTheme.headlineMedium!.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 48.sp,
              letterSpacing: 0.5.w,
            ),
          ),

          AppSpacing.gapH12,

          /// ---- WEEKLY PROFIT ROW ----
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr.weeklyProfit,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.balanceCardText.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  letterSpacing: 0.3.w,
                ),
              ),
              AppSpacing.gapW12,
              Container(
                padding: AppSpacing.paddingH12V6,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppSizing.radius12),
                ),
                child: Text(
                  "${isPositive ? '+' : ''}${weeklyChange.toStringAsFixed(2)}% ${isPositive ? '▲' : '▼'}",
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                    letterSpacing: 0.2.w,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
