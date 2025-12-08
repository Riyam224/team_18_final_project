import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String valueChange;
  final bool isBuy;

  const TransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.valueChange,
    required this.isBuy,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark();
    final iconColor = isBuy ? AppColors.priceUp : AppColors.alertRed;
    final icon = isBuy ? Icons.arrow_upward : Icons.arrow_downward;
    final cardColor = isDark ? AppColors.darkBackground : Colors.white;
    final textColor = isDark ? AppColors.textWhite : AppColors.textGray;
    final subColor = isDark ? AppColors.textGrayLight : AppColors.gray3;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.25)
        : Colors.black.withOpacity(0.04);

    return Container(
      margin: AppSpacing.marginB10,
      padding: AppSpacing.paddingAll14,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizing.radius14),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: AppSizing.shadowBlurMedium,
            offset: Offset(0, AppSizing.shadowOffsetMedium),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: AppSizing.h36,
            width: AppSizing.w36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: iconColor.withOpacity(0.4)),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: AppSizing.iconXSmall,
            ),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? textColor : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: subColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                ),
              ),
              Text(
                valueChange,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isBuy ? AppColors.priceUp : AppColors.alertRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
