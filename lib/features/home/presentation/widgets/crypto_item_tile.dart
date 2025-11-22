// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class TrendingCryptoCard extends StatelessWidget {
  final String name;
  final String symbol;
  final String price;
  final String percentage;
  final Color iconColor;
  final IconData iconData;

  const TrendingCryptoCard({
    super.key,
    required this.name,
    required this.symbol,
    required this.price,
    required this.percentage,
    required this.iconColor,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 192.w,
      height: 110.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Name & Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: theme.textTheme.titleSmall!.copyWith(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.lightSurface
                      : AppColors.marketItem,
                  height: 1.43,
                  fontWeight: FontWeight.w500,
                ),
              ),
              /// Icon
              Container(
                height: 32.h,
                width: 32.w,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 18.sp),
              ),
            ],
          ),

          /// Symbol
          SizedBox(height: 2.h),
          Text(
            symbol,
            style: theme.textTheme.labelMedium!.copyWith(
              height: 1.33,
              fontWeight: FontWeight.w400,
              color: theme.textTheme.bodySmall!.color!.withOpacity(0.6),
            ),
          ),

          const Spacer(),

          /// Price & Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// Price
              Text(
                price,
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.brightness == Brightness.dark
                      ? AppColors.lightSurface
                      : AppColors.marketItem,
                ),
              ),

              /// Percentage
              Row(
                children: [
                  Text(
                    percentage,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    " ▲",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentBlue,
                      fontWeight: FontWeight.w400,
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
