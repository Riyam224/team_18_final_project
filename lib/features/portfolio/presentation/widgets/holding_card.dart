import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_constants.dart';

class HoldingCard extends StatelessWidget {
  final String name;
  final String symbol;
  final double percentage;
  final String amount;
  final String value;
  final String change;
  final String changePercent;
  final IconData icon;
  final Color iconColor;
  final String? iconAsset;

  const HoldingCard({
    super.key,
    required this.name,
    required this.symbol,
    required this.percentage,
    required this.amount,
    required this.value,
    required this.change,
    required this.changePercent,
    required this.icon,
    required this.iconColor,
    this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final titleColor = isDark ? AppColors.textWhite : AppColors.textGray;
    final subtitleColor = isDark ? AppColors.textGrayLight : AppColors.gray3;

    return Container(
      margin: AppSpacing.marginOnly(bottom: 14),
      padding: AppSpacing.paddingAll16,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizing.radius16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.25)
                : Colors.black.withOpacity(0.04),
            blurRadius: AppSizing.shadowBlurLarge,
            offset: Offset(0, AppSizing.shadowOffsetLarge),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: AppSizing.h38,
                    width: AppSizing.w38,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: iconAsset != null
                          ? Image.asset(
                              iconAsset!,
                              height: AppSizing.h20,
                              width: AppSizing.w20,
                              fit: BoxFit.contain,
                            )
                          : Icon(icon, color: iconColor),
                    ),
                  ),
                  AppSpacing.gapW10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: isDark ? titleColor : AppColors.textGray,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        symbol,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${percentage.toStringAsFixed(AppPortfolioConstants.decimalDigitsForAllocationPercent)}%',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                ),
              ),
            ],
          ),
          AppSpacing.gapH20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amount,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: isDark ? AppColors.textWhite : titleColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.gapH8,
                  Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    change,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.priceUp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.gapH8,
                  Text(
                    changePercent,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.priceUp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
