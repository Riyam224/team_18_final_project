import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class MarketCoinTile extends StatelessWidget {
  final String name;
  final int? rank;
  final double? price;
  final double? changePercentage;
  final String? imageUrl;
  final Color accentColor;
  final bool isDark;
  final VoidCallback? onTap;

  const MarketCoinTile({
    super.key,
    required this.name,
    required this.rank,
    required this.price,
    required this.changePercentage,
    required this.imageUrl,
    required this.accentColor,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final changeIsPositive = (changePercentage ?? 0) >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: AppSpacing.paddingH16V14,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppSizing.radius16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Row(
        children: [
          _buildIcon(),
          AppSpacing.gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: isDark ? AppColors.textWhite : AppColors.textBlack,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.gapH8,
                Text(
                  rank != null ? 'Rank #$rank' : 'Rank --',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textGrayLight : AppColors.gray2,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price != null
                    ? '\$${price!.toStringAsFixed((price ?? 0) >= 100 ? 2 : 4)}'
                    : '--',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: isDark ? AppColors.textWhite : AppColors.textBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.gapH8,
              Container(
                padding: AppSpacing.paddingH12V6,
                decoration: BoxDecoration(
                  color: changePercentage == null
                      ? (isDark
                          ? AppColors.darkCard
                          : AppColors.lightSurface2.withOpacity(0.7))
                      : (changeIsPositive
                          ? AppColors.priceUp.withOpacity(0.12)
                          : AppColors.priceDown.withOpacity(0.12)),
                  borderRadius: BorderRadius.circular(AppSizing.radius16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      changePercentage == null
                          ? Icons.remove
                          : changeIsPositive
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                      size: 14.sp,
                      color: changePercentage == null
                          ? (isDark
                              ? AppColors.textGrayLight
                              : AppColors.gray3)
                          : changeIsPositive
                              ? AppColors.priceUp
                              : AppColors.priceDown,
                    ),
                    AppSpacing.gapW4,
                    Text(
                      changePercentage == null
                          ? '--'
                          : '${changeIsPositive ? '' : '-'}${changePercentage!.abs().toStringAsFixed(1)}%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: changePercentage == null
                            ? (isDark
                                ? AppColors.textGrayLight
                                : AppColors.gray3)
                            : changeIsPositive
                                ? AppColors.priceUp
                                : AppColors.priceDown,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildIcon() {
    final size = AppSizing.w50;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.16),
        borderRadius: BorderRadius.circular(AppSizing.radius16),
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizing.radius12),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                height: size,
                width: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.currency_bitcoin,
                  size: 26.sp,
                  color: accentColor,
                ),
              )
            : Icon(
                Icons.currency_bitcoin,
                size: 26.sp,
                color: accentColor,
              ),
      ),
    );
  }
}
